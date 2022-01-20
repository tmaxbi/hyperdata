# prometheus

1. install prometheus
    ```
    helm install -n hyperdata prometheus prometheus \
    --set alertmanager.enabled=false \
    --set pushgateway.enabled=false \
    --set nodeExporter.enabled=false \
    --set kube-state-metrics.rbac.useClusterRole=false \
    --set kube-state-metrics.namespaces="hyperdata" \
    --set server.namespaces="{hyperdata}" \
    --set server.image.repository=quay.io/prometheus/prometheus \
    --set server.image.tag=v2.31.1
    ```

## ref

## reproduce chart
```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm pull prometheus-community/prometheus --untar
```
