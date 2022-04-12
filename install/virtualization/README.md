# virtualization-spring

1. install virtualization-spring 
   
   1.1 LoadBalancer 사용시
   ```
   helm install -n hyperdata virtualization-spring virtualization-spring \
   --values ./virtualization-spring/values.yaml \
   --set image=192.168.179.44:5000/hyperdata8.3_virtualization:20211210_v1 \
   --set db.address=lb-db-dev41 \
   --set db.port=8629 \
   --set hyperdata.address=svc-hd-dev41 \
   --set hyperdata.port=8080 \
   --set loadBalancer.ip=${LOADBALANCER_IP} \
   --set loadBalancer.extport=8500 \
   --set pvc.name=pvc-db-dev41 \
   --set pvc.mountpath=/db \
   --set logging.path=virtualization/logs
   ```
   
   1.2 NodePort 사용시
   ```
   helm install -n hyperdata virtualization-spring virtualization-spring \
   --values ./virtualization-spring/values.yaml \
   --set image=192.168.179.44:5000/hyperdata8.3_virtualization:20211210_v1 \
   --set db.address=lb-db-dev41 \
   --set db.port=8629 \
   --set hyperdata.address=svc-hd-dev41 \
   --set hyperdata.port=8080 \
   --set loadBalancer.enabled=false \
   --set pvc.name=pvc-db-dev41 \
   --set pvc.mountpath=/db \
   --set logging.path=virtualization/logs
   ```
   cf) 제대로 된 설치가 안 될시 helm 차트를 아래에 명령어에 따라서 삭제한 후 재가동한다.

2.  Uninstall virtualization
```
helm uninstall -n hyperdata virtualization-spring virtualization-spring
```
