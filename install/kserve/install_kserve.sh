#!/bin/bash

KSERVE_NAMESPACE=kserve

kubectl apply --dry-run=client -f kserve-namespace.yaml -o yaml | kubectl apply -f -

helm upgrade --install -n $KSERVE_NAMESPACE kserve kserve