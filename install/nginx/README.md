# nginx

1. create namespace for hyperdata if not exist
```
kubectl create namespace hyperdata
```

2. create nginx

    2.1. metallb loadbalancer로 설치할 경우
    ```
    helm install -n hyperdata ingress-nginx ingress-nginx \
    --set fullnameOverride=hyperdata \
    --set controller.ingressClassResource.name=hyperdata-nginx \
    --set controller.image.registry=k8s.gcr.io \
    --set controller.image.image=ingress-nginx/controller \
    --set controller.image.tag=v1.0.0 \
    --set controller.image.digest="" \
    --set controller.config.use-http2="false" \
    --set controller.scope.enabled=true \
    --set controller.scope.namespace=hyperdata \
    --set rbac.create=true \
    --set controller.service.type=LoadBalancer \
    --set controller.service.annotations."metallb\.universe\.tf/allow-shared-ip"=top \
    --set controller.service.sessionAffinity=None \
    --set controller.service.externalTrafficPolicy=Cluster \
    --set controller.service.enableHttp=false \
    --set controller.service.enableHttps=true \
    --set controller.service.ports.https=8080 \
    --set controller.service.loadBalancerIP=${NGINX_IP}
    ```

    2.2. nodePort로 설치할 경우
    ```
    helm install -n hyperdata ingress-nginx ingress-nginx \
    --set fullnameOverride=hyperdata \
    --set controller.ingressClassResource.name=hyperdata-nginx \
    --set controller.image.registry=k8s.gcr.io \
    --set controller.image.image=ingress-nginx/controller \
    --set controller.image.tag=v1.0.0 \
    --set controller.image.digest="" \
    --set controller.config.use-http2="false" \
    --set controller.scope.enabled=true \
    --set controller.scope.namespace=hyperdata \
    --set rbac.create=true \
    --set controller.service.type=NodePort \
    --set controller.service.enableHttp=false \
    --set controller.service.enableHttps=true \
    --set controller.service.ports.https=8080
    ```

3. Uninstall Nginx
```
helm uninstall -n hyperdata ingress-nginx ingress-nginx
```

**nginx는 clusterrole 및 ingressClass를 사용하고 있습니다. 하나의 쿠버클러스터에 여러 개의 nginx를 사용하려할 경우, fullnameOverride 및 controller.ingressClassResource.name를 서로 다르게 수정해주어야 합니다.**
    

## ref

## reproduce chart
```
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm pull ingress-nginx/ingress-nginx --untar
```
