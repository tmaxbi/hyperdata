#!/bin/bash
if [ -n "$1" -a -n "$2" ] ; then
SERVERNUM=$1
STORAGE=$2
else
read -p "SERVER NUM :" SERVERNUM
read -p "STORAGE SIZE (아직사용되지않음):" STORAGE
fi
NS=hyperdata-dev$SERVERNUM
echo $NS


kubectl apply -f config-configmap.yaml
#sleep 10s
kubectl apply -f s3g-service.yaml
#sleep 10s
kubectl apply -f s3g-statefulset.yaml
#sleep 10s
kubectl apply -f scm-service.yaml
#sleep 10s
kubectl apply -f scm-statefulset.yaml


#kubectl describe pod -n $NS om-0 | grep -n "IP:           10.[0-9].[0-9].[0-9]" -m 1

sleep 30s

echo " "
echo "SCMIP찾기"
export SCMIP=`kubectl describe pod -n $NS scm-0 | grep -n "IP:           10.[0-9].[0-9].[0-9]" -m 1 | awk -F " " '{ print($2) }'`


echo "SCMIP :: $SCMIP"
## kubectl describe pod -n hyperdata-dev38 scm-0 | grep -n "IP:           10.[0-9].[0-9].[0-9]" -m 1 | awk -F " " '{ print($2) }'
echo " "
echo "om-statefulset.yaml의 SCM_POD_IP의 value 바꿔넣기"
sed -i "57s/.*/          value: $SCMIP/g" om-statefulset.yaml
##sed -i "57s/.*/          value: 10.244.184.88/g" om-statefulset.yaml
echo " "
echo "OM배포"
kubectl apply -f om-service.yaml
kubectl apply -f om-statefulset.yaml

sleep 20s

echo " "
echo "OMIP찾기"
export OMIP=`kubectl describe pod -n $NS om-0 | grep -n "IP:           10.[0-9].[0-9].[0-9]" -m 1 | awk -F " " '{ print($2) }'`
# kubectl describe pod -n hyperdata-dev38 om-0 | grep -n "IP:           10.[0-9].[0-9].[0-9]" -m 1 | awk -F " " '{ print($2) }'




echo "OMIP : $OMIP"
echo " "
echo "OMIP를 datanode-statefulset.yaml에 바꿔넣기"
sed -i "61s/.*/          value: $OMIP/g" datanode-statefulset.yaml

#sed -i "61s/.*/          value: 10.244.184.78/g" datanode-statefulset.yaml
echo " "
echo "DATANODE배포"
kubectl apply -f datanode-service.yaml
kubectl apply -f datanode-statefulset.yaml

