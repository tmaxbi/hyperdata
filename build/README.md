# Hyperdata 빌드 가이드

제공되는 기능은 다음과 같습니다.
1. 하이퍼데이터 이미지 빌드 서버(추후 추가 예정)
2. [하이퍼데이터 이미지 빌드 방법](./hyperdata)

## Build Server

- 인증기관을 거치지 않는 인증서를 사용하는 Docker Registry를 사용할 경우, insecure-registries에 해당 registry를 등록하여야 합니다.
    
  ```
  $ vi /etc/docker/daemon.json
  {
    "insecure-registries": ["${YOUR DOCKER REGISTRY ADDRESS}"]
  }
  ```

### Usage
http://:5000/buildHyperdataImage/{hdVersion}/{commitId}/{registryIP}
   - hdVersion은 release8.3의 경우 8
