# argo

1. create argo namespace
```
kubectl create namespace argo
```

2. install argo
```
helm install -n argo argo argo \
--set controller.image=argoproj/workflow-controller:v2.3.0 \
--set executor.image=argoproj/argoexec:v2.3.0 \
--set singleNamespace=false \
--set controller.containerRuntimeExecutor=docker \
--set workflow.rbac.create=true \
--set installCRD=true \
--set createAggregateRoles=true \
--set server.enabled=false
```

## ref

## reproduce chart
```
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
helm pull argo/argo --untar
```