#!/bin/bash

NAMESPACE=$1

if [ -z "${NAMESPACE}" ]; then
    echo "Usage: bash delete.sh <namespace>"
    exit 1
fi

# PostgreSQL 모듈 삭제
function delete_postgresql() {
    echo "Deleting PostgreSQL in namespace: ${NAMESPACE}"
    helm delete postgresql -n ${NAMESPACE}
}

# Keycloak 모듈 삭제
function delete_keycloak() {
    echo "Deleting Keycloak in namespace: ${NAMESPACE}"
    helm delete keycloak -n ${NAMESPACE}
}

# System 모듈 삭제
function delete_system() {
    echo "Deleting System in namespace: ${NAMESPACE}"
    helm delete hyperdata-system -n ${NAMESPACE}
}

# RabbitMQ 모듈 삭제
function delete_rabbitmq() {
    echo "Deleting RabbitMQ in namespace: ${NAMESPACE}"
    helm delete rabbitmq -n ${NAMESPACE}
}

# 각 모듈 삭제 함수 호출
delete_postgresql
delete_keycloak
delete_system
delete_rabbitmq

echo "Module deletion complete."
