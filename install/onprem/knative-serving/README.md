# knative

knative serving은 공식적으로 helm chart가 존재하지 않습니다.

helm으로 관리하기 위해 설치 시 사용하는 yaml들을 helm으로 wrapping 합니다.

1. create knative-serving namespace
```
kubectl create namespace knative-serving
```

2. install knative-serving base
```
helm install -n knative-serving knative-serving-crd base
```

3. install knative-serving
```
helm install -n knative-serving knative-serving knative-serving \
--set queueProxy.image=gcr.io/knative-releases/knative.dev/serving/cmd/queue:v0.22.0 \
--set activator.image=gcr.io/knative-releases/knative.dev/serving/cmd/activator:v0.22.0 \
--set autoscaler.image=gcr.io/knative-releases/knative.dev/serving/cmd/autoscaler:v0.22.0 \
--set autoscaler.config.scaleToZeroGracePeriod="60s" \
--set controller.image=gcr.io/knative-releases/knative.dev/serving/cmd/controller:v0.22.0 \
--set webhook.image=gcr.io/knative-releases/knative.dev/serving/cmd/webhook:v0.22.0 \
--set istioWebhook.image=gcr.io/knative-releases/knative.dev/net-istio/cmd/webhook:v0.22.0 \
--set istioNetworking.image=gcr.io/knative-releases/knative.dev/net-istio/cmd/controller:v0.22.0
```

4. configure registriesSkippingTagResolving
<pre>
kubectl get cm -n knative-serving config-deployment -o yaml | \
sed -z "s/\ndata:\n/\ndata:\n  registriesSkippingTagResolving: \"<b>${PRIVATE_DOCKER_REGISTRY_ADDRESS}(ex. 192.168.179.44:5000)</b>\"\n/g" | \
kubectl apply -f -
</pre>

## reproduce chart
```
kubectl apply --filename https://github.com/knative/serving/releases/download/v0.22.0/serving-crds.yaml
kubectl apply --filename https://github.com/knative/serving/releases/download/v0.22.0/serving-core.yaml
kubectl apply --filename https://github.com/knative/net-istio/releases/download/v0.22.0/release.yaml
```