#!/bin/bash
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

$parent_path/install_automl_env_check.sh
[[ $? -ne 0 ]] && exit 1

# 1. add helm repo argo
# helm repo add argo https://argoproj.github.io/argo-helm
# helm repo update

# 2. install namespaced argo
# install argo
helm install -n $NAMESPACE hyperdata-ai-argo --set singleNamespace=true --set controller.containerRuntimeExecutor=$CONTAINER_RUNTIME_EXECUTOR --set workflow.namespace=$NAMESPACE --set images.controllerImage=$ARGO_CONTROLLER_IMG --set images.executorImage=$ARGO_EXEC_IMG --set controller.serviceAccount=argo --set workflow.serviceAccount.create=true --set workflow.serviceAccount.name=hyperdata-ai-argo-sa --set workflow.rbac.create=true --set installCRD=false --set createAggregateRoles=false --set server.enabled=false $parent_path/argo

# 3. add namespace label for serving
kubectl label namespace $NAMESPACE --overwrite serving.kubeflow.org/inferenceservice=enabled

# 4. install automl
helm install -n ${NAMESPACE} hyperdata-ai --set loadbalancerAddr=${NGINX_IP}:${NGINX_PORT} --set enableHttps=${ENABLE_HTTPS} --set imageSecret=${IMG_SECRET} --set image.scheduler=${SCHEDULER_IMG} --set image.automl=${AUTOML_IMG} --set image.doloader=${DOLOADER_IMG} --set image.fe=${FE_IMG} --set image.xgb=${XGB_IMG} --set image.rf=${RF_IMG} --set image.downloader=${DOWNLOADER_IMG} --set image.woori=${WOORI_IMG} --set image.resultuploader=${RESULTUPLOADER_IMG} --set image.domainserving=${DOMAIN_SERVING_IMG} --set image.wooriserving=${WOORI_SERVING_IMG} --set kubeflowAddr=${KFSERVING_ADDRESS} ${parent_path}/automl
