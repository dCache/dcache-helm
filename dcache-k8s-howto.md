# dCache in Kubernetes

1. [Requirements](#requirements)
1. [Minikube nano-HowTo](#minikube-env)
1. [Preparing Helm](#helm-env)
1. [Starting dCache](#starting-dcache)
1. [Accessing admin interface with SSH](#accessing-admin-interface)
1. [Accessing with from client host](#accessing-with-client)
1. [Exposing admin pages and frontend](#quick-access-to-admin-pages-and-frontend)

## Requirements

- Access to kubernetes cluster (or local minikube installation). All examples below 
  should work with both, unless noted otherwise.
- Kubernetes cli client
- Helm cli client

## Minikube env (optional)

Download the latest version of minikube:

```
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
```

### Rootless installation with podman

```
minikube config set rootless true
minikube start --driver=podman --container-runtime=containerd 
```

## Helm env

Install helm as described in official [docs](https://helm.sh/docs/intro/install/) and
add helm repositories:

```
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add dcache https://gitlab.desy.de/api/v4/projects/7648/packages/helm/test
helm repo update
```

## Starting dCache

To start dCache in kubernetes two steps are required:

1. start required external components
1. start dcache

It's recommended to run dCache instance in a dedicated kubernetes namespace, for
example, _dcache-test_:

```
kubectl create namespace dcache-test
kubectl config set-context --current --namespace=dcache-test 
```

All following commands assume that the namespace is set. Otherwise `-n other-namespace`
flag should be passed to all `helm` and `kubeclt` commands.

Then start required infrastructure (zookeeper, postgresql, kafka) 

```
helm install --wait --set auth.username=dcache --set auth.password=let-me-in --set auth.database=chimera  chimera bitnami/postgresql
helm install --wait cells bitnami/zookeeper
helm install --wait --set externalZookeeper.servers=cells-zookeeper --set kraft.enabled=false billing bitnami/kafka --version 23.0.7
```

Then start dCache

```
helm install --wait --set image.tag=9.2.1 store dcache/dcache
```

All running helm charts can be listed with:

```
helm list
```

## Accessing admin interface

```
kubectl run -ti --rm --image=kroniak/ssh-client admin -- ssh -p 22224 admin@store-door-svc
```

## Accessing with client

Starting a client host and attach to it.

```
kubectl run --image=almalinux:9 wn -- sleep inf
kubectl -ti exec wn -- /bin/bash
kubectl -ti exec wn -- curl -v -k -X HEAD https://store-door-svc:8083/ 
```

## Quick access to admin pages and frontend

(For minikube users)

```
kubectl expose pod store-dcache-door-0 --type=NodePort --port=2288 --name="web-admin"
kubectl expose pod store-dcache-door-0 --type=NodePort --port=3880 --name="frontend" 
```

```
minikube service web-admin -n dcache-test
```
