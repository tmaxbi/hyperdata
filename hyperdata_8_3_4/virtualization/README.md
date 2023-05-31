## helm차트 기반 (2021.12.13)
[설치]
helm install virtualization-spring ./virtualization-helm/ \
--values ./virtualization-helm/values.yaml \
--set image=192.168.179.44:5000/hyperdata8.3_virtualization:20211210_v1 \
--set db.address=lb-db-dev40 \
--set db.port=8629  \
--set hyperdata.address=svc-hd-dev40 \
--set hyperdata.port=8080 \
--set loadBalancer.ip=192.168.179.40 \
--set loadBalancer.extport=8500 \
--set pvc.name=pvc-db-dev40 \
--set pvc.mountpath=/db \
--set logging.path=virtualization/logs \
--namespace hyperdata-dev40 

[삭제]
helm uninstall virtualization-spring ./virtualization-helm -n hyperdata-dev40


위의 형식으로 사용하면 됩니다.



namespaces : 네임스페이스
image  : 이미지 명 
db.address : Tibero 서비스 네임 
db.port  : Tibero 서비스 port
hyperdata.address  : hyperdata 서비스 네임
hyperdata.port  : hyperdata 서비스 port
loadBalancer.enabled : 로드밸런서 사용 여부 (NodePort사용시 false &&  nginx_config.properties의 , ENABLE_LOADBALANCER=false 처리 필요)
loadBalancer.ip  : loadBalnacer ip
loadBalancer.extport :  로드밸런서가 붙여할 포트 (8500)
pvc.name  : pvc 이름
pvc.mountpath  : pvc가 붙어야할 db 경로
logging.path  : 로깅 경로 



API사용법
1. Auth Token 발급
http://192.168.179.40:28080/proauth/oauth/authenticate
POST 방식으로 
Body의 form-data에 user_id : admin , password : admin 으로 POSTMAN을 사용하여 API전송

Response Body의 dto.token 기록 (eyJ0...)

2. https://192.168.179.40:8080/hyperdata8/dataobjects/{Data Object Id}/download/sql/?fileName={File Name}&contentType={File Type}&sql={SQL} 의 GET 방식으로 전송
header에 userId , Authorization 을 추가 (userId:admin, Authorization:1번에서 받은 dto.token)

ex ) https://192.168.179.40:8080/hyperdata8/dataobjects/6/download/sql/?fileName=testExcel&contentType=csv&sql=select *  from DATA_OBJECT_ID where empno>7500


자세한 사용 예시는 apitest.sh 참조 (서버, data object Id를 받아서 해당 DO의 csv, json, xml, xlsx를 temp.XXX 의 형식으로 현재위치에 저장해주는 script)



