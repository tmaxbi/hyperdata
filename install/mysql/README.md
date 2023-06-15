# mysql

시스템 hive의 metastore db로 사용하기 위해 설치함

install mysql

```
        helm install  mysql mysql --namespace hyperdata \
        --set image=biqa.tmax.com/hyperdata20.5_rel/mysql:20230413_v1 \
```