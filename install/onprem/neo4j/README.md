# neo4j

neo4j 설치 및 헬름차트입니다. 

1. install neo4j
```
helm install -n hyperdata neo4j neo4j \
--set image=neo4j \
--set imageTag=4.0.1
```
