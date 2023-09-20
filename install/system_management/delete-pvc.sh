#!/bin/bash

NAMESPACE=$1

if [ -z "${NAMESPACE}" ]; then
    echo "Usage: bash delete-pvc.sh <namespace>"
    exit 1
fi

# PostgreSQL 모듈의 PVC 삭제
function delete_postgresql_pvc() {
    echo "Deleting PostgreSQL PVCs in namespace: ${NAMESPACE}"

    kubectl delete pvc -n ${NAMESPACE} -l app.kubernetes.io/name=postgresql
}

# Rabbitmq 모듈의 PVC 삭제
function delete_rabbitmq_pvc() {
    echo "Deleting rabbitmq PVCs in namespace: ${NAMESPACE}"

    kubectl delete pvc -n ${NAMESPACE} -l app.kubernetes.io/name=rabbitmq
}

#  PVC 삭제 함수 호출
delete_postgresql_pvc
delete_rabbitmq_pvc

echo "PVC deletion complete."
