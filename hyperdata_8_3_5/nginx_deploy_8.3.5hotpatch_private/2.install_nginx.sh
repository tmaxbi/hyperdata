#!/bin/bash
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

echo "==== READ NGINX_CONFIG ===="
export $(grep -v '^#' nginx_config.properties | xargs -d '\n')
echo "==== READ NGINX_CONFIG END ===="

echo "==== CHECK NGINX ENV ===="
$parent_path/install_nginx_env_check.sh
[[ $? -ne 0 ]] && exit 1
echo "==== CHECK NGINX ENV END ===="


echo "==== INSTALL NGINX ===="
if [[ "${ENABLE_HTTPS}" == "true" ]]; then
  if [[ "${ENABLE_LOADBALANCER}" == "true" ]]; then
    helm install -n $NAMESPACE --replace $NAMESPACE-nginx ./ingress-nginx --set controller.admissionWebhooks.namespaceSelector.matchLabels.namespace=$NAMESPACE --set rbac.scope=true --set rbac.create=true --set controller.scope.enabled=true --set controller.scope.namespace=$NAMESPACE --set controller.image.name=$CONTROLLER_IMG --set controller.service.enableHttp=false --set controller.service.enableHttps=true --set controller.service.ports.https=$NGINX_PORT --set controller.admissionWebhooks.patch.image.name=$HOOKPATCH_IMG --set controller.service.annotations."metallb\.universe\.tf/allow-shared-ip"=top --set controller.service.loadBalancerIP=$NGINX_IP --set controller.service.sessionAffinity=None --set controller.service.externalTrafficPolicy=Cluster
  else
    helm install -n $NAMESPACE --replace $NAMESPACE-nginx ./ingress-nginx --set controller.admissionWebhooks.namespaceSelector.matchLabels.namespace=$NAMESPACE --set rbac.scope=true --set rbac.create=true --set controller.scope.enabled=true --set controller.scope.namespace=$NAMESPACE --set controller.image.name=$CONTROLLER_IMG --set controller.service.enableHttp=false --set controller.service.enableHttps=true --set controller.service.ports.https=$NGINX_PORT --set controller.admissionWebhooks.patch.image.name=$HOOKPATCH_IMG --set controller.service.type=NodePort --set controller.service.nodePorts.https=$NGINX_PORT
  fi
else
  if [[ "${ENABLE_LOADBALANCER}" == "true" ]]; then
    helm install -n $NAMESPACE $NAMESPACE-nginx ./ingress-nginx --set controller.admissionWebhooks.namespaceSelector.matchLabels.namespace=$NAMESPACE --set rbac.scope=true --set rbac.create=true --set controller.scope.enabled=true --set controller.scope.namespace=$NAMESPACE --set controller.image.name=$CONTROLLER_IMG --set controller.service.enableHttp=true --set controller.service.ports.http=$NGINX_PORT --set controller.service.enableHttps=false --set controller.admissionWebhooks.patch.image.name=$HOOKPATCH_IMG --set controller.service.annotations."metallb\.universe\.tf/allow-shared-ip"=top --set controller.service.loadBalancerIP=$NGINX_IP --set controller.service.sessionAffinity=None --set controller.service.externalTrafficPolicy=Cluster
  else
    helm install -n $NAMESPACE $NAMESPACE-nginx ./ingress-nginx --set controller.admissionWebhooks.namespaceSelector.matchLabels.namespace=$NAMESPACE --set rbac.scope=true --set rbac.create=true --set controller.scope.enabled=true --set controller.scope.namespace=$NAMESPACE --set controller.image.name=$CONTROLLER_IMG --set controller.service.enableHttp=true --set controller.service.ports.http=$NGINX_PORT --set controller.service.enableHttps=false --set controller.admissionWebhooks.patch.image.name=$HOOKPATCH_IMG --set controller.service.type=NodePort --set controller.service.nodePorts.http=$NGINX_PORT
  fi
fi
[[ $? -ne 0 ]] && exit 1
echo "==== INSTALL NGINX END ===="

echo "==== INSTALL HYPERDATA INGRESSES ===="
COUNTER=0
RETRY=0
while : ; do
  RETRY=1

  sed -e 's|@NAMESPACE|'"$NAMESPACE"'|g; s|@TARGET_SVC_NAME|'"$TARGET_SVC_NAME"'|g; s|@PROXY_TIMEOUT|'"$PROXY_TIMEOUT"'|g' ingress-hd.yaml | kubectl apply -f -
  [[ $? -ne 0 ]] && RETRY=0
  sed -e 's|@NAMESPACE|'"$NAMESPACE"'|g; s|@NGINX_IP|'"$NGINX_IP"'|g; s|@NGINX_PORT|'"$NGINX_PORT"'|g; s|@TARGET_SVC_NAME|'"$TARGET_SVC_NAME"'|g' ingress-hd-redirect.yaml | kubectl apply -f -
  [[ $? -ne 0 ]] && RETRY=0
  sed -e 's|@NAMESPACE|'"$NAMESPACE"'|g; s|@TARGET_SVC_NAME|'"$TARGET_SVC_NAME"'|g; s|@PROXY_TIMEOUT|'"$PROXY_TIMEOUT"'|g' ingress-mqtt.yaml | kubectl apply -f -
  [[ $? -ne 0 ]] && RETRY=0
  
  if [[ RETRY -eq 1 ]]; then
    break
  fi

  COUNTER=$[$COUNTER +1]
  if [[ COUNTER -gt 10 ]]; then
    echo "Creating ingress fails over 10 times. Please check nginx status"
    exit 1
  fi
  echo 'nginx not inialized yet. retry ('"${COUNTER}"'/10)'
  sleep 5
done
echo "==== INSTALL HYPERDATA INGRESSES END ===="
