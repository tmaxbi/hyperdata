# calico

## Install

1. create calico namespace
```
kubectl create namespace calico-system
```

2. install calico operator
```
helm install -n calico-system calico-operator tigera-operator \
--set tigeraOperator.registry=quay.io \
--set tigeraOperator.image=tigera/operator \
--set tigeraOperator.version=v1.23.3 \
--set calicoctl.image=quay.io/docker.io/calico/ctl \
--set calicoctl.version=v3.21.2
```

3. install calico
```
helm install -n calico-system calico calico
```

## ref
- https://projectcalico.docs.tigera.io/getting-started/kubernetes/helm
- https://projectcalico.docs.tigera.io/getting-started/kubernetes/quickstart

## reproduce chart
```
helm repo add projectcalico https://docs.projectcalico.org/charts
helm pull projectcalico/tigera-operator --untar
```