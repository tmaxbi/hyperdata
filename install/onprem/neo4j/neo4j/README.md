# Neo4j

> This chart is based on the [official neo4j enterprise helm chart](https://github.com/helm/charts/tree/master/stable/neo4j), modified to deploy a single-instance neo4j-community deployment.

[Neo4j](https://neo4j.com/) is a highly scalable native graph database that
leverages data relationships as first-class entities, helping enterprises build
intelligent applications to meet today’s evolving data challenges.

## TL;DR;

```bash
helm repo add equinor-charts https://equinor.github.io/helm-charts/charts/
helm repo update
helm upgrade --install neo4j-community equinor-charts/neo4j-community
```

## Introduction

This chart bootstraps a [Neo4j](https://github.com/neo4j/docker-neo4j)
deployment on a [Kubernetes](http://kubernetes.io) cluster using the
[Helm](https://helm.sh) package manager.

## Prerequisites

* Helm 3
* Kubernetes 1.6+ with Beta APIs enabled
* PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `neo4j-community`:

```bash
helm upgrade --install neo4j-community equinor-charts/neo4j-community --set acceptLicenseAgreement=yes --set neo4jPassword=mySecretPassword
```

You must explicitly accept the neo4j license agreement for the installation to be successful.

The command deploys Neo4j on the Kubernetes cluster in the default configuration
but with the password set to `mySecretPassword`. The
[configuration](#configuration) section lists the parameters that can be
configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `neo4j-community` deployment:

```bash
helm delete neo4j-community
```

The command removes all the Kubernetes components associated with the chart and
deletes the release.

## Configuration

The following table lists the configurable parameters of the Neo4j chart and
their default values.

| Parameter                            | Description                                                                                                                             | Default                                         |
| ------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------- |
| `image`                              | Neo4j image                                                                                                                             | `neo4j`                                         |
| `imageTag`                           | Neo4j version                                                                                                                           | `{VERSION}`                                     |
| `imagePullPolicy`                    | Image pull policy                                                                                                                       | `IfNotPresent`                                  |
| `nodeSelector`                       | Pod node selector                                                                                                                       | `{}`                                            |
| `tolerations`                        | Pod tolerations                                                                                                                         | `[]`                                            |
| `affinity`                           | Pod affinity                                                                                                                            | `{}`                                            |
| `authEnabled`                        | Is login/password required?                                                                                                             | `true`                                          |
| `neo4jPassword`                      | Password to log in the Neo4J database if password is required                                                                           | (random string of 10 characters)                |
| `existingPasswordSecret`             | Secret name containing the password for neo4j user                                                                                      | ``                                              |
| `existingPasswordSecretKey`          | key in existingPasswordSecret, in which the password is contained                                                                       | ``                                              |
| `persistentVolume.enabled`           | Whether or not persistence is enabled                                                                                                   | `true`                                          |
| `persistentVolume.mountPath`         | Persistent Volume mount root path                                                                                                       | `/data`                                         |
| `persistentVolume.size`              | Size of data volume                                                                                                                     | `10Gi`                                          |
| `persistentVolume.storageClass`      | Storage class of backing PVC                                                                                                            | `standard` (uses beta storage class annotation) |
| `persistentVolume.subPath`           | Subdirectory of the volume to mount                                                                                                     | `nil`                                           |
| `extraVars`                          | Extra environment variables to set                                                                                                      | `nil`                                           |
| `sideCarContainers`                  | Sidecar containers to add to the core pod. Example use case is a sidecar which identifies and labels the leader when using the http API | `[]`                                            |
| `initContainers`                     | Init containers to add to the core pod. Example use case is a script that installs the APOC library                                     | `[]`                                            |
| `resources`                          | Resources required (e.g. CPU, memory)                                                                                                   | `{}`                                            |
| `service.type`                       | Type of the service                                                                                                                     | `ClusterIP`                                     |
| `service.annotations`                | Annotations to be added to service                                                                                                      | `{}`                                            |
| `service.labels`                     | Labels to be added to service                                                                                                           | `{}`                                            |
| `service.loadBalancerSourceRanges`   | Traffic through the load-balancer will be restricted to the specified client IPs (for `service.type: LoadBalancer`)                     | `[]`                                            |
| `rbac.create`                        | Whether to create RBAC for Neo4j                                                                                                        | `false`                                         |
| `serviceAccount.create`              | Whether to create service account of Neo4j                                                                                              | `true`                                          |
| `serviceAccount.annotations`         | Annotations to be added to service account                                                                                              | `{}`                                            |
| `serviceAccount.name`                | Service account name                                                                                                                    | ``                                              |
| `podLabels`                          | Labels to be added to pods                                                                                                              | `{}`                                            |
| `podAnnotations`                     | Annotations to be added to pods                                                                                                         | `{}`                                            |
| `additionalVolumes`                  | Additional volumes to mount in the Neo4j container                                                                                      | `[]`                                            |
| `additionalVolumeMounts`             | Where the additional volumes are mounted in the Neo4j container                                                                         | `[]`                                            |
| `terminationGracePeriodSeconds`      | Duration in seconds the pod needs to terminate gracefully                                                                               | `300`                                           |
| `readinessProbe.initialDelaySeconds` | Number of seconds after the container has started before probes are initiated                                                           | `60`                                            |
| `readinessProbe.failureThreshold`    | Minimum consecutive failures for the probe to be considered failed after having succeeded                                               | `3`                                             |
| `readinessProbe.timeoutSeconds`      | Number of seconds after which the probe times out                                                                                       | `2`                                             |
| `readinessProbe.periodSeconds`       | How often (in seconds) to perform the probe                                                                                             | `10`                                            |
| `readinessProbe.tcpSocket.port`      | TCP check against the pod's IP address on a specified port                                                                              | `7687`                                          |
| `livenessProbe.initialDelaySeconds`  | Number of seconds after the container has started before probes are initiated                                                           | `120`                                           |
| `livenessProbe.failureThreshold`     | Minimum consecutive failures for the probe to be considered failed after having succeeded                                               | `3`                                             |
| `livenessProbe.timeoutSeconds`       | Number of seconds after which the probe times out                                                                                       | `2`                                             |
| `livenessProbe.periodSeconds`        | How often (in seconds) to perform the probe                                                                                             | `10`                                            |
| `livenessProbe.tcpSocket.port`       | TCP check against the pod's IP address on a specified port                                                                              | `7687`                                          |
| `securityContext`                    | Security context to be added to pods                                                                                                    | `{}`                                            |
| `env.JMXPORT`                         | Port for jmxremote rmi port                                                                                                             | 1099 |
| `exporters.jmx`                       | Configuration for jmx exporter for Prometheus (disabled by default)                                                                                           |  see values.yaml |

The above parameters map to the env variables defined in the
[Neo4j docker image](https://github.com/neo4j/docker-neo4j).

Specify each parameter using the `--set key=value[,key=value]` argument to `helm
install`. For example,

```bash
helm upgrade --install neo4j-community equinor-charts/neo4j-community
```

Alternatively, a YAML file that specifies the values for the parameters can be
provided while installing the chart. For example,

```bash
helm upgrade --install neo4j-community -f values.yaml equinor-charts/neo4j-community
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Updating password

We can indeed reset that password without having to delete the PVC by:
1. Deleting the file `/var/lib/neo4j/data/dbms/auth`
1. Running `neo4j-admin set-initial-password <new password>`
1. Changing the password in the configured `secret`.
1. Deleting the pod to restart and pick up the latest configuration

## Special considerations when using AzureFile storage

If you want to use AzureFile you need to create a StorageClass with the neo4j user uid&gid in mount options:

```
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: azurefile-neo4j
provisioner: kubernetes.io/azure-file
reclaimPolicy: Retain
mountOptions:
  - dir_mode=0755
  - file_mode=0755
  - uid=101 # Allow write access for neo4j
  - gid=101 # Allow write access for neo4j
parameters:
  skuName: Standard_LRS
```

And use `--set persistentVolume.storageClass=azurefile-neo4j` when installing the chart.
