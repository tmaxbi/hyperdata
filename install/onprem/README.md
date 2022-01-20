# Hyperdata OnPrem 설치 가이드

## version

- CentOS7
- kubernetes 1.19.14
- Calico 3.9.5

## docker registry
빠른 설치를 위해 docker에 registry를 설치합니다.

```
docker run -dit --name docker-reigstry -p 5000:5000 registry
```

docker registry는 http로 통신하기 때문에 **master 및 worker로 사용할 모든 노드에 insecure registry 등록**을 해야 합니다.
```
vi /etc/docker/daemon.json

{
  "insecure-registries": ["${YOUR DOCKER REGISTRY ADDRESS}(ex. 192.168.179.44:5000)"]
}
```

## 고려사항
1. master node도 pod가 동작하길 원할 경우, master node의 no schedule taint를 제거해주어야 합니다.
```
kubectl taint node ${MASTER NODE NAME} node-role.kubernetes.io/master:NoSchedule-
```

2. 폐쇄망일 경우, helm 설치 명령어에서 주소를 이미지 레지스트리로 변경해서 설치해주시길 바랍니다.
<pre>
# metallb helm example
helm install -n metallb-system metallb metallb \
--set controller.image.repository=<b><del>quay.io</del>192.168.179.44:5000</b>/metallb/controller \
--set controller.image.tag=v0.10.2 \
--set speaker.image.repository=<b><del>quay.io</del>192.168.179.44:5000</b>/metallb/speaker \
--set speaker.image.tag=v0.10.2 \
--set configInline.address-pools[0].addresses[0]=192.168.179.37-192.168.179.39
</pre>

3. tibero의 경우, sysctl의 kernel.sem을 사용하므로 kubeadm 설치 시 allow해주어야 합니다.

    3.1. kubeadm 설치 시 옵션을 추가해줍니다.
    ```
    kubeadm init --allowed-unsafe-sysctls 'kernel.sem'
    ```

    3.2. 또는 이미 설치했을 시, **모든 노드**의 kubelet config.yaml을 수정해줍니다.
    <pre>
    $ vi /var/lib/kubelet/config.yaml
    apiVersion: kubelet.config.k8s.io/v1beta1
    <b>allowedUnsafeSysctls:
    - "kernel.sem"</b>
    ...

    $ systemctl restart kubelet
</pre>

## Install Order
1. [rook-ceph](./rook-ceph)
2. [metallb](./metallb)
3. [istio](./istio)(Optional for mlplatform)
4. [knative-serving](./knative-serving)(Optional for mlplatform)
5. [cert-manager](./cert-manager)(Optional for mlplatform)
6. [kfserving](./kfserving)(Optional for mlplatform)
7. [notebook-controller](./notebook-controller)(Optional for mlplatform)
8. [argo](./argo)(Optional for mlplatform)
9. [nginx](./nginx)
10. [ozone](./ozone)
11. [tibero](./tibero)
12. [hyperdata](./hyperdata)
13. [kca](./kca)
14. [neo4j](./neo4j)
15. [mlplatform](./mlplatform)

## Optional
- [gpu-operator](./gpu-operator)
- [prometheus](./prometheus)