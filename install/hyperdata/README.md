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
    --set customAddon.url=${ADDON_URL}
    ```

2. Uninstall hyperdata
```
helm uninstall -n hyperdata hyperdata hyperdata
```
