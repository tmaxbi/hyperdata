# mlplatform

1. enable kfserving
```
kubectl label namespaces hyperdata serving.kubeflow.org/inferenceservice=enabled
```

2. enable registriesSkippingTagResolving
```
kubectl get cm -n knative-serving config-deployment -o yaml | \
sed -z "s/\ndata:\n/\ndata:\n  registriesSkippingTagResolving: \"${REGISTRY_IP}:${REGISTRY_PORT}\"\n/g" | \
kubectl apply -f -
```

3. install mlplatform
```
helm install -n hyperdata mlplatform mlplatform \
--set registry.address=192.168.179.44:5000 \
--set backend.image.name=hyperdata20.4_mlplatform_backend \
--set backend.image.tag=20210820_v1 \
--set frontend.image.name=hyperdata20.4_mlplatform_frontend \
--set frontend.image.tag=20210820_v1 \
--set backend.volume.storageClass=csi-cephfs \
--set hyperdata.address=http://192.168.179.44:5000 \
--set kubernetes.istio.ingressgateway.ip=${MASTER NODE'S IP} \
--set kubernetes.istio.ingressgateway.port=31380
```