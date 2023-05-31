parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

export $(grep -v '^#' automl_config.properties | xargs -d '\n')

$parent_path/uninstall_automl_env_check.sh
[[ $? -ne 0 ]] && exit 1

helm delete -n $NAMESPACE hyperdata-ai
helm delete -n $NAMESPACE hyperdata-ai-argo
