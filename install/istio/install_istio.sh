#!/bin/bash

ISTIO_NAMESPACE=istio-system

kubectl create ns $ISTIO_NAMESPACE --dry-run=client -o yaml | kubectl apply -f -

helm upgrade --install -n $ISTIO_NAMESPACE istio-base base

helm upgrade --install -n $ISTIO_NAMESPACE istio-discovery istio-control/istio-discovery \
--set pilot.image=istio/pilot:1.9.7 \
--set pilot.resources.requests.cpu=200m \
--set pilot.resources.requests.memory=256Mi \
--set pilot.resources.limits.cpu=1 \
--set pilot.resources.limits.memory=2048Mi \
--set global.proxy.image=istio/proxyv2:1.9.7 \
--set global.jwtPolicy=first-party-jwt

helm upgrade --install -n $ISTIO_NAMESPACE istio-ingress istio-ingress \
--set global.proxy.image=istio/proxyv2:1.9.7 \
--set global.jwtPolicy=first-party-jwt
