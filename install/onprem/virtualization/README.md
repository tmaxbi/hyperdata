# virtualization-spring

1. install virtualization-spring-    이미지에는 희망하는 이미지를 사용하시면 됩니다. 
   
   1.1 LoadBalancer 사용시
   ```
   helm install -n hyperdata virtualization-spring virtualization-spring \
   --values ./virtualization-spring/values.yaml \
   --set image=192.168.179.44:5000/hyperdata8.3_virtualization:20211210_v1 \
   ```
   
   1.2 NodePort 사용시
   ```
   helm install -n hyperdata virtualization-spring virtualization-spring \
   --values ./virtualization-spring/values.yaml \
   --set image=192.168.179.44:5000/hyperdata8.3_virtualization:20211210_v1 \
   --set loadBalancer.enabled=false \
   ```
   cf) 제대로 된 설치가 안 될시 helm 차트를 아래에 명령어에 따라서 삭제한 후 재가동한다.

2.  Uninstall virtualization
```
helm uninstall -n hyperdata virtualization-spring virtualization-spring
```
