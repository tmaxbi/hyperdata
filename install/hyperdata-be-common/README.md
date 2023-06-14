# hyperdata be common 

### 실행 전 주의사항
해당 가이드는 tibero가 제대로 설치되어 있음을 가정하고 있음.
그 외에도 hyperdata-be-common이 db 스키마를 생성하기 위해서 /db/tibero6 폴더의 권한이 필요함

```
kubectl exec -it tibero-pod-db-hd /bin/bash -n [네임스페이스]
# tibero pod에 접속

chmod -R 777 /db/tibero6
# 권한 부여

```

### 실행 결과 확인 방법
** 실행 시 팟 생성 > 작업 완료 후 자동으로 삭제됨. ** \
헬름 차트가 에러없이 설치 완료 됐다면 성공 \
Tibero pod에 접근해서 공유 폴더 안에 아래 목록이 모두 있는지 확인해야 함
- /db/HyperData
- /db/HyperData/config, temp, logs (폴더 3개)
- /db/HyperData/config/hd_config.properties (BE 공통 설정 파일)
- /db/HyperData/HD_SCHEMA_VERSION (스키마 버전 확인 용 파일)
- /db/HyperData/VERSION (패치 정보 확인 용 파일. FE 출력 시 사용)

설치 로그는 공유 폴더 안에 아래의 위치에 생성됨. \
**SQL 실행에 문제가 있어도 팟이 멈추지 않기 때문에** 반드시 잘 실행되었는지 확인해야 함. 
- /db/HyperData/install.log

### 사용 가능한 상황
1. 20.4 > 20.5 업데이트 : 공유 폴더의 HD_SCHEMA_VERSION 파일이 있을 경우 스키마를 20.5로 업데이트 함.
2. 특정 버전 업데이트 : 공유 폴더에 /db/HyperData/HD_SCHEMA_VERSION 파일이 있을 경우 **values.yaml의 schema_version으로** 스키마를 업데이트 함.
   <br>
   - 중간이 여러 버전을 뛰어넘을 경우 모두 업데이트 함.
   예 : 20.4, 20.5, 20.5.0.1, 20.5.0.2.0 버전이 있을 경우 (현재 버전 : 20.4, 패치 버전 : 20.5.0.2.0)
   20.4 다음 버전(20.5)부터, 패치 버전(20.5.0.2.0)까지 총 3개 버전의 업데이트 스크립트를 순서대로 실행함.
3. 특정 버전 신규 설치 : 1과 2에 해당하지 않을 경우 **values.yaml의 schema_version으로** 스키마를 신규 설치함.



### 설치 / 삭제 방법
1. install hyperdata-be-common

   ```
   helm install -n hyperdata hyperdata-be-common hyperdata-be-common \
   --set image=${HARBOR_URL}/${HARBOR_REPO}/${IMAGE_NAME}:${TAG} \
   --set schema_version={schema_version}
   ```

2. Uninstall hyperdata-be-common
   ```
   helm uninstall hyperdata-be-common -n hyperdata
   ```


