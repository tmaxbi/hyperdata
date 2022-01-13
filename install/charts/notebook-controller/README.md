# kubeflow

notebook controller는 공식적으로 helm chart가 존재하지 않습니다.

helm으로 관리하기 위해 설치 시 사용하는 yaml들을 helm으로 wrapping 합니다.

1. create notebook-controller namespace
```
kubectl create namespace notebook-controller
```

2. install notebook-controller
```
helm install -n notebook-controller notebook-controller notebook-controller \
--set image=gcr.io/kubeflow-images-public/notebook-controller:v1.0.0-gcd65ce25
```

## ref
- https://github.com/kubeflow/manifests/tree/v1.0.2/jupyter/notebook-controller

## reproduce chart
```
git clone --branch v1.0-branch --single-branch https://github.com/kubeflow/manifests.git
sed -i "s/- params.env//g" manifests/jupyter/notebook-controller/base/kustomization.yaml
sed -i "s/- envs:/- env: params.env/g" manifests/jupyter/notebook-controller/base/kustomization.yaml
sed -i "s/namespace: kubeflow/namespace: ${MLPLATFORM_NAMESPACE}/g" manifests/jupyter/notebook-controller/base/kustomization.yaml
sed -i "s/kubeflow\/kubeflow-gateway/istio-system\/ingressgateway/g" manifests/jupyter/notebook-controller/overlays/istio/params.env
kubectl apply -n ${MLPLATFORM_NAMESPACE} -k manifests/jupyter/notebook-controller/overlays/istio
```
