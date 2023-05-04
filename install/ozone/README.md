# Ozone

1. install ozone
```
helm install -n hyperdata ozone ozone \
--set image=${HARBOR_URL}/${HARBOR_REPO}/${IMAGE_NAME}:${TAG} \
--set datanode.storage.size=100Gi
```

2. Uninstall ozone
```
helm uninstall -n hyperdata ozone ozone
```

## ref
- https://github.com/apache/ozone
