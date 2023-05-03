# visual analytics 시각화

1. install (--set image에 희망하는 이미지를 사용)

   1.1 LoadBalancer 사용시
   ```
   helm install -n hyperdata visualanalytics visualanalytics \
   --set image=${HARBOR_URL}/${HARBOR_REPO}/${IMAGE_NAME}:${TAG} \
   --set https.enabled={true/false} \
   --set server.ip={서버 ip} \
   --set server.port={서버 nodeport 포트} \
   --set hyperdata.share.host_url={viewer에 사용할 url (기본값 : server.ip와 동일하게 입력)} \
   --set hyperdata.share.port={viewer에 사용할 port (기본값 : server.port와 동일하게 입력)}
   ```

   1.2 NodePort 사용시
   ```
   helm install -n hyperdata visualanalytics visualanalytics \
   --set image=${HARBOR_URL}/${HARBOR_REPO}/${IMAGE_NAME}:${TAG} \
   --set loadBalancer.enabled=false \
   --set https.enabled={true/false} \
   --set server.ip={서버 ip} \
   --set server.port={서버 nodeport 포트} \
   --set hyperdata.share.host_url={viewer에 사용할 url (기본값 : server.ip와 동일하게 입력)} \
   --set hyperdata.share.port={viewer에 사용할 port (기본값 : server.port와 동일하게 입력)}
   ```

2.  Uninstall visualanalytics
   ```
   helm uninstall -n hyperdata visualanalytics visualanalytics
   ```
