#!/bin/bash
set -e

parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

export $(grep -v '^#' image_config.properties | xargs -d '\n')

function pull_and_save {
  docker pull $1
  docker tag $1 $2

  split_image_name=(${2//\// })
  image_name_and_tag=${split_image_name[-1]}
  replaced_str_colon_and_dot_to_underscore=$( echo $image_name_and_tag | tr ":." "_" )
  tar_name="${3}_${replaced_str_colon_and_dot_to_underscore}.tar.gz"

  if [ ! -d tars ]; then
    mkdir tars
  fi

  if [ ! -f tars/$tar_name ]; then
    docker save -o tars/$tar_name $2
  fi
}


# metallb
pull_and_save ${REMOTE_REGISTRY}/metallb/controller:${METALLB_CONTROLLER} ${PRIVATE_REGISTRY}/metallb/controller:${METALLB_CONTROLLER} metallb
pull_and_save ${REMOTE_REGISTRY}/metallb/speaker:${METALLB_CONTROLLER} ${PRIVATE_REGISTRY}/metallb/speaker:${METALLB_CONTROLLER} metallb

# rook-ceph
pull_and_save ${REMOTE_REGISTRY}/cephcsi/cephcsi:${ROOK_CEPH_CSI} ${PRIVATE_REGISTRY}/cephcsi/cephcsi:${ROOK_CEPH_CSI} rookceph

pull_and_save ${REMOTE_REGISTRY}/csi-node-driver-registrar:${ROOK_CEPH_CSI_REGISTRAR} ${PRIVATE_REGISTRY}/sig-storage/csi-node-driver-registrar:${ROOK_CEPH_CSI_REGISTRAR} rookceph

pull_and_save ${REMOTE_REGISTRY}/sig-storage/csi-resizer:${ROOK_CEPH_CSI_RESIZER} ${PRIVATE_REGISTRY}/sig-storage/csi-resizer:${ROOK_CEPH_CSI_RESIZER} rookceph

pull_and_save ${REMOTE_REGISTRY}/sig-storage/csi-provisioner:${ROOK_CEPH_CSI_PROVISIONER} ${PRIVATE_REGISTRY}/sig-storage/csi-provisioner:${ROOK_CEPH_CSI_PROVISIONER} rookceph

pull_and_save ${REMOTE_REGISTRY}/sig-storage/csi-snapshotter:${ROOK_CEPH_CSI_SNAPSHOTTER} ${PRIVATE_REGISTRY}/sig-storage/csi-snapshotter:${ROOK_CEPH_CSI_SNAPSHOTTER} rookceph

pull_and_save ${REMOTE_REGISTRY}/sig-storage/csi-attacher:${ROOK_CEPH_CSI_ATTACHER} ${PRIVATE_REGISTRY}/sig-storage/csi-attacher:${ROOK_CEPH_CSI_ATTACHER} rookceph

pull_and_save ${REMOTE_REGISTRY}/csiaddons/volumereplication-operator:${ROOK_CEPH_VOLUME_REPLICA} ${PRIVATE_REGISTRY}/csiaddons/volumereplication-operator:${ROOK_CEPH_VOLUME_REPLICA} rookceph

pull_and_save ${REMOTE_REGISTRY}/ceph/ceph:${ROOK_CEPH_CLUSTER} ${PRIVATE_REGISTRY}/ceph/ceph:${ROOK_CEPH_CLUSTER} rookceph

# istio
pull_and_save ${REMOTE_REGISTRY}/istio/pilot:${ISTIO_PILOT} ${PRIVATE_REGISTRY}/istio/pilot:${ISTIO_PILOT} istio

pull_and_save ${REMOTE_REGISTRY}/istio/proxyv2:${ISTIO_PROXY} ${PRIVATE_REGISTRY}/istio/proxyv2:${ISTIO_PROXY} istio

# knative-serving
pull_and_save ${REMOTE_REGISTRY}/knative-releases/knative.dev/serving/cmd/queue:${KNATIVE_QUEUEPROXY} ${PRIVATE_REGISTRY}/knative-releases/knative.dev/serving/cmd/queue:${KNATIVE_QUEUEPROXY} knativeserving

pull_and_save ${REMOTE_REGISTRY}/knative-releases/knative.dev/serving/cmd/activator:${KNATIVE_ACTIVATOR} ${PRIVATE_REGISTRY}/knative-releases/knative.dev/serving/cmd/activator:${KNATIVE_ACTIVATOR} knativeserving

pull_and_save ${REMOTE_REGISTRY}/knative-releases/knative.dev/serving/cmd/autoscaler:${KNATIVE_AUTOSCALER} ${PRIVATE_REGISTRY}/knative-releases/knative.dev/serving/cmd/autoscaler:${KNATIVE_AUTOSCALER} knativeserving

pull_and_save ${REMOTE_REGISTRY}/knative-releases/knative.dev/serving/cmd/controller:${KNATIVE_CONTROLLER} ${PRIVATE_REGISTRY}/knative-releases/knative.dev/serving/cmd/controller:${KNATIVE_CONTROLLER} knativeserving

pull_and_save ${REMOTE_REGISTRY}/knative-releases/knative.dev/serving/cmd/webhook:${KNATIVE_WEBHOOK} ${PRIVATE_REGISTRY}/knative-releases/knative.dev/serving/cmd/webhook:${KNATIVE_WEBHOOK} knativeserving

pull_and_save ${REMOTE_REGISTRY}/knative-releases/knative.dev/net-istio/cmd/webhook:${KNATIVE_ISTIO_WEBHOOK} ${PRIVATE_REGISTRY}/knative-releases/knative.dev/net-istio/cmd/webhook:${KNATIVE_ISTIO_WEBHOOK} knativeserving

pull_and_save ${REMOTE_REGISTRY}/knative-releases/knative.dev/net-istio/cmd/controller:${KNATIVE_ISTIO_CONTROLLER} ${PRIVATE_REGISTRY}/knative-releases/knative.dev/net-istio/cmd/controller:${KNATIVE_ISTIO_CONTROLLER} knativeserving

# cert manager
pull_and_save ${REMOTE_REGISTRY}/jetstack/cert-manager-controller:${CERT_MANAGER_CONTROLLER} ${PRIVATE_REGISTRY}/jetstack/cert-manager-controller:${CERT_MANAGER_CONTROLLER} certmanager

pull_and_save ${REMOTE_REGISTRY}/jetstack/cert-manager-webhook:${CERT_MANAGER_WEBHOOK} ${PRIVATE_REGISTRY}/jetstack/cert-manager-webhook:${CERT_MANAGER_CONTROLLER} certmanager

pull_and_save ${REMOTE_REGISTRY}/jetstack/cert-manager-cainjector:${CERT_MANAGER_CAINJECTOR} ${PRIVATE_REGISTRY}/jetstack/cert-manager-cainjector:${CERT_MANAGER_CONTROLLER} certmanager

pull_and_save ${REMOTE_REGISTRY}/jetstack/cert-manager-ctl:${CERT_MANAGER_CTL} ${PRIVATE_REGISTRY}/jetstack/cert-manager-ctl:${CERT_MANAGER_CONTROLLER} certmanager

# kfserving
pull_and_save ${REMOTE_REGISTRY}/kfserving/models-web-app:${KFSERVING_MODELS_WEB_APP} ${PRIVATE_REGISTRY}/kfserving/models-web-app:${KFSERVING_MODELS_WEB_APP} kfserving

pull_and_save ${REMOTE_REGISTRY}/kfserving/kfserving-controller:${KFSERVING_CONTROLLER} ${PRIVATE_REGISTRY}/kfserving/kfserving-controller:${KFSERVING_CONTROLLER} kfserving

pull_and_save ${REMOTE_REGISTRY}/kubebuilder/kube-rbac-proxy:${KFSERVING_KUBE_RBAC_PROXY} ${PRIVATE_REGISTRY}/kubebuilder/kube-rbac-proxy:${KFSERVING_KUBE_RBAC_PROXY} kfserving


# notebook
pull_and_save ${REMOTE_REGISTRY}/kubeflow-images-public/notebook-controller:${NOTEBOOK_CONTROLLER} ${PRIVATE_REGISTRY}/kubeflow-images-public/notebook-controller:${NOTEBOOK_CONTROLLER} notebook

# argo
pull_and_save ${REMOTE_REGISTRY}/argoproj/workflow-controller:${ARGO_WORKFLOW_CONTROLLER} ${PRIVATE_REGISTRY}/argoproj/workflow-controller:${ARGO_WORKFLOW_CONTROLLER} argo

# nginx
pull_and_save ${REMOTE_REGISTRY}/ingress-nginx/controller:${INGRESS_NGINX} ${PRIVATE_REGISTRY}/ingress-nginx/controller:${INGRESS_NGINX} nginx

# hyperdata
pull_and_save ${REMOTE_REGISTRY}/hyperdata20.4_tb:${TIBERO} ${PRIVATE_REGISTRY}/hyperdata20.4_tb:${TIBERO} hyperdata

pull_and_save ${REMOTE_REGISTRY}/hyperdata20.4_hd:${HYPERDATA} ${PRIVATE_REGISTRY}/hyperdata20.4_hd:${HYPERDATA} hyperdata

pull_and_save ${REMOTE_REGISTRY}/hyperdata20.4_mlplatform_backend:${MLPLATFORM_BACKEND} ${PRIVATE_REGISTRY}/hyper#data20.4_mlplatform_backend:${MLPLATFORM_BACKEND} hyperdata

pull_and_save ${REMOTE_REGISTRY}/hyperdata20.4_mlplatform_frontend:${MLPLATFORM_FRONTEND} ${PRIVATE_REGISTRY}/hyperdata20.4_mlplatform_frontend:${MLPLATFORM_FRONTEND} hyperdata

pull_and_save ${REMOTE_REGISTRY}/hyperdata20.4_mlplatform_automl:${MLPLATFORM_AUTOML} ${PRIVATE_REGISTRY}/hyperdata20.4_mlplatform_automl:${MLPLATFORM_AUTOML}

pull_and_save ${REMOTE_REGISTRY}/hyperdata20.4_mlplatform_recommendation:${MLPLATFORM_RECOMMENDATION} ${PRIVATE_REGISTRY}/hyperdata20.4_mlplatform_recommendation:${MLPLATFORM_RECOMMENDATION}

pull_and_save ${REMOTE_REGISTRY}/mlplatform_notebook_tf_v1.15.2:${MLPLATFORM_NOTEBOOK_TF1152} ${PRIVATE_REGISTRY}/mlplatform_notebook_tf_v1.15.2:${MLPLATFORM_NOTEBOOK_TF1152} hyperdata

pull_and_save ${REMOTE_REGISTRY}/mlplatform_notebook_tf_v2.1.0:${MLPLATFORM_NOTEBOOK_TF210} ${PRIVATE_REGISTRY}/mlplatform_notebook_tf_v2.1.0:${MLPLATFORM_NOTEBOOK_TF210} hyperdata

pull_and_save ${REMOTE_REGISTRY}/mlplatform_notebook_pytorch_v1.6.0:${MLPLATFORM_NOTEBOOK_TORCH160} ${PRIVATE_REGISTRY}/mlplatform_notebook_torch_v1.6.0:${MLPLATFORM_NOTEBOOK_TORCH160} hyperdata

pull_and_save ${REMOTE_REGISTRY}/mlplatform_notebook_statistic_analysis_1.1.0:${MLPLATFORM_NOTEBOOK_ANALYSIS110} ${PRIVATE_REGISTRY}/mlplatform_notebook_statistic_analysis_1.1.0:${MLPLATFORM_NOTEBOOK_ANALYSIS110} hyperdata
