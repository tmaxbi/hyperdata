

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
## Deploy parameters
| Name                                         | Description                                                                                                                                        | Value                         |
|----------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------|
| `replicaCount`                               | Number of System replicas to deploy                                                                                                                | `1`                           |
| `pvc.name`                               | name of pvc                                                                                                                | `tibero-pvc-db`                           |
| `pvc.mountPath`                               | mount path                                                                                                                | `/db`                           |
| `image.repository`                           | System image registry                                                                                                                              | `192.1.1.93:31234/hyperdata_v20.5_system/system_management`                   |
| `image.pullPolicy`                           | System image pull policy                                                                                                                           | `IfNotPresent` |
| `image.tag`                                  | System image tag                                                                                                                                   | `5f091111`                    |
| `imagePullSecrets`                           | Specify docker-registry secret names as an array                                                                                                   | `[]`                          |
| `nameOverride`                               | String to partially override common.names.fullname                                                                                                 | `""`                          |
| `fullnameOverride`                           | String to fully override common.names.fullname                                                                                                     | `""`                          |
| `serviceAccount.create`                      | Enable the creation of a ServiceAccount for System pods                                                                                            | `false`                       |
| `serviceAccount.annotations`                 | Additional custom annotations for the ServiceAccount                                                                                               | `{}`                          |
| `serviceAccount.name`                        | Name of the created ServiceAccount                                                                                                                 | `""`                          |
| `podAnnotations`                             | Annotations to add to pod                                                                                                                          | `{}`                          |
| `podSecurityContext`                         | System pods' Security Context                                                                                                                      | `{}`                          |
| `securityContext`                            | System containers' Security Context                                                                                                                | `{}`                          |
| `service.type`                               | Kubernetes service type                                                                                                                            | `NodePort`                    |
| `service.port`                               | System service HTTP port                                                                                                                           | `8100`                        |
| `ingress.enabled`                            | Enable ingress record generation for System(**not used for ingress**)                                                                              | `false`                       |
| `ingress.className`                          | IngressClass that will be be used to implement the Ingress(**Now not used**)                                                                       | `""`                          |
| `ingress.annotations`                        | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations.(**Now not used**) | `{}`                          |
| `ingress.hosts.host`                         | Default host for the ingress record (evaluated as template)(**Now not used**)                                                                      | `chart-example.local`         |
| `ingress.hosts.paths.path`                   | Default path for the ingress record(**Now not used**)                                                                                                                | `/`                           |
| `ingress.hosts.paths.pathType`               | Ingress path type(**Now not used**)                                                                                                                                  | `ImplementationSpecific`      |
| `ingress.tls`                                | Enable TLS configuration for the host defined at ingress.hostname parameter(**Now not used**)                                                                        | `[]`                          |
| `resources`                                  | limits or requests for the System containers                                                                                                       | `{}`                          |
| `autoscaling.enabled`                        | Enable autoscaling for System                                                                                                                      | `false`                       |
| `autoscaling.minReplicas`                    | Minimum number of System replicas                                                                                                                  | `1`                           |
| `autoscaling.maxReplicas`                    | Maximum number of System replicas                                                                                                                  | `100`                         |
| `autoscaling.targetCPUUtilizationPercentage` | Target CPU utilization percentage                                                                                                                  | `80`                          |
| `nodeSelector`                               | Node labels for pod assignment                                                                                                                     | `{}`                          |
| `tolerations`                                | Tolerations for pod assignment                                                                                                                     | `[]`                          |
| `affinity`                                   | Affinity for pod assignment                                                                                                                        | `{}`                          |


