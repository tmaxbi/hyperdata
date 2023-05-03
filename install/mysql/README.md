# mysql

1. install mysql

        ```
        helm install  mysql mysql -n hyperdata \
        --set image=${HARBOR_URL}/${HARBOR_REPO}/${IMAGE_NAME}:${TAG}
