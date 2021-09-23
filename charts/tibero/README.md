# tibero

1. install tibero
```
helm install -n hyperdata tibero tibero \
--set image=192.168.179.44:5000/hyperdata8.3_tb:20210819_v2 \
--set loadbalancer.ip=${LOADBALANCER_IP}
```