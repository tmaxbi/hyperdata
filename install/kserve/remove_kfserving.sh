#!/bin/bash

KFSERVING_NAMESPACE=kfserving-system

kubectl delete --all isvc

kubectl get crd | grep kfserving | awk '{print $1}' | xargs kubectl delete crd 

helm uninstall -n $KSERVE_NAMESPACE kfserving