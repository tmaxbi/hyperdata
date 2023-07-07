#!/bin/bash
# $1 = TEAM_HARBOR_ADDRESS

KNATIVE_NAMESPACE=knative-serving

kubectl create namespace $KNATIVE_NAMESPACE --dry-run=client -o yaml | kubectl apply -f -

helm upgrade --install -n $KNATIVE_NAMESPACE knative-serving-crd base

helm upgrade --install -n $KNATIVE_NAMESPACE knative-serving knative-serving \
--set queueProxy.image=gcr.io/knative-releases/knative.dev/serving/cmd/queue:v0.22.0 \
--set activator.image=gcr.io/knative-releases/knative.dev/serving/cmd/activator:v0.22.0 \
--set autoscaler.image=gcr.io/knative-releases/knative.dev/serving/cmd/autoscaler:v0.22.0 \
--set autoscaler.config.scaleToZeroGracePeriod="60s" \
--set controller.image=gcr.io/knative-releases/knative.dev/serving/cmd/controller:v0.22.0 \
--set webhook.image=gcr.io/knative-releases/knative.dev/serving/cmd/webhook:v0.22.0 \
--set istioWebhook.image=gcr.io/knative-releases/knative.dev/net-istio/cmd/webhook:v0.22.0 \
--set istioNetworking.image=gcr.io/knative-releases/knative.dev/net-istio/cmd/controller:v0.22.0

kubectl get cm -n $KNATIVE_NAMESPACE config-deployment -o yaml | \
sed -z "s/\ndata:\n/\ndata:\n  registriesSkippingTagResolving: \"$1\"\n/g" | \
kubectl apply -f -
