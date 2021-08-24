# mlplatform

1. install hyperdata
```
helm install -n hyperdata hyperdata hyperdata \
--set image=192.168.179.44:5000/hyperdata20.4_hd:20210824091745 \
--set webserver.ip=192.168.179.39 \
--set webserver.port=8080
```