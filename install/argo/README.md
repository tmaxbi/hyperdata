# Argo workflow install docs

#### 1. argo (version 2) uninstall

```
# argo namespace에 argo package install 되어 있는지 확인
$ helm ls -n argo

# 혹은 crd group argoproj에서 version 2인지 확인
$ kubectl get crd 
```

- 위 두가지 명령어 중 하나로 이전 argo workflow 설치 되어 있는지 확인
- 설치 되어 있지 않으면 uninstall 과정을 거치지 않아도 됩니다. 

```
$ bash remove_argo2.sh
```

#### 2. argo helm install

1. namespace setting
```
kubectl create ns argo
```

2. argo install
```
# w/ argo-server
helm upgrade --install -n argo argo-workflows argo-workflows

# w/o argo-server
helm upgrade --install -n argo argo-workflows argo-workflows
--set server.enabled=false
```

## argoproj helm reference
- https://github.com/argoproj/argo-helm
