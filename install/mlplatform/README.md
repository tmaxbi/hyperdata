# mlplatform

1. 이미지에는 희망하는 이미지를 사용하시면 됩니다. 
   
   1. mysql 
   ```
   helm install -n hyperdata ml-mysql ml-mysql \
   --set mysql.image=192.1.1.88:31234/mlplatform/hyperdata20.5_mlplatform/mysql:20230623_v1
   ```

   2.1 mlplatform - NodePort 사용시
   ```
   helm install -n hyperdata mlplatform mlplatform \
   --set backend.image=192.168.179.44:5000/hyperdata20.5_rel/hyperdata20.5_mlplatform:20230619_v1 \
   --set solution.image=192.168.179.44:5000/hyperdata20.5_rel/hyperdata20.5_agent:20230619_v1 \
   ```
   
   2.2 mlplatform - LoadBalancer 사용시
   ```
   helm install -n hyperdata mlplatform mlplatform \
   --set loadBalancer.enabled=true \
   --set loadBalancer.ip=192.1.1.99 \ 
   --set backend.image=192.168.179.44:5000/hyperdata20.5_rel/hyperdata20.5_mlplatform:20230619_v1 \
   --set solution.image=192.168.179.44:5000/hyperdata20.5_rel/hyperdata20.5_agent:20230619_v1 \
   ```
   cf) 제대로 된 설치가 안 될시 helm 차트를 아래에 명령어에 따라서 삭제한 후 재가동한다.
   mysql 파드가 정상적으로 실행 되기 전까지는 mlplatform 파드에서 에러 발생할 수 있지만 알아서 restart하니까 몇분 기다려야 함 

2.  Uninstall mlplatform
```
helm uninstall -n hyperdata ml-mysql
helm uninstall -n hyperdata mlplatform
kubectl delete pvc -n hyperdata mlplatform-backend-pvc mlplatform-mysql-pvc
```
