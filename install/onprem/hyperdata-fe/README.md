# hyperdata

1. install hyperdata-fe

   ```shell
   helm install -n hyperdata hyperdata-fe hyperdata-fe \
   --set image=${HARBOR_URL}/${HARBOR_REPO}/${IMAGE_NAME}:${TAG}
   ```

2. Uninstall hyperdata-fe
   ```shell
   helm uninstall -n hyperdata hyperdata-fe hyperdata-fe
   ```
3. install with CustomLogo

   1. 이미지 파일을 PVC(tibero-pvc)에 저장
      - 경로: pvc 내 temp 디렉토리 안에 저장  
         _ex). /db/temp/front_
      - 이미지 파일 정책: 최대 높이: 22px, 파일명: logo.svg
   2. hyperdata-fe 설치

      ```shell
      helm install -n hyperdata hyperdata-fe hyperdata-fe \
      --set image=${HARBOR_URL}/${HARBOR_REPO}/${IMAGE_NAME}:${TAG} \
      customLogo.path=${path}
      ```

      ```shell
      # Example -
      helm install -n hyperdata hyperdata-fe hyperdata-fe \
      --set image=biqa.tmax.com/hypedata20.5_rel/hyperdata20.5_front:20230427_562b0be6 \
      customLogo.path=/db/temp/front/logo.svg
      ```

   3. 기타 주의 사항
      1. 기존 hyperdata-fe 설치 후 custom logo 사용을 원하면 hyperdata-fe 재설치 필요
      2. custom logo의 경로 변경 시 hyperdata-fe 재설치 필요
      3. 이미지 파일 교체 시, 설치 한 경로에 같은 파일명으로 교체

         ```txt
         #예시

         *logo.svg(기존 파일) -> logo_legacy.svg*
         *logo_new.svg(신규 파일) -> logo.svg*
         ```
