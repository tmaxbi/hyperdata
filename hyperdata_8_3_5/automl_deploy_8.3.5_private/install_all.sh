parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

echo "==== READ AUTOML_CONFIG ===="
export $(grep -v '^#' automl_config.properties | xargs -d '\n')
echo "==== READ AUTOML_CONFIG END ===="

echo "==== CHECK AUTOML ENV ===="
$parent_path/install_automl_env_check.sh
[[ $? -ne 0 ]] && exit 1
echo "==== CHECK AUTOML ENV END ===="

echo "==== INSTALL HELM ===="
$parent_path/1.install_helm.sh
[[ $? -ne 0 ]] && exit 1
echo "==== INSTALL HELM END ===="

echo "==== INSTALL AUTOML ===="
$parent_path/2.install_automl.sh
[[ $? -ne 0 ]] && exit 1
echo "==== INSTALL AUTOML END ===="

echo "COMPLETE"
