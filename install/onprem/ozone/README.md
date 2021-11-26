# Ozone

1. install ozone
```
helm install -n hyperdata ozone ozone \
--set image=192.168.179.44:5000/hyperdata20.4_ozone:20211124_v1 \
--set datanode.storage.size=10Gi
```

## ref
- https://github.com/apache/ozone