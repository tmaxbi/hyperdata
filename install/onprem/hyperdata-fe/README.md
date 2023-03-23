# hyperdata

1. install hyperdata

   ```
   helm install -n hyperdata hyperdata-fe hyperdata-fe \
   --set image=${HARBOR_URL}/${HARBOR_REPO}/${IMAGE_NAME}:${TAG}
   ```

2. Uninstall hyperdata
   ```
   helm uninstall -n hyperdata hyperdata-fe hyperdata-fe
   ```
