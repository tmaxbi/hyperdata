# Cert-Manager

1. create cert-manager namespace
```
kubectl create namespace cert-manager
```

2. install cert-manager
```
helm install cert-manager -n cert-manager ./cert-manager \
--set installCRDs=true \
--set image.repository=quay.io/jetstack/cert-manager-controller \
--set image.tag=v1.5.2 \
--set webhook.image.repository=quay.io/jetstack/cert-manager-webhook \
--set webhook.image.tag=v1.5.2 \
--set cainjector.image.repository=quay.io/jetstack/cert-manager-cainjector \
--set cainjector.image.tag=v1.5.2 \
--set startupapicheck.image.repository=quay.io/jetstack/cert-manager-ctl \
--set startupapicheck.image.tag=v1.5.2
```

3. wait until cert-manager install end
```
kubectl wait --for=condition=available --timeout=600s deployment/cert-manager-webhook -n cert-manager
```

## ref
- https://cert-manager.io/docs/installation/helm/#steps

## reproduce chart
```
jetstack https://charts.jetstack.io
helm pull jetstack/cert-manager --untar
```