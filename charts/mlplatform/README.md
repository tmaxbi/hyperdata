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
# values.yaml을 환경에 맞게 적절히 수정
helm install -n hyperdata mlplatform .
```