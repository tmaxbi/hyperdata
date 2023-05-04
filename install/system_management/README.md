

시스템 모듈을 설치하기 위해선 다음 과정이 필요합니다.
1. postgresql 설치
2. keycloack 설치
3. keycloak realm 설치 스크립트 실행
4. keycloak token 생성 스크립트 실행
5. system 모듈 설치

# postgresql 설치

```
cd hyperdata/install/onprem/system_management 

helm install postgresql postgresql \ 
-n [네임스페이스] \ 
--set global.postgresql.auth.postgresPassword=admin \ 
--set global.postgresql.auth.username=admin \ 
--set global.postgresql.auth.password=admin \ 
--set global.postgresql.auth.database=keycloak \ 
--set global.postgresql.service.ports.postgresql=5555 \ 
--set primary.livenessProbe.initialDelaySeconds=240 \
--set image.registry=biqa.tmax.com \
--set image.repository=hyperdata20.5_rel/hyperdata20.5_system/postgresql \
--set image.tag=15.2.0

ex) helm install postgresql postgresql \ 
-n hyperdata-dev01 \ 
--set global.postgresql.auth.postgresPassword=admin \ 
--set global.postgresql.auth.username=admin \ 
--set global.postgresql.auth.password=admin \ 
--set global.postgresql.auth.database=keycloak \ 
--set global.postgresql.service.ports.postgresql=5555 \ 
--set primary.livenessProbe.initialDelaySeconds=240 \
--set image.registry=biqa.tmax.com \
--set image.repository=hyperdata20.5_rel/hyperdata20.5_system/postgresql \
--set image.tag=15.2.0
```

# keycloack 설치

```
cd hyperdata/install/onprem/system_management

helm install keycloak keycloak \
-n [네임스페이스] \
--set auth.adminUser=admin \
--set auth.adminPassword=admin \
--set postgresql.enabled=false \
--set externalDatabase.host=[postgresql clusterIp] \
--set externalDatabase.port=5555 \
--set externalDatabase.user=admin \
--set externalDatabase.password=admin \
--set externalDatabase.database=keycloak \
--set ingress.enabled=true \
--set service.type=NodePort \
--set service.ports.http=8888 \
--set image.registry=biqa.tmax.com \
--set image.repository=hyperdata20.5_rel/hyperdata20.5_system/keycloak \
--set image.tag=20230321_v1

ex)
helm install keycloak keycloak \
-n hyperdata-dev01 \
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
--set image.repository=hyperdata20.5_rel/hyperdata20.5_system/keycloak \
--set image.tag=20230321_v1

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

helm install hyperdata-system . \
-n [네임스페이스] \
--set image.repository=[이미지 경로] \\네임스페이스
--set image.tag=[이미지 태그] \
--set keycloak.credentials.secret=[keycloak token] \
--set keycloak.authServerUrl=[keycloak url] \

ex) helm install hyperdata-system . \
-n hyperdata-dev01 \
--set image.repository=biqa.tmax.com/hyperdata20.5_rel/hyperdata20.5_system/system_management \
--set image.tag=20230415_bb649751_v2 \
--set keycloak.credentials.secret=gRsGkD1Y3xgY2x0bwJJJ3QWvk1Lp5cCB \
--set keycloak.authServerUrl=http://192.1.1.93:30552

```
# 기타 내용 및 에러
## Spring Config Parameter
| Name                                                 | Description                                                                                               | Value                                                                 |
|------------------------------------------------------|-----------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------|
| `spring.mail.host`                                   | Url of smtp host server                                                                                   | `smtp.gmail.com`                                                      |
| `spring.mail.port`                                   | port of smtp host server                                                                                  | `587`                                                                 |
| `spring.mail.properties.mail.debug`                  | Enable Debug Log Level of Mail Library                                                                    | `true`                                                                |
| `spring.mail.properties.mail.smtp.connectionTimeout` | connection time out in smtp server                                                                        | `5000`                                                                |
| `spring.mail.properties.mail.smtp.auth`              | check smtp auth enable                                                                                    | `true`                                                                |
| `spring.mail.properties.mail.smtp.starttls.enable`   | enable smtp starttls                                                                                      | `true`                                                                |
| `spring.mail.properties.mail.smtp.ssl.enable`        | enable smtp ssl                                                                                           | `false`                                                               |
| `spring.mail.username`                               | username of smtp                                                                                          | `test@gmail.com`                                                      |
| `spring.mail.password`                               | password of smtp                                                                                          | `PASSWORD`                                                            |
| `ws.profiles`                                        | Configuration profiles path of web server                                                                 | `/home/systemmanagement/profiles/`                                    |
| `version`                                            | module                                                                                                    | `module: commit number`                                               |
| `customAddon.enabled`                           | enable custom addon                                                                                   | `true`                                               |
| `customAddon.externalHost`                           | target server dns or ip                                                                                   | `128.59.105.24`                                               |
| `customAddon.externalDetail`                         | whole url https://{hyperdataIp}:{hyperdataPort}/hyperdata-widget/{path for target server} | `https://192.168.6.15:31519/hyperdata-widget/~fdc/sample.html`                                               |
| `customAddon.externalPort`                           | target server port                                                                                        | `80`                                               |

## SMTP 설정
Google SMTP 예제(폐쇄망의 경우 알맞게 수정 필요)

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
