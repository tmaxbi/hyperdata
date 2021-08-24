set -e

parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

export $(grep -v '^#' image_config.properties | xargs -d '\n')

function pull_and_push {
  docker pull $1
  docker tag $1 $2
  docker push $2
}


# metallb
pull_and_push quay.io/metallb/controller:${METALLB_CONTROLLER} ${REMOTE_REGISTRY}/metallb/controller:${METALLB_CONTROLLER}
pull_and_push quay.io/metallb/speaker:${METALLB_CONTROLLER} ${REMOTE_REGISTRY}/metallb/speaker:${METALLB_CONTROLLER}

# rook-ceph
pull_and_push quay.io/cephcsi/cephcsi:${ROOK_CEPH_CSI} ${REMOTE_REGISTRY}/cephcsi/cephcsi:${ROOK_CEPH_CSI}

pull_and_push k8s.gcr.io/sig-storage/csi-node-driver-registrar:${ROOK_CEPH_CSI_REGISTRAR} ${REMOTE_REGISTRY}/sig-storage/csi-node-driver-registrar:${ROOK_CEPH_CSI_REGISTRAR}

pull_and_push k8s.gcr.io/sig-storage/csi-resizer:${ROOK_CEPH_CSI_RESIZER} ${REMOTE_REGISTRY}/sig-storage/csi-resizer:${ROOK_CEPH_CSI_RESIZER}

pull_and_push k8s.gcr.io/sig-storage/csi-provisioner:${ROOK_CEPH_CSI_PROVISIONER} ${REMOTE_REGISTRY}/sig-storage/csi-provisioner:${ROOK_CEPH_CSI_PROVISIONER}

pull_and_push k8s.gcr.io/sig-storage/csi-snapshotter:${ROOK_CEPH_CSI_SNAPSHOTTER} ${REMOTE_REGISTRY}/sig-storage/csi-snapshotter:${ROOK_CEPH_CSI_SNAPSHOTTER}

pull_and_push k8s.gcr.io/sig-storage/csi-attacher:${ROOK_CEPH_CSI_ATTACHER} ${REMOTE_REGISTRY}/sig-storage/csi-attacher:${ROOK_CEPH_CSI_ATTACHER}

pull_and_push quay.io/csiaddons/volumereplication-operator:${ROOK_CEPH_VOLUME_REPLICA} ${REMOTE_REGISTRY}/csiaddons/volumereplication-operator:${ROOK_CEPH_VOLUME_REPLICA}

pull_and_push quay.io/ceph/ceph:${ROOK_CEPH_CLUSTER} ${REMOTE_REGISTRY}/ceph/ceph:${ROOK_CEPH_CLUSTER}

# istio
pull_and_push istio/pilot:${ISTIO_PILOT} ${REMOTE_REGISTRY}/istio/pilot:${ISTIO_PILOT}

pull_and_push istio/proxyv2:${ISTIO_PROXY} ${REMOTE_REGISTRY}/istio/proxyv2:${ISTIO_PROXY}

# knative-serving
pull_and_push gcr.io/knative-releases/knative.dev/serving/cmd/queue:${KNATIVE_QUEUEPROXY} ${REMOTE_REGISTRY}/knative-releases/knative.dev/serving/cmd/queue:${KNATIVE_QUEUEPROXY}

pull_and_push gcr.io/knative-releases/knative.dev/serving/cmd/activator:${KNATIVE_ACTIVATOR} ${REMOTE_REGISTRY}/knative-releases/knative.dev/serving/cmd/activator:${KNATIVE_ACTIVATOR}

pull_and_push gcr.io/knative-releases/knative.dev/serving/cmd/autoscaler:${KNATIVE_AUTOSCALER} ${REMOTE_REGISTRY}/knative-releases/knative.dev/serving/cmd/autoscaler:${KNATIVE_AUTOSCALER}

pull_and_push gcr.io/knative-releases/knative.dev/serving/cmd/controller:${KNATIVE_CONTROLLER} ${REMOTE_REGISTRY}/knative-releases/knative.dev/serving/cmd/controller:${KNATIVE_CONTROLLER}

pull_and_push gcr.io/knative-releases/knative.dev/serving/cmd/webhook:${KNATIVE_WEBHOOK} ${REMOTE_REGISTRY}/knative-releases/knative.dev/serving/cmd/webhook:${KNATIVE_WEBHOOK}

pull_and_push gcr.io/knative-releases/knative.dev/net-istio/cmd/webhook:${KNATIVE_ISTIO_WEBHOOK} ${REMOTE_REGISTRY}/knative-releases/knative.dev/net-istio/cmd/webhook:${KNATIVE_ISTIO_WEBHOOK}

