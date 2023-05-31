##

https://jerryljh.tistory.com/9


monitoring Namespace 등록
k create ns monitoring

## repo에 프로메테우스 등록
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

## Install
##helm install [RELEASE_NAME] prometheus-community/kube-prometheus-stack

helm install monitoring prometheus-community/kube-prometheus-stack \
--set grafana.service.type=NodePort \
--set grafana.service.nodePort=30100 -n monitoring
위와같이 nodePort를 30100으로 지정해서 띄워주고나면, http://192.168.179.31:30100/login 여기로 로그인하면 이제

## Delete
##helm uninstall [RELEASE_NAME]

helm uninstall monitoring prometheus-community/kube-prometheus-stack -n monitoring


##pod 검색시 각 노드에 떠야할 exporter가 Crush날때가있다.
보통 이건, 파드를 describe쳐보면 event에 9100번 프로세스가 먹혀있다? 그런 뜻으로 나오는데,
사실 이 9100 프로세스를 자기 자신이 뭔가 실행시켰다가 거기서 에러가 발생하고있는듯하다.
그냥 각 노드들(31,32,33) 들어가서 9100번 포트먹고있는 프로세스를 검색해서, 그걸 죽이고나면, 알아서 재실행되면

login default 아이디, 비번
user: admin
pass: prom-operator
