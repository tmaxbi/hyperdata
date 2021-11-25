# neo4j

neo4j 설치 및 헬름차트입니다. 

1. install neo4j (도커허브사용)
```
helm install -n hyperdata neo4j neo4j \
--set image=neo4j \
--set imageTag=4.0.1
```

2. install neo4j (Private Registry사용) - 양식
```
helm install -n {hyperdata설치용 namespace} neo4j neo4j \
--set image={Registry IP}:{Registry Port}/{Registry Image Name} \
--set imageTag={Registry Image Tag Name}
```

3. install neo4j (Private Registry사용) - 예시
```
helm install -n hyperdata-dev38 neo4j neo4j \
--set image=192.168.179.44:5000/hyperdata20.4_neo4j \
--set imageTag=20211124_v1
```
