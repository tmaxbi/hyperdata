# hyperdata be common 

** 실행 시 팟 생성 > 작업 완료 후 자동으로 삭제됨. ** \
헬름 차트가 에러없이 실행 완료 됐다면 성공 \
공유 폴더 안에 아래 목록이 모두 생겨야 함.
- /HyperData
- /HyperData/config, temp, logs (폴더 3개)
- /HyperData/config/hd_config.properties

1. install hyperdata-be-common

   ```
   helm install -n hyperdata hyperdata-be-common hyperdata-be-common \
   --set image=${HARBOR_URL}/${HARBOR_REPO}/${IMAGE_NAME}:${TAG}
   ```

2. Uninstall hyperdata-be-common
   ```
   helm uninstall hyperdata-be-common -n hyperdata
   ```
