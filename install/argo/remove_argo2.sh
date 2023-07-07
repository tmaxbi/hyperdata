#!/bin/bash

ARGO_NAMESPACE=argo

kubectl delete --all workflows

kubectl get crd | grep argoproj | awk '{print $1}' | xargs kubectl delete crd 

helm uninstall -n argo argo