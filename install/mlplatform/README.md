# mlplatform

1. enable kfserving
```
kubectl label namespaces hyperdata serving.kubeflow.org/inferenceservice=enabled
```

2. enable registriesSkippingTagResolving
```
kubectl get cm -n knative-serving config-deployment -o yaml | \
sed -z "s/\ndata:\n/\ndata:\n  registriesSkippingTagResolving: \"${REGISTRY_IP}:${REGISTRY_PORT}\"\n/g" | \
kubectl apply -f -
```

3. install mlplatform
```
helm install -n hyperdata mlplatform mlplatform \
--set registry.address=192.168.179.44:5000 \
--set backend.private=false \
--set backend.image.name=hyperdata20.4_mlplatform_backend \
--set backend.image.tag=20210906_v1 \
--set frontend.image.name=hyperdata20.4_mlplatform_frontend \
--set frontend.image.tag=20210906_v1 \
--set automl.image.name=hyperdata20.4_mlplatform_automl \
--set automl.image.tag=20210827_v1 \
--set models.recommendation.image.name=hyperdata20.4_mlplatform_recommendation \
--set models.recommendation.image.tag=20210827_v1 \
--set hyperdata.address=http://hyperdata-svc-hd:8080 \
--set proauth.address=http://hyperdata-lb-hd:28080 \
--set kubernetes.istio.ingressgateway.ip=192.168.179.31 \
--set kubernetes.istio.ingressgateway.port=31380 \
--set mllab.image.tensorflow1.name=mlplatform_notebook_tf_v1.15.2 \
--set mllab.image.tensorflow1.tag=20211026_v1 \
--set mllab.image.tensorflow2.name=mlplatform_notebook_tf_v2.1.0 \
--set mllab.image.tensorflow2.tag=20211026_v1 \
--set mllab.image.pytorch.name=mlplatform_notebook_torch_v1.6.0 \
--set mllab.image.pytorch.tag=20211026_v1 \
--set mllab.image.statisticAnalysis.name=mlplatform_notebook_statistic_analysis_1.1.0 \
--set mllab.image.statisticAnalysis.tag=latest
```

※ 폐쇄망 설치시 backend.private=True로 설정

4. Uninstall mlplatform
```
helm uninstall -n hyperdata mlplatform mlplatform
```
