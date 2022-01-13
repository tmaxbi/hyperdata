# Hyperdata On HyperCloud 설치 가이드


### 1. 환경 구성
```
# helm 설치
$ curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
$ chmod 700 get_helm.sh
$ ./get_helm.sh

# helmfile 설치
$ wget -O helmfile_linux_amd64 https://github.com/roboll/helmfile/releases/download/v0.135.0/helmfile_linux_amd64
$ chmod +x helmfile_linux_amd64
$ mv helmfile_linux_amd64 /usr/local/bin/helmfile
```

### 2. 설치
```
$ cd helmfile/hypercloud

# 환경변수 파일을 열어 원하는 설치 형태에 맞게 수정
$ vi environments/hyperdata.yaml.gotmpl

$ helmfile sync
```
