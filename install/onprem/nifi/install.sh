#!/bin/bash

function print_help() {
  echo "
  [Manual]
  Nifi 환경구축 전 다음 주의사항을 확인바랍니다.
    1) Kubernetes, Helm 환경이 준비되어야합니다.
    2) Kubernetes - default storage class가 정의되어 있어야 합니다.
    3) Nifi 구축을 위한 k8s Namespace를 사전에 정의되어 있어야 합니다.
    	"- kubectl create ns \"Namespace명\" 명령어로 Namespace를 만들 수 있습니다."
    4) Ozone Storage가 동일 Namespace에 구축되어 있어야 합니다.

  [Usage]
    1) Install: . install.sh install \"Namespace명\"
	ex) . install.sh install hyperdata
    2) Uninstall: . install.sh uninstall \"Namespace명\"
 	ex) . install.sh uninstall hyperdata
    3) upload: . install.sh upload
        - Nifi 동기화 과정때문에 설치과정에서 template Flow 업로드가 안될 수 있습니다.
        - 위 경우 upload 명령어를 입력하여 template을 업로드 할 수 있습니다.    
" >&2
}

function wait_condition_1() {
  cond=$1
  timeout=$2

  for ((i=0; i< timeout; i+=5)); do
    echo "Waiting for ${i}s condition: \"$cond\""
    if eval $cond >/dev/null 2>&1; then
      echo "Condition met"
      return 0
    fi
    sleep 5
    eval $cond
  done

  echo "Condition timeout"
  return 1
}

function wait_condition_2() {
 cond=$1
 timeout=$2

 for ((i=0; i< timeout; i+=5)); do
   echo "Waiting for ${i}s condition: \"$cond\""
   var=$(eval "$cond")
   if [[ -z $var ]]; then
     echo "Condition met"
     return 0
   fi
   sleep 5
done 

 echo "Condition timeout"
 return 1
}


function dev_up() {
 # cond=$(helm repo list | grep "dysnix")
 # cond2=$(helm repo list | grep "bitnami")
 # if [[ -n $cond ]]; then
 #  echo "dysnix repo already added"
 # else
 #  helm repo add dysnix https://dysnix.github.io/charts/
 # fi
 # if [[ -n $cond2 ]]; then
 #  echo "bitnami repo already added"
 # else
 #  helm repo add bitnami https://charts.bitnami.com/bitnami 
 # fi
  cd ./helm-nifi
  helm dep up
#  helm repo update
  cd ../
}

function install_nifi() {
  helm install nifi ./helm-nifi/. -n "${1}"
  wait_condition_1 "kubectl get po nifi-0 -n ${1} | grep 4/4" 240
}

function uninstall_nifi() {
  helm uninstall nifi -n "${1}"
  wait_condition_2 "kubectl get po nifi-0 -n ${1} | grep nifi-0" 120 
}

function get_nodeip() {
  kubectl get nodes --selector=node-role.kubernetes.io/master -o jsonpath='{$.items[*].status.addresses[?(@.type=="InternalIP")].address}'
}


function run_install()
{
    ## Prompt the user 
    read -p "Do you want to install missing libraries? [Y/n]: " answer
    ## Set the default value if no answer was given
    answer=${answer:Y}
    ## If the answer matches y or Y, install
    [[ $answer =~ [Yy] ]] && sudo apt-get install ${1}
}

function check_packages() {

packages=("curl" "jq" "xmlstarlet")

for pkg in ${packages[@]}; do

    is_pkg_installed=$(dpkg-query -W --showformat='${Status}\n' ${pkg} | grep "install ok installed")

    if [ "${is_pkg_installed}" == "install ok installed" ]; then
        echo ${pkg} is installed.
    else
      dpkg -s "${packages[@]}" >/dev/null 2>&1 || run_install ${pkg}
    fi
done
}

