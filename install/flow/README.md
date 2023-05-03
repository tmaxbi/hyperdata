# Flow Backend Helm Install Guide

## Install

1. Flow Install

```
helm install -n hyperdata flow flow \
--set image=${HARBOR_URL}/${HARBOR_REPO}/${IMAGE_NAME}:${TAG} \
--set webserver.ip=${MASTER_IP}

```

## Uninstall

```
helm uninstall -n hyperdata flow flow
```
