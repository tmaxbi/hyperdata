# Ozone

1. install ozone
```
helm install -n hyperdata ozone ozone \
--set image=apache/ozone:1.0.0 \
--set datanode.storage.size=10Gi
```

## ref
- https://github.com/apache/ozone