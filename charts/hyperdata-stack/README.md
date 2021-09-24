# hyperdata stack

1. add helm repo
```
helm repo add tmaxbi/hyperdata https://tmaxbi.github.io/hyperdata
```

2. update dependency helm chart
```
helm dep update
```

3. install hyperdata stack
```
# install전 환경에 따라 적절히 values.yaml 수정
helm install -n hyperdata hyperdata-stack .
```