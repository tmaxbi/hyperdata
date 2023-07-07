# Kserve install docs
#### 1. kfserving uninstall

```
# kfserving-system namespace에 kfserving package install 되어 있는지 확인
$ helm ls -n kfserving-system

# 혹은 crd group kfserving에서 inferenceservice등 crd 있는지 확인
$ kubectl get crd
```

- 위 두가지 명령어 중 하나로 이전 argo workflow 설치 되어 있는지 확인
- 설치 되어 있지 않으면 uninstall 과정을 거치지 않아도 됩니다.

```
$ bash remove_kfserving.sh
```

#### 2. kserve helm package install

```
bash install_kserve.sh
```

