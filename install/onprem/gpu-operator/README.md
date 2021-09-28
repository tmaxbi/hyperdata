# argo

1. create argo namespace
```
kubectl create namespace gpu-operator-resources
```

2. install argo
- docker 사용시 operator.defaultRuntime=docker, cri-o 사용 시 operator.defaultRuntime=crio로 설정
- driver 버전은 반드시 ""를 포함해서 입력
- driver 버전은 반드시 설치하려하는 노드에 존재하는 gpu의 종류와 호환되는 버전을 선택

```
helm install -n gpu-operator-resources gpu-operator gpu-operator \
--set operator.defaultRuntime=docker \
--set driver.enabled=true \
--set toolkit.enabled=true \
--set dcgm.enabled=false \
--set migManager.enabled=false \
--set nodeStatusExporter.enabled=false \
--set validator.repository=nvcr.io/nvidia/cloud-native \
--set validator.image=gpu-operator-validator \
--set validator.version=v1.8.2 \
--set operator.repository=nvcr.io/nvidia \
--set operator.image=gpu-operator \
--set operator.version=v1.8.2 \
--set operator.initContainer.repository=nvcr.io/nvidia \
--set operator.initContainer.image=cuda \
--set driver.repository=nvcr.io/nvidia \
--set driver.image=driver \
--set driver.version="470.57.02" \
--set driver.manager.repository=nvcr.io/nvidia/cloud-native \
--set driver.manager.image=k8s-driver-manager \
--set toolkit.repository=nvcr.io/nvidia/k8s \
--set toolkit.image=container-toolkit \
--set toolkit.version=1.7.1-ubuntu18.04 \
--set devicePlugin.repository=nvcr.io/nvidia \
--set devicePlugin.image=k8s-device-plugin \
--set devicePlugin.version=v0.9.0-ubi8 \
--set gfd.repository=nvcr.io/nvidia \
--set gfd.image=gpu-feature-discovery \
--set gfd.version=v0.4.1 \
--set dcgmExporter.repository=nvcr.io/nvidia/k8s \
--set dcgmExporter.image=dcgm-exporter \
--set dcgmExporter.version=2.2.9-2.4.0-ubuntu20.04
```

## ref

## reproduce chart
```
helm repo add nvidia https://nvidia.github.io/gpu-operator
helm repo update
helm pull nvidia/gpu-operator --untar
```