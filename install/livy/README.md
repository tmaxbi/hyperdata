# Livy Server Helm Install Guide
- values.yaml 로 세부 설정
- 기본 설정은 K8s 기반으로, K8s 클러스터에서 Spark 자원을 할당받는다.

## Install

1. Livy Install

```
helm install -n hyperdata livy .
```

2. Livy Server 파드 내 vim 에디터 설치
```
kubectl exec -it livy-0 bash
apt install vim -y
```

3. Livy Server 파드 내 podTemplate 생성
Livy Server 파드 내 /root/.livy-sessions 디렉토리에 다음과 같이 태용이 같은 yaml 파일을 추가한다. 
파일명은 driver.yaml, executor.yaml 
```
apiVersion: v1
kind: Pod
spec:
  containers:
  - volumeMounts:
    - mountPath: /root/.livy-sessions
      name: livy-external-jars-share
  volumes:
  - name: livy-external-jars-share
    persistentVolumeClaim:
      claimName: livy-jars
```

## Uninstall

```
helm uninstall -n hyperdata livy
```
