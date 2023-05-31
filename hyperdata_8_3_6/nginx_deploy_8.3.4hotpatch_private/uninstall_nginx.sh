#!/bin/bash
#!/bin/bash
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

echo "==== READ NGINX_CONFIG ===="
export $(grep -v '^#' nginx_config.properties | xargs -d '\n')
echo "==== READ NGINX_CONFIG END ===="

echo "==== DELETE NGINX ===="
sed -e 's|@NAMESPACE|'"$NAMESPACE"'|g; s|@TARGET_SVC_NAME|'"$TARGET_SVC_NAME"'|g; s|@PROXY_TIMEOUT|'"$PROXY_TIMEOUT"'|g; s|@TARGET_VIRTUAL_SVC_NAME|'"$TARGET_VIRTUAL_SVC_NAME"'|g;' ingress-hd.yaml | kubectl delete -f -
sed -e 's|@NAMESPACE|'"$NAMESPACE"'|g; s|@TARGET_SVC_NAME|'"$TARGET_SVC_NAME"'|g; s|@NGINX_IP|'"$NGINX_IP"'|g; s|@NGINX_PORT|'"$NGINX_PORT"'|g' ingress-hd-redirect.yaml | kubectl delete -f -
sed -e 's|@NAMESPACE|'"$NAMESPACE"'|g; s|@TARGET_SVC_NAME|'"$TARGET_SVC_NAME"'|g; s|@PROXY_TIMEOUT|'"$PROXY_TIMEOUT"'|g' ingress-mqtt.yaml | kubectl delete -f -
helm delete -n $NAMESPACE $NAMESPACE-nginx
echo "==== DELETE NGINX END ===="
