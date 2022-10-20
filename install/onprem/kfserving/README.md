# kfserving

kfserving은 공식적으로 helm chart가 존재하지 않습니다.

helm으로 관리하기 위해 설치 시 사용하는 yaml들을 helm으로 wrapping 합니다.

1. create kfserving namespace
```
kubectl apply -f namespace.yaml
```

2. install kfserving

kfserving agent tarfile 관련 bug로 tarfile 내 directory가 있으면 tarfile을 풀지 못하는 현상이 있습니다.
이를 해결한 image를 별도로 dockering하여 QA image registry에 push 했으니 agent-*.json 파일 내에 해당 image name을 입력하여 사용하여야 정상동작합니다.

*example json*
```
{
    "image" : "192.1.1.96:31234/kserve/agent:v0.6.0-bugfix",
    "memoryRequest": "100Mi",
    "memoryLimit": "1Gi",
    "cpuRequest": "100m",
    "cpuLimit": "1"
}
```


```
helm install -n kfserving-system kfserving kfserving \
--set modelsWebApp.image=kfserving/models-web-app:v0.6.0 \
--set controller.image=kfserving/kfserving-controller:v0.6.1 \
--set manager.image=kubebuilder/kube-rbac-proxy:v0.4.0
```

3. enable kfserving

hyperdata 및 mlplatform을 설치할 namespace에 해당 label을 추가하여야 serving을 사용할 수 있습니다.
```
kubectl label --overwrite namespaces hyperdata serving.kubeflow.org/inferenceservice=enabled
```

## ref
- https://github.com/knative/serving/tree/v0.22.0

## reproduce chart
```
kubectl apply --filename https://github.com/knative/serving/releases/download/${KNATIVE_VERSION}/serving-crds.yaml
kubectl apply --filename https://github.com/knative/serving/releases/download/${KNATIVE_VERSION}/serving-core.yaml
kubectl apply --filename https://github.com/knative/net-istio/releases/download/${KNATIVE_VERSION}/release.yaml
```
