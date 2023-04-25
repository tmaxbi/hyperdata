# hyperdata be common 

### 실행 결과 확인 방법
** 실행 시 팟 생성 > 작업 완료 후 자동으로 삭제됨. ** \
헬름 차트가 에러없이 설치 완료 됐다면 성공 \
공유 폴더 안에 아래 목록이 모두 생겨야 함.
- /HyperData
- /HyperData/config, temp, logs (폴더 3개)
- /HyperData/config/hd_config.properties
- /HyperData/HD_SCHEMA_VERSION

설치 로그는 공유 폴더 안에 아래의 위치에 생성됨. \
**SQL 실행에 문제가 있어도 팟이 멈추지 않기 때문에** 반드시 잘 실행되었는지 확인해야 함. 
- /HyperData/install.log

### 사용 가능한 상황
1. 20.4 > 20.5 업데이트 : 공유 폴더의 HD_SCHEMA_VERSION 파일이 있을 경우 스키마를 20.5로 업데이트 함.
2. 특정 버전 업데이트 : 공유 폴더에 /HyperData/HD_SCHEMA_VERSION 파일이 있을 경우 **values.yaml의 schema_version으로** 스키마를 업데이트 함.
   <br>
   - 중간이 여러 버전을 뛰어넘을 경우 모두 업데이트 함.
   예 : 20.4, 20.5, 20.5.1, 20.5.2 버전이 있을 경우 (현재 버전 : 20.4, 패치 버전 : 20.5.2)
   20.4 다음 버전(20.5)부터, 패치 버전(20.5.2)까지 총 3개 버전의 업데이트 스크립트를 순서대로 실행함.
3. 특정 버전 신규 설치 : 1과 2에 해당하지 않을 경우 **values.yaml의 schema_version으로** 스키마를 신규 설치함.



### 설치 / 삭제 방법
1. install hyperdata-be-common

   ```
   helm install -n hyperdata hyperdata-be-common hyperdata-be-common \
   --set image=${HARBOR_URL}/${HARBOR_REPO}/${IMAGE_NAME}:${TAG}
   ```

2. Uninstall hyperdata-be-common
   ```
   helm uninstall hyperdata-be-common -n hyperdata
   ```


