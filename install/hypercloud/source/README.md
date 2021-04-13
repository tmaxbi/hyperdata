# Hyperdata 인스톨러 이미지

본 문서에서는 Hyperdata Installer Image를 생성하기 위한 가이드를 제공합니다.

## Build Example
```bash
$ cd helm
$ helm dep update
$ cd ..
$ docker build -t 192.168.179.44:5000/hyperdata_installer:v8.3.4 .
$ docker push 192.168.179.44:5000/hyperdata_installer:v8.3.4
```

## 주의사항
helm안에 존재하는 global_values.yaml의 경우, 설치 스크립트에서 생성되는 installer.yaml의 configmap으로 덮어씌워지게 됩니다.

따라서, 직접 global_values.yaml을 수정하여 이미지를 빌드할 필요가 없습니다.