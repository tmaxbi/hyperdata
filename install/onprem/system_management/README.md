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
## 레포지토리, tag, ozone, tibero 등 설정 필요
helm install system_management system_management \
--set serviceAccount.create=false
--set keycloak.credentials.secret=KdfYES8btQcYpJNsFQ5Q02rFP3vqQW89 
```

# 기타 내용및 에러
namespace systemmanagement-project-4 가 이미있는 에러 -> namespace systemmanagement-project-4를 지워줘야함.

clusterrolebinding systemmanagement-project-clusterrolebinding-4 가 이미있는 에러 -> clusterrolebinding systemmanagement-project-clusterrolebinding-4를 지워줘야함.
```
kubectl delete clusterrolebinding systemmanagement-project-clusterrolebinding-4
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
kubectl create clusterrolebinding spark-cr --clusterrole=cluster-admin --serviceaccount=default:default
```