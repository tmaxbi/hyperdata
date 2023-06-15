# hive

hive는 데이터소스를 등록하여 아파치 오존에 업로드해 두고 external table을 생성하여 조회 및 사용할 수 있도록 하기 위해 설치함

install hive

```
	helm install  hive hive --namespace hyperdata \
        --set image=biqa.tmax.com/hyperdata20.5_rel/hyperdata20.5_hiveozone:20230413_v1 \
```