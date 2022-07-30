# hyperdata

1. install hyperdata

    1.1 LoadBalancer 사용 유무

        1.1.1 LoadBalancer 사용시
        ```
        helm install -n hyperdata hyperdata hyperdata \
        --set image=192.168.179.44:5000/hyperdata/hyperdata20.4_hd_test:20210825_v1 \
        --set webserver.ip=${LOADBALANCER_IP} \
        --set webserver.port=8080
        ```
    
        1.1.2 NodePort 사용시
        ```
        helm install -n hyperdata hyperdata hyperdata \
        --set image=192.168.179.44:5000/hyperdata/hyperdata20.4_hd_test:20210825_v1 \
        --set loadbalancer.enabled=false
        --set webserver.ip=${MASTER_IP} \
        --set webserver.port=${Nginx controller NodePort} \
        --set loadbalancer.SUPERVDB_UCS_PORT=${30000-32767}
        ```

    1.2 SQL EDITOR 사용 유무

        1.2.1 SQL EDITOR 사용시
	```
	helm install -n hyperdata hyperdata hyperdata \ 
	--set image=192.168.179.44:5000/hyperdata/hyperdata20.4_hd_test:20210825_v1 \
	--set sqlEditor.enable=Y \
	--set web_studio_ip=${WEB STUDIO IP}
	```

	1.2.2 SQL EDITOR 미사용시
	```
	helm install -n hyperdata hyperdata hyperdata \ 
	--set image=192.168.179.44:5000/hyperdata/hyperdata20.4_hd_test:20210825_v1 \
	--set sqlEditor.enable=N
	```

    1.3 custom Logo 사용시
    ```
    helm install -n hyperdata hyperdata hyperdata \ 
    --set customAddon.enabled=true
    ```

    1.4 custom addon 사용 사용 시  
    ```
    helm install -n hyperdata hyperdata hyperdata \ 
    --set customAddon.enabled=true
    --set customAddon.url=${call_Dir}
    --set customAddon.path=${external_path}
    --set customAddon.externalHost=${external_host}
    --set customAddon.externalPort=${external_port}
    ```
   enable : custom addon 기능의 사용 여부  
   url : FE에서 위젯 호출시 호출하는 주소  
   path: 외부 서버 url  
   externalHost: 외부 서버 주소  
   externalPort: 외부 서버 포트     
   ============================  
   ex) 예를 들어 HyperData가 1.1.1.1:8080 이고  
   위젯 호출하는 외부 서버가 9.9.9.9:7000/widget일 경우

   enabled: true  
   url: https://1.1.1.1:8080/widget  
   path: /widget  
   externalHost: 9.9.9.9  
   externalPort: 7000  
   입니다.  
   ============================

2. Uninstall hyperdata
```
helm uninstall -n hyperdata hyperdata hyperdata
```