## Spring Config Parameter
| Name                                                 | Description                                                                                               | Value                                                                 |
|------------------------------------------------------|-----------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------|
| `applicationProperties`                              | The name of applicationProperties                                                                         | `application.yml`                                                     |
| `proxy.bodysize`                                     | The maximum allowed size of the client request body.                                                      | `1024m`                                                               |
| `proxy.timeout`                                      | The timeout in seconds for transmitting a request to the proxied server.                                  | `1800`                                                                |
| `server.port`                                        | Spring server HTTP port                                                                                   | `8100`                                                                |
| `server.servlet.contextPath`                         | Default API context                                                                                       | `/hyperdata`                                                          |
| `logging.config`                                     | The Log configuration path                                                                                | `classpath:logback-production.xml`                                    |
| `spring.servlet.multipart.maxFileSize`               | Maximum servlet multipart file size.                                                                      | `10MB`                                                                |
| `spring.servlet.multipart.maxRequestSize`            | Maximum servlet multipart request size.                                                                   | `10MB`                                                                |
| `spring.datasource.username`                         | User name of datasource                                                                                   | `hyperdata`                                                           |
| `spring.datasource.password`                         | Password of datasource                                                                                    | `tmax`                                                                |
| `spring.datasource.url`                              | The url of datasource                                                                                     | `jdbc:tibero:thin:@tiberolocaldns:8629:tibero`                        |
| `spring.datasource.driverClassName`                  | The class name of datasource                                                                              | `com.tmax.tibero.jdbc.TbDriver`                                       |
| `spring.datasource.hikari.jdbcUrl`                   | The jdbc url of hikari db connection pool                                                                 | `jdbc:tibero:thin:@tiberolocaldns:8629:tibero`                        |
| `spring.datasource.hikari.driverClassName`           | The class name of hikari db connection pool                                                               | `com.tmax.tibero.jdbc.TbDriver`                                       |
| `spring.rabbitmq.host`                               | host of rabbitmq (**Now not used**)                                                                       | `rabbitmq`                                                            |
| `spring.rabbitmq.port`                               | port of rabbitmq (**Now not used**)                                                                       | `5672`                                                                |
| `spring.rabbitmq.username`                           | username of rabbitmq (**Now not used**)                                                                   | `guest`                                                               |
| `spring.rabbitmq.password`                           | password of rabbitmq (**Now not used**)                                                                   | `guest`                                                               |
| `spring.mail.host`                                   | Url of smtp host server                                                                                   | `smtp.gmail.com`                                                      |
| `spring.mail.port`                                   | port of smtp host server                                                                                  | `587`                                                                 |
| `spring.mail.properties.mail.debug`                  | Enable Debug Log Level of Mail Library                                                                    | `true`                                                                |
| `spring.mail.properties.mail.smtp.connectionTimeout` | connection time out in smtp server                                                                        | `5000`                                                                |
| `spring.mail.properties.mail.smtp.auth`              | check smtp auth enable                                                                                    | `true`                                                                |
| `spring.mail.properties.mail.smtp.starttls.enable`   | enable smtp starttls                                                                                      | `true`                                                                |
| `spring.mail.properties.mail.smtp.ssl.enable`        | enable smtp ssl                                                                                           | `false`                                                               |
| `spring.mail.username`                               | username of smtp                                                                                          | `test@gmail.com`                                                      |
| `spring.mail.password`                               | password of smtp                                                                                          | `PASSWORD`                                                            |
| `spring.mvc.logRequestDetails`                       | enable mvc logRequestDetails                                                                              | `true`                                                                |
| `spring.mvc.logResolvedException`                    | enable mvc logResolvedException                                                                           | `true`                                                                |
| `spring.jpa.hibernate.naming.physicalStrategy`       | enable physicalStrategy                                                                                   | `org.hibernate.boot.model.naming.PhysicalNamingStrategyStandardImpl`  |
| `spring.jpa.hibernate.naming.implicitStrategy`       | enable implicitStrategy                                                                                   | `org.hibernate.boot.model.naming.ImplicitNamingStrategyLegacyJpaImpl` |
| `spring.jpa.showSql`                                 | Enable SQL showing in Log                                                                                 | `true`                                                                |
| `spring.jpa.properties.hibernate.formatSql`          | enable hibernate formatSql                                                                                | `true`                                                                |
| `spring.jpa.databasePlatform`                        | jpa database databasePlatform                                                                             | `org.hibernate.dialect.Oracle10gDialect`                              |
| `ws.default`                                         | Configuration path of web server                                                                          | `/home/systemmanagement/`                                             |
| `ws.profiles`                                        | Configuration profiles path of web server                                                                 | `/home/systemmanagement/profiles/`                                    |
| `tibero.ip`                                          | tibero ip                                                                                                 | `tiberolocaldns`                                                      |
| `tibero.port`                                        | tibero port                                                                                               | `8629`                                                                |
| `tibero.username`                                    | tibero username                                                                                           | `hyperdata`                                                           |
| `tibero.password`                                    | tibero password                                                                                           | `tmax`                                                                |
| `tibero.sid`                                         | tibero sid                                                                                                | `tibero`                                                              |
| `kubernetes.config.type`                             | Kubernetes config type                                                                                    | `kubernetes`                                                          |
| `kubernetes.meta.name.namespace.hyperdata`           | name of hyperdata namespace                                                                               | `hyperdata`                                                           |
| `kubernetes.meta.name.rbac.clusterRole`              | name of clusterRole                                                                                       | `spark-cr`                                                            |
| `kubernetes.meta.name.rbac.clusterRoleBinding`       | name of clusterRoleBinding                                                                                | `systemmanagement-project-clusterrolebinding-`                        |
| `kubernetes.meta.name.rbac.serviceAccount`           | name of service account                                                                                   | `default`                                                             |
| `kubernetes.meta.name.pvc.ozone`                     | name of ozone pvc                                                                                         | `data-datanode-0`                                                     |
| `kubernetes.meta.replicas`                           | the number of ozone replicas                                                                              | `3`                                                                   |
| `keycloak.enabled`                                   | enable keycloak                                                                                           | `true`                                                                |
| `keycloak.realm`                                     | the name of realm                                                                                         | `HyperDataRealm`                                                      |
| `keycloak.authServerUrl`                             | the name of realm                                                                                         | `http://keycloak:30252/`                                              |
| `keycloak.sslRequired`                               | keycloak ssl                                                                                              | `none`                                                                |
| `keycloak.resource`                                  | the name of keycloak client                                                                               | `HyperDataLogin`                                                      |
| `keycloak.credentials.secret`                        | keycloak credentials secret                                                                               | `SECRET`                                                              |
| `keycloak.useResourceRoleMappings`                   | keycloak useResourceRoleMappings                                                                          | `true`                                                                |
| `keycloak.bearerOnly`                                | keycloak bearerOnly                                                                                       | `true`                                                                |
| `ozone.config.host`                                  | ozone host                                                                                                | `om`                                                                  |
| `ozone.config.port`                                  | ozone port                                                                                                | `9862`                                                                |
| `version`                                            | module                                                                                                    | `module: commit number`                                               |
| `customAddon.enabled`                           | enable custom addon                                                                                   | `false`                                               |
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
