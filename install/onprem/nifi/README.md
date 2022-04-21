# Dependency

- Nifi 1.15.3 [docker hub link](https://hub.docker.com/r/apache/nifi/tags)
- Helm 3.0.0+
- Zookeeper 3.6.2-debian-10-r37 [docker hub link](https://hub.docker.com/r/bitnami/zookeeper/tags?page=1&name=3.6.2-debian-10-r37)

## Nifi 설명

중앙 서버에 설치되는 데이터 수집 툴입니다. \
HyperData, Ozone과 같은 Namespace에 배포되어야 합니다. \
서버에 Nifi가 정상적으로 설치되면 Minifi를 이용해서 원격지로부터 데이터를 수집할 수 있습니다. \
수집되는 데이터의 흐름은 다음과 같습니다. \
데이터(원격지) -> Nifi -> Ozone \
다수의 원격지가 존재하더라도 모든 데이터 수집 흐름은 Nifi(중앙)에서 관리됩니다. 

## 주요 변수 설정
**./helm-nifi/values.yaml에 있는 변수**
- **image.repository** (10번째 라인) 이미지가 저장된 Repository \
    ex)192.168.179.44:5000/hyperdata20.4_nifi
- **image.tag** (11번째 라인) 이미지의 태그
- **webProxyHost** (79번째 라인) LoadBalancer IP:8080 으로 수정해주세요
- **jvmMemory** (207번째 라인) 대용량 데이터 적재를 위해 메모리를 넉넉하게 잡아주세요 (기본옵션 2G -> 8G) 
- **persistence.enabled** (218번째 라인) Nifi에 persistence storage를 부여합니다. \
   해당 옵션이 true이면 nifi pods가 종료되어도 기존 flow, template 파일이 보존됩니다. (기본옵션 false)

## Nifi 설치방법 및 사용법

**1. HyperData, Ozone이 설치된 Namespace에서 Nifi를 설치합니다.** 
  - `install.sh`를 이용해서 설치 및 제거할 수  있습니다. 
  ```
  . install.sh install Namespace
  . install.sh uninstall Namespace
  ```  

**2. Nifi상단 메뉴에서 Template를 불러옵니다.** 
  - Template(MinifiToOzone)는 설치과정에서 자동으로 Nifi에 업로드됩니다. 
  - **만약 Template메뉴에 MinifiToOzone가 존재하지 않는다면 Nifi 초기화설정 과정이 길어져서 발생한 문제** 
  ```
  . install.sh upload Namespace
  ```      
  위 명령어를 통해서 Template를 Nifi로 업로드 시킬 수 있습니다.

**3. Ozone Volume, Bucket 설정** 
  - 2번에서 불러온 Template을 더블클릭하면 하위 프로세스로 들어갈 수 있습니다. 
  - Ozone Config UPDATE 프로세스 그룹을 오른쪽 클릭하여 Variables 설정해야 합니다. 
  - 데이터를 수집하는 원격지들을 구분할 수 있도록 전역변수 Volume, Bucket, Institution, OzoneConfigUpdateID를 입력합니다. 
  - 변수를 다 입력했다면, Ozone Config UPDATE 프로세스 그룹을 오른쪽 클릭하여 실행시킵니다. 

**4. Minifi Template 적용 및 Minifi 실행** 
  - minifi 폴더안에 README.md와 minifi 가이드문서를 참고해주세요

## 자세한 설치와 적용방법은 docs 폴더를 참고하시길 바랍니다. ##
