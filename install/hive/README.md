# hive

1. install hyperdata

        ```
        helm install hive hive -n hyperdata \
        --set image=${HARBOR_URL}/${HARBOR_REPO}/${IMAGE_NAME}:${TAG}

