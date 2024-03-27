# hyperdata-fe

## 1. install hyperdata-fe

```shell
helm install -n hyperdata hyperdata-fe hyperdata-fe \
--set image=${HARBOR_URL}/${HARBOR_REPO}/${IMAGE_NAME}:${TAG}
```

## 2. Uninstall hyperdata-fe

```shell
helm uninstall -n hyperdata hyperdata-fe hyperdata-fe
```

## 3. install with CustomLogo

### 1. 이미지 파일을 PVC(tibero-pvc)에 저장

- 경로: pvc 내 temp 디렉토리 안에 저장\_
- 이미지 파일 정책: 최대 높이: 22px, 파일명: logo.svg

### 2. hyperdata-fe 설치

```shell
   helm install -n hyperdata hyperdata-fe hyperdata-fe \
   --set image=${HARBOR_URL}/${HARBOR_REPO}/${IMAGE_NAME}:${TAG} \
   --set customLogo.path=${path}
```

#### Example

_ex). /db/temp 에 로고가 저장 되어있을 경우_

```shell
   helm install -n hyperdata hyperdata-fe hyperdata-fe \
   --set image=biqa.tmax.com/hypedata20.5_rel/hyperdata20.5_front:20230427_591a1f45 \
   --set customLogo.path=/db/temp
```

### 3. 세부 사항 대처 방안

1.  디폴트 로고 사용 -> 커스텀 로고 사용
    1. 이미지 파일을 PVC(tibero-pvc)에 저장
    2. helm upgrade
       ```shell
          # path 는 이미지가 저장된 경로
          helm upgrade -n hyperdata hyperdata-fe hyperdat-fe --set customLogo.path={path}
       ```
    #### Example
    _ex). 커스텀 로고가 "/db/temp/logo.svg"에 있을 경우_
    1. helm upgrade
       ```shell
          helm upgrade -n hyperdata hyperdata-fe hyperdat-fe --set customLogo.path=/db/temp
       ```
2.  커스텀 로고 사용 중 일때, 로고의 경로 위치를 바꾸고 싶을 경우
    1. 이미지 파일 이동
    2. helm upgrade
       ```shell
          # path 는 이미지가 저장된 경로
          helm upgrade -n hyperdata hyperdata-fe hyperdat-fe --set customLogo.path={path}
       ```
    #### Example
    _ex). "/db/temp/logo.svg" 에서 "/db/temp/front/logo.svg" 로 이동할 경우_
    1. 이미지 파일 이동
       ```shell
          mkdir /db/temp/front
          mv /db/temp/logo.svg -> /db/temp/forn/logo.svg
       ```
    2. helm upgrade
       ```shell
          helm upgrade -n hyperdata hyperdata-fe hyperdat-fe --set customLogo.path=/db/temp/front
       ```
3.  커스텀 로고 사용 중 일때, 같은 경로의 다른 로고로 바꾸고 싶을 경우

    1. 새로운 로고 경로에 넣기
    2. 현재 로고 삭제 혹은 이름 변경
    3. 새로운 로고 이름 변경

    #### Example

    _ex). /db/temp/logo.svg를 /db/temp/logo_new.svg 로 교체_

    ```shell
       # 1.  삭제 후 교체
       rm /db/temp/logo.svg;
       mv /db/temp/logo_new.svg /db/temp/logo.svg;

       #2. 수정 후 교체
       mv /db/temp/logo.svg /db/temp/logo_old.svg;
       mv /db/temp/logo_new.svg /db/temp/logo.svg;
    ```

## 4. install with AutoLogin

### 1. hyperdata-fe 설치

hyperdata-fe-legacy-ingress에서 HyperData host와 port를 설정해두면 해당 경로로 301 redirect하여 autoLogin을 지원함

```shell
   helm install -n hyperdata hyperdata-fe hyperdata-fe \
   --set image=${HARBOR_URL}/${HARBOR_REPO}/${IMAGE_NAME}:${TAG} \
   --set legacy.redirect=${host}:${port}
```

#### Example

      _ex). hyperdata 주소가 "https://192.168.179.40:8080" 인 경우_

```shell
   helm install -n hyperdata hyperdata-fe hyperdata-fe \
   --set image=${HARBOR_URL}/${HARBOR_REPO}/${IMAGE_NAME}:${TAG} \
   --set legacy.redirect=https://192.168.179.40:8080
```

## 5. install with CustomManual

### 1. 메뉴얼을 PVC(tibero-pvc)에 저장

- 경로: pvc 내 저장
- 기본 경로: /HyperData
- 기본 파일명: HyperData_20.5_User-Guide.pdf

### 2. hyperdata-fe 설치

```shell
   helm install -n hyperdata hyperdata-fe hyperdata-fe \
   --set image=${HARBOR_URL}/${HARBOR_REPO}/${IMAGE_NAME}:${TAG} \
   --set manual.path=${path} \
   --set manual.filename=${filename}
```

#### Example

_ex). /HyperData/manual에 Manaul.ppt 메뉴얼이 저장 되어있을 경우_

```shell
   helm install -n hyperdata hyperdata-fe hyperdata-fe \
   --set image=biqa.tmax.com/hypedata20.5_rel/hyperdata20.5_front:20230427_591a1f45 \
   --set manual.path=/HyperData/manual \
   --set manual.filename=Manaul.ppt
```

### 3. 세부 사항 대처 방안

1.  디폴트 메뉴얼 사용 -> 커스텀 메뉴얼 사용
    1. 메뉴얼 파일을 PVC(tibero-pvc)에 저장
    2. helm upgrade
       ```shell
          helm upgrade -n hyperdata hyperdata-fe hyperdat-fe \
          --set manual.path=${path} \
          --set manual.filename=${filename}
       ```
    #### Example
    _ex). 커스텀 메뉴얼이 "/HyperData/Manual/Manul.ppt"인 경우_
    1. helm upgrade
       ```shell
          helm upgrade -n hyperdata hyperdata-fe hyperdat-fe \
          --set manual.path=/HyperData/manual \
          --set manual.filename=Manaul.ppt
       ```
2.  커스텀 메뉴얼 사용 중 일때, 메뉴얼의 경로 위치를 바꾸고 싶을 경우
    1. 메뉴얼 파일 이동
    2. helm upgrade
       ```shell
          # path 는 메뉴얼이 저장된 경로
          helm upgrade -n hyperdata hyperdata-fe hyperdat-fe \
          --set manual.path=${path} \
       ```
    #### Example
    _ex). "/HyperData/Manual/Manual.ppt" 에서 "/HyperData/New-Manual/Manul.ppt" 로 이동할 경우_
    1. 메뉴얼 파일 이동
       ```shell
          mkdir /db/HyperData/New-Manual
          mv /db/HyperData/Manual/Manual.ppt /db/HyperData/New-Manual/Manual.ppt
       ```
    2. helm upgrade
       ```shell
          helm upgrade -n hyperdata hyperdata-fe hyperdat-fe \
          --set manual.path=/HyperData/New-Manual
       ```
3.  커스텀 메뉴얼 사용 중 일때, 같은 경로의 다른 메뉴얼로 바꾸고 싶을 경우

    1. 새로운 메뉴얼 경로에 넣기
    2. helm upgrade

    #### Example

    _ex). /Hyperdata/Manual.ppt를 /Hyperdata/New-Manual.pdf 로 교체_

    ```shell
       helm upgrade -n hyperdata hyperdata-fe hyperdat-fe
       --set manual.filename=New-Manual.pdf
    ```