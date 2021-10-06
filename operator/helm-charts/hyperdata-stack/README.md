# hyperdata stack

1. add helm repo
```
helm repo add hyperdata https://tmaxbi.github.io/hyperdata
helm repo update
helm pull hyperdata/hyperdata-stack --untar
```

2. install hyperdata stack
```
# install전 환경에 따라 적절히 values.yaml 수정
helm install -n hyperdata hyperdata-stack .
```