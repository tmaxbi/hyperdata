# tibero

1. install tibero

    1.1 LoadBalancer 사용시
   ```
   helm install -n hyperdata tibero tibero \
    --set image=${HARBOR_URL}/${HARBOR_REPO}/${IMAGE_NAME}:${TAG} \
    --set loadbalancer.ip=${LOADBALANCER_IP}
    ```
  
    1.2 NodePort 사용시
   ```
   helm install -n hyperdata tibero tibero \
   --set image=${HARBOR_URL}/${HARBOR_REPO}/${IMAGE_NAME}:${TAG} \
   --set loadbalancer.enabled=false
   ```

2. Uninstall tibero
```
helm uninstall -n hyperdata tibero tibero
```
