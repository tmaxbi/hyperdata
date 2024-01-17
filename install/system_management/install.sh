function wait_until_installation(){

        cond=$1
        timeout=$2
        
	echo $cond $timeout

	for ((i=0; i< timeout; i+=5)); do
                echo "Waiting for ${i}s condition: \"$cond\""
                var=$(eval "$cond")
                if [[ -n $var ]]; then
                        echo "Condition met"
                        return 0
                fi
                sleep 5
        done
	echo "Condition timeout"
	return 1
}

function install_postgresql(){

	echo "INSTALL POSTGRESQL NAMESPACE: " ${1}

	helm install postgresql postgresql \
	-n ${1} \
	--set global.postgresql.auth.postgresPassword=admin \
	--set global.postgresql.auth.username=admin \
	--set global.postgresql.auth.password=admin \
	--set global.postgresql.auth.database=keycloak \
	--set global.postgresql.service.ports.postgresql=5555 \
	--set primary.livenessProbe.initialDelaySeconds=240

	#kubectl wait --for=condition=Ready pod/postgresql-0 -n $NAMESPACE
	wait_until_installation "kubectl get po postgresql-0 -n ${1} | grep 1/1" 360
	wait_until_installation "kubectl logs postgresql-0 -n ${1} | grep 'database system is ready to accept connections'" 360
}

function install_keycloak(){

	echo "INSTALL KEYCLOAK NAMESPACE: " ${1} "POSTGRESQL IP: " ${2}

	helm install keycloak keycloak \
	-n ${1} \
	--set auth.adminUser=admin \
	--set auth.adminPassword=admin \
	--set postgresql.enabled=false \
	--set externalDatabase.host=${2} \
	--set externalDatabase.port=5555 \
	--set externalDatabase.user=admin \
	--set externalDatabase.password=admin \
	--set externalDatabase.database=keycloak \
	--set ingress.enabled=true \
	--set service.type=NodePort \
	--set service.ports.http=8888

	#kubectl wait --for=condition=Ready pod/keycloak-0 -n $NAMESPACE 
	wait_until_installation "kubectl get po keycloak-0 -n ${1} | grep 1/1" 360
	wait_until_installation "kubectl logs keycloak-0 -n ${1} | grep 'org.keycloak.quarkus.runtime.KeycloakMain'" 360
}

function install_system(){

	echo "INSTALL SYSTEM NAMESPACE: " ${1} "SYSTEM IMAGE FULL PATH: " ${2} "KEYCLOAK SECRET: " ${3} "KEYCLOAK URL" ${4}

	helm install hyperdata-system . \
	-n ${1} \
	--set image.fullPath=${2} \
	--set keycloak.secret=${3} \
	--set keycloak.authServerUrl=${4}

}

function install_rabbitmq() {
        echo "INSTALL RABBITMQ NAMESPACE: " ${1}

        helm install rabbitmq rabbitmq \
        -n ${1}

        #kubectl wait --for=condition=Ready pod/rabbitmq-0 -n $NAMESPACE
        wait_until_installation "kubectl get po rabbitmq-0 -n ${1} | grep 1/1" 360

}


NAMESPACE=$1
IMAGE=$2

# Install postgresql and get values
install_postgresql $NAMESPACE
POSTGRESQL_IP=$(kubectl get service/postgresql -n $NAMESPACE -o jsonpath='{.spec.clusterIP}')

echo "WAIT UNTIL POSTGRESQL READY.."
#sleep 240

# Install keycloak and get values
install_keycloak $NAMESPACE $POSTGRESQL_IP
NODE_PORT=$(kubectl get --namespace $NAMESPACE -o jsonpath="{.spec.ports[0].nodePort}" services keycloak)
NODE_IP=$(kubectl get nodes --namespace $NAMESPACE -o jsonpath="{.items[0].status.addresses[0].address}")
KEYCLOAK_URL=http://$NODE_IP:$NODE_PORT
echo "KEYCLOAK_URL: " $KEYCLOAK_URL

echo "WAIT UNTIL KEYCLOAK READY.."
#sleep 300

# Execute keycloak-script 
bash keycloak/keycloak-script/configure-keycloak.sh $KEYCLOAK_URL

echo "WAIT UNTIL REALM READY.."
#sleep 120

#Install rabbitmq and get values
install_rabbitmq $NAMESPACE

echo "WAIT UNTIL RABBITMQ READY.."

TOKEN=$(bash keycloak/keycloak-script/client-secret.sh $KEYCLOAK_URL | cut -d ' ' -f 4)
echo "TOKEN: " $TOKEN

echo "-----------------------------------------"
echo "POSTGRESQL SERVICE IP: " $POSTGRESQL_IP
echo "HYPERDATA-SYSTEM SERVICE_IP: " http://$NODE_IP:$NODE_PORT
echo "KEYCLOAK_URL: : " $KEYCLOAK_URL
echo "TOKEN: " $TOKEN
echo "-----------------------------------------"

# Install system and get values
install_system $NAMESPACE $IMAGE $TOKEN $KEYCLOAK_URL



