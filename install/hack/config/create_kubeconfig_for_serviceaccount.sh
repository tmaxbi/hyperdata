# The script returns a kubeconfig for the service account given
# you need to have kubectl on PATH with the context set to the cluster you want to create the config for

# Cosmetics for the created config
clusterName=some-cluster
# your server address goes here get it via `kubectl cluster-info`
server=https://157.90.17.72:6443
# the Namespace and ServiceAccount name that is used for the config
namespace=kube-system
serviceAccount=developer

######################
# actual script starts
set -o errexit

secretName=$(kubectl --namespace $namespace get serviceAccount $serviceAccount -o jsonpath='{.secrets[0].name}')
ca=$(kubectl --namespace $namespace get secret/$secretName -o jsonpath='{.data.ca\.crt}')
token=$(kubectl --namespace $namespace get secret/$secretName -o jsonpath='{.data.token}' | base64 --decode)

echo "
---
apiVersion: v1
kind: Config
clusters:
  - name: ${clusterName}
    cluster:
      certificate-authority-data: ${ca}
      server: ${server}
contexts:
  - name: ${serviceAccount}@${clusterName}
    context:
      cluster: ${clusterName}
      namespace: ${namespace}
      user: ${serviceAccount}
users:
  - name: ${serviceAccount}
    user:
      token: ${token}
current-context: ${serviceAccount}@${clusterName}
"