pull_and_push gcr.io/knative-releases/knative.dev/net-istio/cmd/controller:${KNATIVE_ISTIO_CONTROLLER} ${REMOTE_REGISTRY}/knative-releases/knative.dev/net-istio/cmd/controller:${KNATIVE_ISTIO_CONTROLLER}

# cert manager
pull_and_push quay.io/jetstack/cert-manager-controller:${CERT_MANAGER_CONTROLLER} ${REMOTE_REGISTRY}/jetstack/cert-manager-controller:${CERT_MANAGER_CONTROLLER}

pull_and_push quay.io/jetstack/cert-manager-webhook:${CERT_MANAGER_WEBHOOK} ${REMOTE_REGISTRY}/jetstack/cert-manager-webhook:${CERT_MANAGER_CONTROLLER}

pull_and_push quay.io/jetstack/cert-manager-cainjector:${CERT_MANAGER_CAINJECTOR} ${REMOTE_REGISTRY}/jetstack/cert-manager-cainjector:${CERT_MANAGER_CONTROLLER}

pull_and_push quay.io/jetstack/cert-manager-ctl:${CERT_MANAGER_CTL} ${REMOTE_REGISTRY}/jetstack/cert-manager-ctl:${CERT_MANAGER_CONTROLLER}

# kfserving
pull_and_push kfserving/models-web-app:${KFSERVING_MODELS_WEB_APP} ${REMOTE_REGISTRY}/kfserving/models-web-app:${KFSERVING_MODELS_WEB_APP}

pull_and_push gcr.io/kfserving/kfserving-controller:${KFSERVING_CONTROLLER} ${REMOTE_REGISTRY}/kfserving/kfserving-controller:${KFSERVING_CONTROLLER}

pull_and_push gcr.io/kubebuilder/kube-rbac-proxy:${KFSERVING_KUBE_RBAC_PROXY} ${REMOTE_REGISTRY}/kubebuilder/kube-rbac-proxy:${KFSERVING_KUBE_RBAC_PROXY}


# notebook
pull_and_push gcr.io/kubeflow-images-public/notebook-controller:${NOTEBOOK_CONTROLLER} ${REMOTE_REGISTRY}/kubeflow-images-public/notebook-controller:${NOTEBOOK_CONTROLLER}

# argo
pull_and_push argoproj/workflow-controller:${ARGO_WORKFLOW_CONTROLLER} ${REMOTE_REGISTRY}/argoproj/workflow-controller:${ARGO_WORKFLOW_CONTROLLER}

# nginx
pull_and_push nginx/nginx-ingress:${NGINX_INGRESS} ${REMOTE_REGISTRY}/nginx/nginx-ingress:${NGINX_INGRESS}

# hyperdata
#pull_and_push ${HYPERDATA_REGISTRY}/hyperdata/hyperdata8.3_tb:${TIBERO} ${REMOTE_REGISTRY}/hyperdata/hyperdata8.3_tb:${TIBERO}

#pull_and_push ${HYPERDATA_REGISTRY}/hyperdata/hyperdata20.4_hd:${HYPERDATA} ${REMOTE_REGISTRY}/hyperdata/hyperdata20.4_hd:${HYPERDATA}

#pull_and_push ${HYPERDATA_REGISTRY}/hyperdata/hyperdata20.4_mlplatform_backend:${MLPLATFORM_BACKEND} ${REMOTE_REGISTRY}/hyperdata/hyper#data20.4_mlplatform_backend:${MLPLATFORM_BACKEND}

#pull_and_push ${HYPERDATA_REGISTRY}/hyperdata/hyperdata20.4_mlplatform_backend:${MLPLATFORM_FRONTEND} ${REMOTE_REGISTRY}/hyperdata/hyperdata20.4_mlplatform_backend:${MLPLATFORM_FRONTEND}

#pull_and_push hdml/mllab_train:tf_v1.14.0 ${REMOTE_REGISTRY}/hdml/mllab_train:tf_v1.14.0

#pull_and_push hdml/mllab_train:tf_v1.15.2 ${REMOTE_REGISTRY}/hdml/mllab_train:tf_v1.15.2

#pull_and_push hdml/mllab_train:tf_v2.1.0 ${REMOTE_REGISTRY}/hdml/mllab_train:tf_v2.1.0

#pull_and_push hdml/mllab_train:torch_v1.6.0 ${REMOTE_REGISTRY}/hdml/mllab_train:torch_v1.6.0