# function update_ozone_xml() {
#  OMPORT=$(kubectl get svc -n ${1} | grep om | grep -Po ':[0-9]{1,5}' | sed -n '2 p' | sed 's/^://')
#  SCMPORT=$(kubectl get svc -n ${1} | grep scm | grep -Po ':[0-9]{1,5}' | sed 's/^://')
#  OMADDRESS=$(get_nodeip):$OMPORT
#  SCMADDRESS=$(get_nodeip):$SCMPORT
#  xmlstarlet ed -u "(//property/value)[1]" -v $OMADDRESS -u "(//property/value)[3]" -v $SCMADDRESS ./conf-files/ozoneconf/ozone-site-default.xml >> ./conf-files/ozoneconf/ozone-site.xml
# }

function move_conf() {
  # rm ./conf-files/ozoneconf/ozone-site.xml >/dev/null 2>&1
  # update_ozone_xml ${1}
  ### copy updated ozone-site.xml to ozone-1.0.0 folder
  cp ./conf-files/ozoneconf/ozone-site.xml ./conf-files/ozone-1.0.0/etc/hadoop/
  kubectl cp -n ${1} ./conf-files/ozone-1.0.0 nifi-0:/opt/nifi/nifi-current/conf/ozone-conf/
  kubectl cp -n ${1} ./conf-files/ozone_control.sh nifi-0:/opt/nifi/nifi-current/conf/ozone-conf/
  
  kubectl cp -n ${1} ./conf-files/ozoneconf/core-site.xml nifi-0:/opt/nifi/nifi-current/conf/ozone-conf/ 
  #>/dev/null 2>&1
  kubectl cp -n ${1} ./conf-files/ozoneconf/ozone-site.xml nifi-0:/opt/nifi/nifi-current/conf/ozone-conf/ 
  #>/dev/null 2>&1
  kubectl cp -n ${1} ./conf-files/ozoneconf/hadoop-ozone-filesystem-hadoop3-1.0.0.jar nifi-0:/opt/nifi/nifi-current/conf
  # >/dev/null 2>&1
  echo "[Installed] Ozone config-files are stored in correct path "
}

function upload_template() {
  NIFIPORT=$(kubectl get svc -n ${1} | grep nifi | grep -Po ':[0-9]{1,5}' | sed 's/^://')
  timeout=240
  for ((i=0; i<timeout; i+=5)); do
    echo "Waiting for Nifi initializing state ${i}s"
    ROOTID=$(curl -s -X GET http://$(get_nodeip):$NIFIPORT/nifi-api/process-groups/root | jq -r '.id' 2> /dev/null)
    if [[ -n $ROOTID ]]; then
      echo "[Completed] Nifi finished initializing and waiting for Node initializing "
      TemplateUpload=$(curl -s -X POST -F template=@./conf-files/MinifiToOzone.xml http://$(get_nodeip):$NIFIPORT/nifi-api/process-groups/$ROOTID/templates/upload | grep $ROOTID)
      TemplateUploadAlreadyExists=$(curl -s -X POST -F template=@./conf-files/MinifiToOzone.xml http://$(get_nodeip):$NIFIPORT/nifi-api/process-groups/$ROOTID/templates/upload | grep "already") 
      if [[ -n $TemplateUpload ]]; then
        echo "[Installed] Template for Minifi-Ozone flow is uploaded successfully"
        return 0
      elif [[ -n $TemplateUploadAlreadyExists ]]; then
        echo "[Installed] Template for Minifi-Ozone flow is already exist"
        return 0
      fi
    fi
    sleep 5
  done     

  echo "[Failed] Timeout Nifi initializing state
        Try \"./install.sh upload\" later "
  return 1
}

case "${1:-}" in
install)
  dev_up
  install_nifi "${2}"
  # check_packages
  # move_conf "${2}"
  upload_template "${2}"
  ;;
uninstall)
  uninstall_nifi "${2}"
  ;;
upload)
  upload_template "${2}"
  ;;
move)
  move_conf "${2}"
  ;;
*)
  print_help
  ;;
esac
