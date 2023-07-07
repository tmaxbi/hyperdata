#!/bin/bash

ARGO_NAMESPACE=argo

kubectl create ns $ARGO_NAMESPACE --dry-run=client -o yaml | kubectl apply -f -

helm upgrade --install -n $ARGO_NAMESPACE argo-workflows argo-workflows \
--set server.enabled=false
