# hyperdata

1. install hyperdata

   ```
   helm install -n hyperdata hyperdata_fe hyperdata_fe \
   --set imaage=${HARBORURL}/${HARBOR_REPO}/${IMAGE_NAME}:${TAG}
   ```

2. Uninstall hyperdata
   ```
   helm uninstall -n hyperdata hyperdata_fe hyperdata_fe
   ```
