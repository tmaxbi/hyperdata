# Flow Backend Helm Install Guide
- values.yaml 로 세부 설정
- 원하는 이미지 및 태그 확인
```shell
# 전체 이미지 확인
curl http://192.168.179.44:5000/v2/_catalog
# 태그 확인 (hyperdata20.4.0.6.0_flow 이미지 예시)
curl http://192.168.179.44:5000/v2/hyperdata20.4.0.6.0_flow/tags/list
```


## Install

1. Flow Install

```
helm install -n hyperdata flow flow \
--set image=192.168.179.44:5000/${FLOW_IMG_NAME}:${FLOW_IMG_TAG} \
--set webserver.ip=${MASTER_IP}

```

## Uninstall

```
helm uninstall -n hyperdata flow flow
```
