parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

echo "==== INSTALL HELM ===="
$parent_path/1.install_helm.sh
[[ $? -ne 0 ]] && exit 1
echo "==== INSTALL HELM END ===="

$parent_path/2.install_nginx.sh
[[ $? -ne 0 ]] && exit 1
