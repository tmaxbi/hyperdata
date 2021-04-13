#!/bin/bash
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

export $(grep -v '^#' image_config.properties | xargs -d '\n')

# REMOTE_REGISTRY가 설정되어 있을 경우, remote_registry에서 가져오도록 주소 맨뒤에 /를 추가
# 설정되어있지 않을 경우, empty string으로 설정하여 dockerhub에서 가져오도록 설정
# ex. REMOTE_REGISTRY=172.17.0.1:5000 => docker pull 172.17.0.1:5000/hyperdata8.3_tb:20210230_v1
# ex. REMOTE_REGISTRY="" => docker pull hyperdata8.3_tb:20210230_v1
if [ -z "${REMOTE_REGISTRY}" ]; then
  REMOTE_REGISTRY=""
else
  REMOTE_REGISTRY=${REMOTE_REGISTRY}/
fi

# images 폴더 생성
mkdir -p images

function pull_and_save_image {
  file_path=$1
  image_name=$2
  image_tag=$3
  if [ ! -f ${file_path} ]; then
    echo "${file_path} 준비 중..."
    sudo docker pull ${REMOTE_REGISTRY}${image_name}:${image_tag}
    [[ $? -ne 0 ]] && echo "docker pull을 실패하였습니다." && exit 1
    sudo docker save ${REMOTE_REGISTRY}${image_name}:${image_tag} > ${file_path}
    [[ $? -ne 0 ]] && echo "docker save를 실패하였습니다." && exit 1
    echo "완료"
  else
    echo "${file_path}가 이미지 존재하므로 스킵합니다."
  fi
} 

pull_and_save_image images/installer_${INSTALLER_TAG}.tar hyperdata_installer ${INSTALLER_TAG}
pull_and_save_image images/tb_${TB_TAG}.tar hyperdata8.3_tb ${TB_TAG}
pull_and_save_image images/nginx_controller_${NGINX_CONTROLLER_TAG}.tar ingress-nginx/controller ${NGINX_CONTROLLER_TAG}
pull_and_save_image images/nginx_certgen_${NGINX_CERTGEN_TAG}.tar jettech/kube-webhook-certgen ${NGINX_CERTGEN_TAG}
pull_and_save_image images/hyperdata_${HD_TAG}.tar hyperdata8.3_hd_v8.3.4hotpatch ${HD_TAG}
pull_and_save_image images/automl_${AUTOML_TAG}.tar hyperdata8.3_automl ${AUTOML_TAG}
pull_and_save_image images/automl_doloader_${DOLOADER_TAG}.tar hyperdata8.3_automl_doloader ${DOLOADER_TAG}
pull_and_save_image images/automl_fe_${FE_TAG}.tar hyperdata8.3_automl_fe ${FE_TAG}
pull_and_save_image images/automl_xgb_${XGB_TAG}.tar hyperdata8.3_automl_hpb_xgb ${XGB_TAG}
pull_and_save_image images/automl_rf_${RF_TAG}.tar hyperdata8.3_automl_hpb_rf ${RF_TAG}
pull_and_save_image images/automl_downloader_${DOWNLOADER_TAG}.tar hyperdata8.3_automl_downloader ${DOWNLOADER_TAG}
pull_and_save_image images/automl_scheduler_${SCHEDULER_TAG}.tar hyperdata8.3_scheduler ${SCHEDULER_TAG}
pull_and_save_image images/automl_woori_${WOORI_TAG}.tar hyperdata8.3_predefinedai_woori_text_classification_train ${WOORI_TAG}
pull_and_save_image images/automl_resultuploader_${RESULTUPLOADER_TAG}.tar hyperdata8.3_predefinedai_woori_text_classification_resultuploader ${RESULTUPLOADER_TAG}
pull_and_save_image images/automl_domainserving_${DOMAINSERVING_TAG}.tar hyperdata8.3_predefinedai_text_classification_serving ${DOMAINSERVING_TAG}
pull_and_save_image images/automl_wooriserving_${WOORISERVING_TAG}.tar hyperdata8.3_predefinedai_woori_text_classification_serving ${WOORISERVING_TAG}
