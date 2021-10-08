# tibero

1. install tibero

  1.1 LoadBalancer 사용시
  ```
  helm install -n hyperdata tibero tibero \
  --set image=192.168.179.44:5000/hyperdata8.3_tb:20210819_v2 \
  --set loadbalancer.ip=${LOADBALANCER_IP}
  ```
  
  1.1 NodePort 사용시
  ```
  helm install -n hyperdata tibero tibero \
  --set image=192.168.179.44:5000/hyperdata8.3_tb:20210819_v2 \
  --set loadbalancer.enabled=false
  ```

2. Uninstall tibero
```
helm uninstall -n hyperdata tibero tibero
```
