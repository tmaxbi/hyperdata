#!/bin/bash

CERT_NAMESPACE=cert-manager

kubectl create namespace $CERT_NAMESPACE --dry-run=client -o yaml | kubectl apply -f -

helm upgrade --install -n $CERT_NAMESPACE cert-manager cert-manager \
--set installCRDs=true \
--set image.repository=quay.io/jetstack/cert-manager-controller \
--set image.tag=v1.5.2 \
--set webhook.image.repository=quay.io/jetstack/cert-manager-webhook \
--set webhook.image.tag=v1.5.2 \
--set cainjector.image.repository=quay.io/jetstack/cert-manager-cainjector \
--set cainjector.image.tag=v1.5.2 \
--set startupapicheck.image.repository=quay.io/jetstack/cert-manager-ctl \
--set startupapicheck.image.tag=v1.5.2