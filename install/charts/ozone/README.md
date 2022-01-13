# Ozone

1. install ozone
```
helm install -n hyperdata ozone ozone \
--set image=192.168.179.44:5000/hyperdata20.4_ozone:20211124_v1 \
<<<<<<< Updated upstream
--set datanode.storage.size=50Gi
=======
--set datanode.storage.size=50Gi \
--set om.service.type=NodePort \
--set om.service.nodePorts.om=31906 \
--set om.service.nodePorts.ssvrListener=32301 \
--set om.service.nodePorts.javaAgent=30441
>>>>>>> Stashed changes
```

## ref
- https://github.com/apache/ozone
