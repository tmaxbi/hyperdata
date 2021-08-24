# kfserving

kfserving은 공식적으로 helm chart가 존재하지 않습니다.

helm으로 관리하기 위해 설치 시 사용하는 yaml들을 helm으로 wrapping 합니다.

1. create kfserving namespace
```
kubectl apply -f namespace.yaml
```

2. install kfserving
```
helm install -n kfserving-system kfserving kfserving \
--set modelsWebApp.image=kfserving/models-web-app:v0.6.0 \
--set controller.image=gcr.io/kfserving/kfserving-controller:v0.6.0 \
--set manager.image=gcr.io/kubebuilder/kube-rbac-proxy:v0.4.0
```

## ref
- https://github.com/knative/serving/tree/v0.22.0

## reproduce chart
```
kubectl apply --filename https://github.com/knative/serving/releases/download/${KNATIVE_VERSION}/serving-crds.yaml
kubectl apply --filename https://github.com/knative/serving/releases/download/${KNATIVE_VERSION}/serving-core.yaml
kubectl apply --filename https://github.com/knative/net-istio/releases/download/${KNATIVE_VERSION}/release.yaml
```