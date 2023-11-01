# Flow Backend Helm Install Guide

## Install

1. Flow Install

```
helm install -n hyperdata flow flow \
--set image=${HARBOR_URL}/${HARBOR_REPO}/${IMAGE_NAME}:${TAG} \
--set webserver.ip=${MASTER_IP}

```

### mlplatform 따른 유의사항
- mlplatform가 NodePort일 때 18081(default) 포트 설정
- mlplatform가 LoadBalancer일 때 8501 포트 설정
  `--set svc.mlplatform.port=8501` 추가

### SQL Editor Preview 출력 컬럼 수 설정
- 출력 컬럼수 sql-editor.preview-max-row 설정
  ex) `--set sql-editor.preview-max-row=100` 추가

## Uninstall

```
helm uninstall -n hyperdata flow flow
```
