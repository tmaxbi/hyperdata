# Hyperdata 인스톨러

본 문서에서는 하이퍼데이터를 설치하기 위해 필요한 installer.yaml을 생성하고 설치하는 가이드를 제공합니다.

## Prerequisites

## 폐쇄망 설치 가이드
**폐쇄망에서 설치하는 경우**, 필요한 이미지를 미리 준비하여야 합니다.
1. image_config.properties 설정(기본적으로 각 이미지 버전은 하이퍼데이터 버전에 맞는 TAG가 설정되어 있습니다.)
    
    ```bash
    $ vi image_config.properties
    # 이미지를 가져올 docker registry
    REMOTE_REGISTRY=**${YOUR_REMOTE_REGISTRY_IP}:${YOUR_REMOTE_REGISTRY_POR
    T}**
    # 이미지를 옮길 docker registry
    LOCAL_REGISTRY=**${YOUR_LOCAL_REGISTRY_IP}:${YOUR_LOCAL_REGISTRY_PORT}

    # 기본적으로 image tag들은 버전에 맞게 설정되어 있습니다.
    TB_TAG=${YOUR_TIBERO_TAG}
    ...
    ```
2. docker_pull_and_save.sh 실행
    - 외부 네트워크 통신이 가능한 환경에서 필요한 이미지를 다운받는 스크립트
    ````bash
    $ bash docker_pull_and_save.sh
    # 다운받아진 이미지들 확인
    $ ls images
    automl_downloader_v20210230.tar.gz automl_.tar ...
    ````

3. 이미지 tar 파일들을 폐쇄망 환경으로 이동(USB, ftp...)

4. docker_load_and_push.sh 실행(이미지 tar파일들은 images에 존재하여야 합니다.)
    ````bash
    $ bash docker_load_and_push.sh
    ````

### Error
1. certificate signed by unknown authority가 뜰 경우
   - self-signed certificate와 같이, 인증기관을 거치지 않는 인증서를 사용하는 Docker Registry를 사용할 경우, insecure-registries에 해당 registry를 등록하여야 합니다.
    ```bash
    $ vi /etc/docker/daemon.json
    {
    "insecure-registries": ["${YOUR DOCKER REGISTRY ADDRESS}"]
    }
    ```

2. registry에 id 및 password가 등록되어 있는 경우
    - id, password가 등록되어 있는 registry의 경우 docker login을 먼저 수행하여야 합니다.
    ```
    $ docker login --username ${YOUR_USER_NAME} --password ${YOUR_PASSWORD} ${YOUR DOCKER REGISTRY ADDRESS}
    ```


## Install Steps
1. hyperdata_config.properties 수정

2. image_config.properties 수정
    - 폐쇄망 가이드를 진행하였을 경우, 수정할 필요가 없습니다.
    - 폐쇄망 가이드를 진행하지 않았을 경우 LOCAL_REGISTRY를 사용할 Image Registry 주소로 수정

3. create_installer_yaml.sh 실행
   - 해당 과정에서, hyperdata_config.properties 및 image_config.properties 둘 모두 사용하므로 이전 과정에서 설정한 옵션과 다른 옵션으로 수정하여서는 안됩니다.
   - 해당 과정에서, base/installer.yaml 파일을 참고하여 새로운 installer.yaml이 현 폴더에 생성됩니다.

4. kubectl apply -f installer.yaml 실행

5. 설치가 정상적으로 진행되는지 확인