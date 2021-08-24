# rook-ceph

rook-ceph은 각 쿠버네티스 노드가 가지고 있는 스토리지의 개수 및 상태에 따라 적절한 설정이 필요합니다.

따라서, 아래 [ref](#ref)에 존재하는 documentation들을 읽고 설치 방법을 적절히 수정하길 권장합니다.

## Prerequisites
rook-ceph는 노드간 time이 동기화되어 있지 않는 경우, 정상동작하지 않을 수 있습니다.

ntp를 통해 서버간 시간을 동기화하는 것을 추천드립니다.

ntp 설정하는 방법은 troubleshooting.md(./troubleshooting.md)를 참조해주시길 바랍니다.

## Install

1. create rook-ceph namespace
```
kubectl create namespace rook-ceph
```

2. install rook-ceph operator
```
helm install -n rook-ceph rook-ceph rook-ceph \
--set image.repository=rook/ceph \
--set image.tag=v1.7.1 \
--set csi.cephcsi.image=quay.io/cephcsi/cephcsi:v3.4.0 \
--set csi.registrar.image=k8s.gcr.io/sig-storage/csi-node-driver-registrar:v2.2.0 \
--set csi.resizer.image=k8s.gcr.io/sig-storage/csi-resizer:v1.2.0 \
--set csi.provisioner.image=k8s.gcr.io/sig-storage/csi-provisioner:v2.2.2 \
--set csi.snapshotter.image=k8s.gcr.io/sig-storage/csi-snapshotter:v4.1.1 \
--set csi.attacher.image=k8s.gcr.io/sig-storage/csi-attacher:v3.2.1 \
--set csi.volumeReplication.image=quay.io/csiaddons/volumereplication-operator:v0.1.0
```

3. install rook-ceph cluster
```
helm install --wait -n rook-ceph rook-ceph-cluster rook-ceph-cluster \
--set cephClusterSpec.cephVersion.image=quay.io/ceph/ceph:v16.2.5 \
--set cephClusterSpec.mon.count=3 \
--set cephClusterSpec.mgr.count=1 \
--set cephClusterSpec.resources.osd.requests.cpu=2 \
--set cephClusterSpec.resources.osd.requests.memory=4Gi \
--set cephClusterSpec.resources.osd.limits.cpu=2 \
--set cephClusterSpec.resources.osd.limits.memory=4Gi \
--set cephClusterSpec.resources.mon.requests.cpu=2 \
--set cephClusterSpec.resources.mon.requests.memory=2Gi \
--set cephClusterSpec.resources.mon.limits.cpu=2 \
--set cephClusterSpec.resources.mon.limits.memory=2Gi \
--set cephClusterSpec.resources.mgr.requests.cpu=1 \
--set cephClusterSpec.resources.mgr.requests.memory=1Gi \
--set cephClusterSpec.resources.mgr.limits.cpu=1 \
--set cephClusterSpec.resources.mgr.limits.memory=1Gi
```

4. set rook-ceph storageclass as default
```
kubectl patch storageclass ceph-block -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'
kubectl patch storageclass ceph-filesystem -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'
```

## ref
- https://github.com/tmax-cloud/hypercloud-sds/blob/master/docs/ceph-cluster-setting.md
- https://github.com/rook/rook/blob/master/Documentation/helm-operator.md
- https://github.com/rook/rook/blob/master/Documentation/helm-ceph-cluster.md
- https://github.com/rook/rook/blob/master/Documentation/ceph-teardown.md
- https://kubernetes.io/docs/tasks/administer-cluster/change-default-storage-class/

## reproduce chart
```
helm repo add rook-release https://charts.rook.io/release
helm pull rook-release/rook-ceph --untar
helm pull rook-release/rook-ceph-cluster --untar
```