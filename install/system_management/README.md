

시스템 모듈을 설치하기 위해선 다음 과정이 필요합니다.
1. postgresql 설치
2. keycloack 설치
3. keycloak realm 설치 스크립트 실행
4. keycloak token 생성 스크립트 실행
5. system 모듈 설치

# postgresql 설치

```
cd hyperdata/install/onprem/system_management 

helm install postgresql postgresql -n [네임스페이스] \ 
--set global.postgresql.auth.postgresPassword=admin \ 
--set global.postgresql.auth.username=admin \ 
--set global.postgresql.auth.password=admin \ 
--set global.postgresql.auth.database=keycloak \ 
--set global.postgresql.service.ports.postgresql=5555 \ 
--set primary.livenessProbe.initialDelaySeconds=240 \
--set image.registry=${HARBOR_URL} \
--set image.repository=${HARBOR_REPO}/${IMAGE_NAME} \
--set image.tag=${TAG}


ex) helm install postgresql postgresql -n hyperdata \ 
--set global.postgresql.auth.postgresPassword=admin \ 
--set global.postgresql.auth.username=admin \ 
--set global.postgresql.auth.password=admin \ 
--set global.postgresql.auth.database=keycloak \ 
--set global.postgresql.service.ports.postgresql=5555 \ 
--set primary.livenessProbe.initialDelaySeconds=240 \
--set image.registry=biqa.tmax.com \
--set image.repository=v20.5/hyperdata20.5_system/postgresql \
--set image.tag=20230504_v1
```

# keycloack 설치

```
cd hyperdata/install/onprem/system_management

helm install keycloak keycloak -n [네임스페이스] \
--set auth.adminUser=admin \
--set auth.adminPassword=admin \
--set postgresql.enabled=false \
--set externalDatabase.host=[postgresql svc Ip] \
--set externalDatabase.port=5555 \
--set externalDatabase.user=admin \
--set externalDatabase.password=admin \
--set externalDatabase.database=keycloak \
--set ingress.enabled=true \
--set service.type=NodePort \
--set service.ports.http=8888 \
--set image.registry=${HARBOR_URL} \
--set image.repository=${HARBOR_REPO}/${IMAGE_NAME} \
--set image.tag=${TAG}

ex)
helm install keycloak keycloak -n hyperdata \
--set auth.adminUser=admin \
--set auth.adminPassword=admin \
--set postgresql.enabled=false \
--set externalDatabase.host=10.233.29.187 \
--set externalDatabase.port=5555 \
--set externalDatabase.user=admin \
--set externalDatabase.password=admin \
--set externalDatabase.database=keycloak \
--set ingress.enabled=true \
--set service.type=NodePort \
--set service.ports.http=8888 \
--set image.registry=biqa.tmax.com \
--set image.repository=v20.5/hyperdata20.5_system/keycloak \
--set image.tag=20230504_v1

```

externalDatabase.host 값은 postgresql ip:port 값으로 설정

-   `kubectl get svc -n [네임스페이스] | grep 'postgresql’`
-   위 명령어 입력 후 결과로 나오는 IP 값으로 설정

keycloak-0 pod 1/1 상태가 될 때까지 대기


# keycloak realm 설치 스크립트 실행


```
cd install/onprem/system_management/keycloak/keycloak-script 
bash configure-keycloak.sh [keycloak url]
```

keycloak url

-   http://[master node ip]:[node port]
-   kubectl get service/keycloak -n [네임스페이스]
    -   위 명령어 실행 후 나오는 포트 값을 node port로, 마스터 노드의 ip를 master node ip로 설정

파일 실행 후 웹 상에서 keycloak url에 접근해서 hyperdata realm이 정상적으로 설치되었는지 확인

-   username, pwd : admin/admin 으로 접속 후 좌측 상단의 메뉴 클릭

![keycloak-admin](./resources/keycloak-admin)

# keycloak token 생성 스크립트 실행

```
cd install/onprem/system_management/keycloak/keycloak-script 
bash client-secret.sh [keycloak url]
```

위 명령어 실행 후 결과로 나오는 토큰 값을 시스템 모듈 설치 시 keycloak.credentials.secret 값으로 설정
![keycloak-token](./resources/keycloak-token)

# 시스템 모듈 설치

```bash
cd install/onprem/system_management

helm install hyperdata-system . -n [네임스페이스] \
--set image.repository=${HARBOR_URL}/${HARBOR_REPO}/${IMAGE_NAME} \
--set image.tag=${TAG} \
--set keycloak.credentials.secret=[keycloak token] \
--set keycloak.authServerUrl=[keycloak url] \
--set ozone.config.host=om \
--set ozone.config.port=9862 \
--set kubernetes.meta.name.namespace.hyperdata=[네임스페이스] \
--set kubernetes.meta.name.pvc.ozone=data-datanode-0

ex) helm install hyperdata-system . -n hyperdata \
--set image.repository=biqa.tmax.com/v20.5/hyperdata20.5_system/system_management \
--set image.tag=20230504_v1 \
--set keycloak.credentials.secret=gRsGkD1Y3xgY2x0bwJJJ3QWvk1Lp5cCB \
--set keycloak.authServerUrl=http://192.1.1.93:30552
--set ozone.config.host=om \
--set ozone.config.port=9862 \
--set kubernetes.meta.name.namespace.hyperdata=hyperdata \
--set kubernetes.meta.name.pvc.ozone=data-datanode-0 \

```

## 기타 내용및 에러

# SMTP 설정
Google SMTP 예제(고객사는 폐쇄망으로 쓸 수 없어 보임.)
인증을 위한 PW 생성: https://kitty-geno.tistory.com/43
시스템 helm chart value.yaml 설정
```
mail:
  host: smtp.gmail.com
  port: 587
  properties:
    mail:
      debug: true
      smtp:
        connectionTimeout: 5000
        auth: true
        starttls:
          enable: true
        ssl:
          enable: false
  username: {메일계정 ex: oper13357799@gmail.com}
  password: {링크 따라 생성한 PW ex: abcdefghijklnmop }
```

# 에러
namespace systemmanagement-project-4 가 이미있는 에러 -> namespace systemmanagement-project-4를 지워줘야함.

clusterrolebinding systemmanagement-project-clusterrolebinding-4 가 이미있는 에러 -> clusterrolebinding systemmanagement-project-clusterrolebinding-4를 지워줘야함.
```
kubectl delete clusterrolebinding {clusterRoleBindingName}
```
ozone volumn이 이미 있는 에러 -> 아래 스크립트를 오존에서 실행해 없애줘야함.
```
ozone sh bucket delete /systemmanagement-project-volume-4/datasource
ozone sh volume delete /systemmanagement-project-volume-4
ozone sh bucket delete /management-home/datasource
ozone sh volume delete /management-home
```
service acocunt가 spark-cr clusterrolebinding 권한이 없는 에러가 있을때.
```
kubectl create clusterrolebinding spark-cr --clusterrole=cluster-admin --serviceaccount={namespace}:{serviceAccountName}
```
