if [ -z "$NAMESPACE" ]; then
  echo "Please set env \$NAMESPACE(ex. hyperdata)"
  exit 1
fi

if [ -z "$NGINX_IP" ]; then
  echo "Cannot find hyperdata ip(\$NGINX_IP)(ex. 192.168.157.22)"
  exit 1
fi

if [ -z "$NGINX_PORT" ]; then
  echo "Cannot find hyperdata port(\$NGINX_PORT)(ex. 8080)"
  exit 1
fi

if [ -z "$KFSERVING_ADDRESS" ]; then
  echo "Cannot find kfserving address(\$KFSERVING_ADDRESS)(ex. http://192.1.4.247:32380)"
  exit 1
fi

if [ -z "$IMG_SECRET" ]; then
  echo "Please set env \$IMG_SECRET(ex. no-secret_"
  exit 1
fi

if [ -z "$AUTOML_IMG" ]; then
  echo "Please set env \$AUTOML_IMG"
  exit 1
fi

if [ -z "$ARGO_CONTROLLER_IMG" ]; then
  echo "Please set env \$ARGO_CONTROLLER_IMG"
  exit 1
fi

if [ -z "$ARGO_EXEC_IMG" ]; then
  echo "Please set env \$ARGO_EXEC_IMG"
  exit 1
fi

if [ -z "$DOLOADER_IMG" ]; then
  echo "Please set env \$DOLOADER_IMG"
  exit 1
fi

if [ -z "$FE_IMG" ]; then
  echo "Please set env \$FE_IMG"
  exit 1
fi

if [ -z "$XGB_IMG" ]; then
  echo "Please set env \$XGB_IMG"
  exit 1
fi

if [ -z "$RF_IMG" ]; then
  echo "Please set env \$RF_IMG"
  exit 1
fi

if [ -z "$TIMESERIES_IMG" ]; then
  echo "Please set env \$TIMESERIES_IMG"
  exit 1
fi

if [ -z "$DOWNLOADER_IMG" ]; then
  echo "Please set env \$DOWNLOADER_IMG"
  exit 1
fi

if [ -z "$WOORI_IMG" ]; then
  echo "Please set env \$WOORI_IMG"
  exit 1
fi

if [ -z "$RESULTUPLOADER_IMG" ]; then
  echo "Please set env \$RESULTUPLOADER_IMG"
  exit 1
fi

if [ -z "$WOORI_SERVING_IMG" ]; then
  echo "Please set env \$WOORI_SERVING_IMG"
  exit 1
fi

if [ -z "$SCHEDULER_IMG" ]; then
  echo "Please set env \$SCHEDULER_IMG"
  exit 1
fi

if [ -z "$CONTAINER_RUNTIME_EXECUTOR" ]; then
  echo "Please set env \$CONTAINER_RUNTIME_EXECUTOR"
  exit 1
fi

if [ -z "$ENABLE_HTTPS" ]; then
  echo "Please set env \$ENABLE_HTTPS"
  exit 1
fi
