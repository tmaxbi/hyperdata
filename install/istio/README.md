# Istio

1. create istio namespace
```
kubectl create namespace istio-system
```

2. install base
```
helm install -n istio-system istio-base base
```

3. install istio-control
```
helm install -n istio-system istio-discovery istio-control/istio-discovery \
--set pilot.image=istio/pilot:1.9.7 \
--set global.proxy.image=istio/proxyv2:1.9.7 \
--set global.jwtPolicy=first-party-jwt
```

4. install ingress gateway
```
helm install -n istio-system istio-ingress istio-ingress \
--set global.proxy.image=istio/proxyv2:1.9.7 \
--set global.jwtPolicy=first-party-jwt
```

## ref
- https://github.com/istio/istio/tree/1.9.7/manifests/charts

## reproduce chart
- copy from https://github.com/istio/istio/tree/1.9.7/manifests/charts