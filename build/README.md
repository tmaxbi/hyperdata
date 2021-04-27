# Hyperdata 빌드 가이드

## Building
   - 인증기관을 거치지 않는 인증서를 사용하는 Docker Registry를 사용할 경우, insecure-registries에 해당 registry를 등록하여야 합니다.
    ```bash
    $ vi /etc/docker/daemon.json
    {
      "insecure-registries": ["${YOUR DOCKER REGISTRY ADDRESS}"]
    }
    ```

## Usage
http://:5000/buildHyperdataImage/{hdVersion}/{commitId}/{registryIP}
   - hdVersion은 release8.3의 경우 8
