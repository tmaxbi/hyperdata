# System Management
---
빠른 테스트를 위해서 namespace, ingress등 실행 여부 이외의 다른 기능들은 없습니다.

차후에 업데이트 합니다. 

레포지토리, tag, ozone, tibero 등 설정들은 따로 하셔야 합니다.

1. setting application.yaml
```
## system_management/templates/configmap.yamlx
configmap 을 그대로 application yaml 으로 사용하고 있기 때문에 tag, ozone, tibero등 환경에 맞게 설정하셔야합니다.(아직 테스트중이기 때문)
```
2. install system-management

```
## path = ....../onprem 에서 실행

helm install system_management system_management \
--set serviceAccount.create=false
```

# 기타 내용및 에러
TEST를 위해 빠르게 진행하기 위해서 port forwarding을 이용해 사용했음.  (ingress 추가후 변경 해야함)
namespace 지정도 논의해야함.

namespace systemmanagement-project-4 가 이미있는 에러 -> namespace systemmanagement-project-4를 지워줘야함.

clusterrolebinding systemmanagement-project-clusterrolebinding-4 가 이미있는 에러 -> clusterrolebinding systemmanagement-project-clusterrolebinding-4를 지워줘야함.

ozone volumn이 이미 있는 에러 아래 스크립트를 오존에서 실행해 없애줘야함. 
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
