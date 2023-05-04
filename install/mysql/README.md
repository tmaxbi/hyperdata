# mysql

1. install mysql

```
helm install  mysql mysql -n hyperdata \
--set image=${HARBOR_URL}/${HARBOR_REPO}/${IMAGE_NAME}:${TAG}
```

2. uninstall mysql

```
helm uninstall  mysql mysql -n hyperdata
```
