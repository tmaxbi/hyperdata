# Ozone

1. install ozone
```
helm install -n hyperdata ozone ozone \
--set image=192.168.179.44:5000/hyperdata-ozone-v20.5:1.3.0 \
--set datanode.storage.size=100Gi
```

## ref
- https://github.com/apache/ozone
