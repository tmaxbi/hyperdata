# metallb

metallb는 설치환경의 os에 따라 별도의 이미지가 존재합니다. 설치환경의 architecture를 확인 후 사용하시길 바랍니다.

[arm, arm64, amd64, s390x, ppc64le]

1. create metallb namespace
```
kubectl create namespace metallb-system
```

2. create metallb
```
helm install -n metallb-system metallb metallb \
--set controller.image.repository=quay.io/metallb/controller \
--set controller.image.tag=v0.10.2 \
--set speaker.image.repository=quay.io/metallb/speaker \
--set speaker.image.tag=v0.10.2 \
--set configInline.address-pools[0].name=default \
--set configInline.address-pools[0].protocol=layer2 \
--set configInline.address-pools[0].addresses[0]=192.168.179.37-192.168.179.39
```


## reproduce chart
```
helm repo add metallb https://metallb.github.io/metallb
helm pull metallb/metallb --untar
```