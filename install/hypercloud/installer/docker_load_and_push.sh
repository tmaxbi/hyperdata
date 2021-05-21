#!/bin/bash
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

export $(grep -v '^#' image_config.properties | xargs -d '\n')

function docker_tag_exists {
  image_name=$1
  image_tag=$2

  curl --silent -f --head -lL https://${LOCAL_REGISTRY}/v2/repositories/${image_name}/tags/${image_tag}/ > /dev/null
}

function load_and_push_image {
  file_path=$1
  image_name=$2
  image_tag=$3

  if docker_tag_exists ${image_name} ${image_tag}; then
    echo "${LOCAL_REGISTRY}/${image_name}:${image_tag}가 이미 존재하므로 스킵합니다."
  else
    echo "${LOCAL_REGISTRY}/${image_name}:${image_tag} 준비중..."
    sudo docker load --input ${file_path}
    [[ $? -ne 0 ]] && echo "docker load를 실패하였습니다." && exit 1
    echo "${LOCAL_REGISTRY}/${image_name}:${image_tag} docker load"
    sudo docker tag ${REMOTE_REGISTRY}/${image_name}:${image_tag} ${LOCAL_REGISTRY}/${image_name}:${image_tag}
    [[ $? -ne 0 ]] && echo "docker tag를 실패하였습니다." && exit 1
    echo "${LOCAL_REGISTRY}/${image_name}:${image_tag} docker tag"
    sudo docker push ${LOCAL_REGISTRY}/${image_name}:${image_tag}
    [[ $? -ne 0 ]] && echo "docker push를 실패하였습니다." && exit 1
    echo "${LOCAL_REGISTRY}/${image_name}:${image_tag} docker push"
    echo "완료"
  fi
}

load_and_push_image images/installer_${INSTALLER_TAG}.tar hyperdata_installer ${INSTALLER_TAG}
load_and_push_image images/tb_${TB_TAG}.tar hyperdata8.3_tb ${TB_TAG}
load_and_push_image images/nginx_controller_${NGINX_CONTROLLER_TAG}.tar ingress-nginx/controller ${NGINX_CONTROLLER_TAG}
load_and_push_image images/nginx_certgen_${NGINX_CERTGEN_TAG}.tar jettech/kube-webhook-certgen ${NGINX_CERTGEN_TAG}
load_and_push_image images/hyperdata_${HD_TAG}.tar hyperdata8.3_hd_v8.3.4hotpatch ${HD_TAG}
load_and_push_image images/automl_${AUTOML_TAG}.tar hyperdata8.3_automl ${AUTOML_TAG}
load_and_push_image images/automl_doloader_${DOLOADER_TAG}.tar hyperdata8.3_automl_doloader ${DOLOADER_TAG}
load_and_push_image images/automl_fe_${FE_TAG}.tar hyperdata8.3_automl_fe ${FE_TAG}
load_and_push_image images/automl_xgb_${XGB_TAG}.tar hyperdata8.3_automl_hpb_xgb ${XGB_TAG}
load_and_push_image images/automl_rf_${RF_TAG}.tar hyperdata8.3_automl_hpb_rf ${RF_TAG}
load_and_push_image images/automl_downloader_${DOWNLOADER_TAG}.tar hyperdata8.3_automl_downloader ${DOWNLOADER_TAG}
load_and_push_image images/automl_scheduler_${SCHEDULER_TAG}.tar hyperdata8.3_scheduler ${SCHEDULER_TAG}
load_and_push_image images/automl_woori_${WOORI_TAG}.tar hyperdata8.3_predefinedai_woori_text_classification_train ${WOORI_TAG}
load_and_push_image images/automl_resultuploader_${RESULTUPLOADER_TAG}.tar hyperdata8.3_predefinedai_woori_text_classification_resultuploader ${RESULTUPLOADER_TAG}
load_and_push_image images/automl_domainserving_${DOMAINSERVING_TAG}.tar hyperdata8.3_predefinedai_text_classification_serving ${DOMAINSERVING_TAG}
load_and_push_image images/automl_wooriserving_${WOORISERVING_TAG}.tar hyperdata8.3_predefinedai_woori_text_classification_serving ${WOORISERVING_TAG}
