# System Management
---

1. keycloak setting
```console
## keycloak realm 세팅 
## host, port 등 설정 필요
## in keycloak-script folder
## create realm and settings 
bash configure-keycloak.sh
```

```console
## keycloak.credentials.secret 값 얻는 방법.
## host, port등 설정 필요
bash client-secret.sh
```

2. install system-management
```console
## path = ....../onprem 에서 실행
## EXAMPLE
## repo, tag, ozone, tibero, mail, keycloak 등 설정 필요
helm install system_management system_management \
--set serviceAccount.create=false
--set keycloak.credentials.secret=KdfYES8btQcYpJNsFQ5Q02rFP3vqQW89 
```

## Deploy parameters
| Name                                         | Description                                                                                                                                        | Value                         |
|----------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------|
| `replicaCount`                               | Number of System replicas to deploy                                                                                                                | `1`                           |
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
| Name                                                 | Description                                                              | Value                                      |
|------------------------------------------------------|--------------------------------------------------------------------------|--------------------------------------------|
| `applicationProperties`                              | The name of applicationProperties                                        | `application.yml`                                    |
| `proxy.bodysize`                                     | The maximum allowed size of the client request body.                     | `1024m`                                |
| `proxy.timeout`                                      | The timeout in seconds for transmitting a request to the proxied server. | `1800`              |
| `server.port`                                        | Spring server HTTP port                                                  | `8100`                                         |
| `server.servlet.contextPath`                         | Default API context                                                      | `/hyperdata`                               |
| `logging.config`                                     | The Log configuration path                                               | `classpath:logback-production.xml`                                         |
| `spring.servlet.multipart.maxFileSize`               | Maximum servlet multipart file size.                                     | `10MB`                                         |
| `spring.servlet.multipart.maxRequestSize`            | Maximum servlet multipart request size.                                  | `10MB`                                         |
| `spring.datasource.username`                         | User name of datasource                                                  | `hyperdata`                                         |
| `spring.datasource.password`                         | Password of datasource                                                   | `tmax`                                         |
| `spring.datasource.url`                              | The url of datasource                                                    | `jdbc:tibero:thin:@tiberolocaldns:8629:tibero`                                         |
| `spring.datasource.driverClassName`                  | The class name of datasource                                             | `com.tmax.tibero.jdbc.TbDriver`                                         |
| `spring.datasource.hikari.jdbcUrl`                   | The jdbc url of hikari db connection pool                                | `jdbc:tibero:thin:@tiberolocaldns:8629:tibero`                                     |
| `spring.datasource.hikari.driverClassName`           | The class name of hikari db connection pool                              | `com.tmax.tibero.jdbc.TbDriver`                                     |
| `spring.rabbitmq.host`                               | host of rabbitmq (**Now not used**)                                      | `rabbitmq`                                     |
| `spring.rabbitmq.port`                               | port of rabbitmq (**Now not used**)                                      | `5672`                                     |
| `spring.rabbitmq.username`                           | username of rabbitmq (**Now not used**)                                  | `guest`                                     |
| `spring.rabbitmq.password`                           | password of rabbitmq (**Now not used**)                                  | `guest`                                         |
| `spring.mail.host`                                   | Url of smtp host server                                                  | `smtp.gmail.com`                                         |
| `spring.mail.port`                                   | port of smtp host server                                                 | `587`                                         |
| `spring.mail.properties.mail.debug`                  | Enable Debug Log Level of Mail Library                                   | `true`                                         |
| `spring.mail.properties.mail.smtp.connectionTimeout` | connection time out in smtp server                                       | `5000`                                         |
| `spring.mail.properties.mail.smtp.auth`              | check smtp auth enable                                                   | `true`                                         |
| `spring.mail.properties.mail.smtp.starttls.enable`   | enable smtp starttls                                                     | `true`                                     |
| `spring.mail.properties.mail.smtp.ssl.enable`        | enable smtp ssl                                                          | `false`                                    |
| `spring.mail.username`                               | username of smtp                                                         | `test@gmail.com`                           |
| `spring.mail.password`                               | password of smtp                                                         | `PASSWORD`                                 |
| `spring.mvc.logRequestDetails`                       | enable mvc logRequestDetails                                             | `true`                                     |
| `spring.mvc.logResolvedException`                    | enable mvc logResolvedException                                          | `true`                                     |
| `spring.jpa.hibernate.naming.physicalStrategy`       | enable physicalStrategy                                                  | `org.hibernate.boot.model.naming.PhysicalNamingStrategyStandardImpl` |
| `spring.jpa.hibernate.naming.implicitStrategy`       | enable implicitStrategy                                                  | `org.hibernate.boot.model.naming.ImplicitNamingStrategyLegacyJpaImpl` |
| `spring.jpa.showSql`                                 | Enable SQL showing in Log                                                | `true`                                     |
| `spring.jpa.properties.hibernate.formatSql`          | enable hibernate formatSql                                               | `true`                                     |
| `spring.jpa.databasePlatform`                        | jpa database databasePlatform                                            | `org.hibernate.dialect.Oracle10gDialect`   |
| `ws.default`                                         | Configuration path of web server                                         | `/home/systemmanagement/`                  |
| `ws.profiles`                                        | Configuration profiles path of web server                                | `/home/systemmanagement/profiles/`         |
| `tibero.ip`                                          | tibero ip                                                                | `tiberolocaldns`                           |
| `tibero.port`                                        | tibero port                                                              | `8629`                                     |
| `tibero.username`                                    | tibero username                                                          | `hyperdata`                                |
| `tibero.password`                                    | tibero password                                                          | `tmax`                                     |
| `tibero.sid`                                         | tibero sid                                                               | `tibero`                                   |
| `kubernetes.config.type`                             | Kubernetes config type                                                   | `kubernetes`                               |
| `kubernetes.meta.name.namespace.hyperdata`           | name of hyperdata namespace                                              | `hyperdata`                                |
| `kubernetes.meta.name.rbac.clusterRole`              | name of clusterRole                                                      | `spark-cr`                                 |
| `kubernetes.meta.name.rbac.clusterRoleBinding`       | name of clusterRoleBinding                                               | `systemmanagement-project-clusterrolebinding-` |
| `kubernetes.meta.name.rbac.serviceAccount`           | name of service account                                                  | `default`                                  |
| `kubernetes.meta.name.pvc.ozone`                     | name of ozone pvc                                                        | `data-datanode-0`                          |
| `kubernetes.meta.replicas`                           | the number of ozone replicas                                             | `3`                                        |
| `keycloak.enabled`                                   | enable keycloak                                                          | `true`                                     |
| `keycloak.realm`                                     | the name of realm                                                        | `HyperDataRealm`                           |
| `keycloak.authServerUrl`                             | the name of realm                                                        | `http://keycloak:30252/`                   |
| `keycloak.sslRequired`                               | keycloak ssl                                                             | `none`                                     |
| `keycloak.resource`                                  | the name of keycloak client                                              | `HyperDataLogin`                           |
| `keycloak.credentials.secret`                        | keycloak credentials secret                                              | `SECRET`                                   |
| `keycloak.useResourceRoleMappings`                   | keycloak useResourceRoleMappings                                         | `true`                                     |
| `keycloak.bearerOnly`                                | keycloak bearerOnly                                                      | `true`                                     |
| `ozone.config.host`                                  | ozone host                                                               | `om`                                       |
| `ozone.config.port`                                  | ozone port                                                               | `9862`                                     |


# 기타 내용및 에러
## SMTP 설정
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
## 에러
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
