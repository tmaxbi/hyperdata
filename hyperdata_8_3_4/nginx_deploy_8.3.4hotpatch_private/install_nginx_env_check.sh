if [ -z "$NAMESPACE" ]; then
  echo "Please set env \$NAMESPACE(ex. hyperdata)"
  exit 1
fi

if [ -z "$ENABLE_HTTPS" ]; then
  echo "Please set env \$ENABLE_HTTPS"
  exit 1
fi

if [ -z "$ENABLE_LOADBALANCER" ]; then
  echo "Please set env \$ENABLE_LOADBALANCER"
  exit 1
fi

if [ -z "$ENABLE_LOADBALANCER"="true" ]; then
  if [ -z "$NGINX_IP" ]; then
    echo "Please set env \$NGINX_IP"
    exit 1
  fi

  if [ -z "$NGINX_PORT" ]; then
    echo "Please set env \$NGINX_PORT"
    exit 1
  fi
else
  if [ -z "$NGINX_PORT" ]; then
    echo "Please set env \$NGINX_PORT"
    exit 1
  fi
fi

if [ -z "$CONTROLLER_IMG" ]; then
  echo "Please set env \$CONTROLLER_IMG"
  exit 1
fi

if [ -z "$HOOKPATCH_IMG" ]; then
  echo "Please set env \$HOOKPATCH_IMG"
  exit 1
fi

if [ -z "$TARGET_SVC_NAME" ]; then
  echo "Please set env \$TARGET_SVC_NAME"
  exit 1
fi

if [ -z "TARGET_VIRTUAL_SVC_NAME" ]; then
  echo "Please set env \$TARGET_VIRTUAL_SVC_NAME"
  exit 1
fi

if [ -z "$PROXY_TIMEOUT" ]; then
  echo "Please set env \$PROXY_TIMEOUT"
  exit 1
fi
