#!/bin/bash
# Keycloak realm name
REALM_NAME=HyperDataRealm
# keycloak client access token 을 받위해 admin-cli 클라사용
CLIENT_ID=admin-cli
# HyperDataLogin client ID, HyperDataLogin 으로 설정했을때 안됨, setting in example-realm
HYPERDATA_CLIENT_ID=3576311a-bda1-47c6-9bd8-7cfa7bdc847a
# ud / password
KEYCLOAK_USERNAME=admin
KEYCLOAK_PASSWORD=admin
# login type
GRANT_TYPE=password
# Keycloak server URL
KEYCLOAK_URL=$1
access_token=$( curl -d "client_id=$CLIENT_ID" -d "username=$KEYCLOAK_USERNAME" -d "password=$KEYCLOAK_PASSWORD" -d "grant_type=$GRANT_TYPE" "$KEYCLOAK_URL/realms/master/protocol/openid-connect/token" | sed -n 's|.*"access_token":"\([^"]*\)".*|\1|p')

echo "New access_token: ${access_token}"
# Regenerate client secret
RESPONSE=$( \
    curl -X POST "${KEYCLOAK_URL}/admin/realms/${REALM_NAME}/clients/${HYPERDATA_CLIENT_ID}/client-secret" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer ${access_token}" \
    -d '{"temporary":false}' \
)

#echo "response: ${RESPONSE}"
# Parse new client secret from response
NEW_SECRET=$(echo $RESPONSE | jq -r '.value')

# Print new client secret
echo "New client secret: ${NEW_SECRET}"
