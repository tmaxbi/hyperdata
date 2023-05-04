# hive

1. install hive

        ```
        helm install hive hive -n hyperdata \
        --set image=${HARBOR_URL}/${HARBOR_REPO}/${IMAGE_NAME}:${TAG}
        ```
        
2. uninstall hive

        ```
        helm uninstall hive hive -n hyperdata
        ```

