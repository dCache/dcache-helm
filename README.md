# Helm chart for dCache deployments in Kubernetes

## TL;DR

```bash
helm repo add dcache https://gitlab.desy.de/api/v4/projects/7648/packages/helm/test
helm repo update
helm install my-release dcache/dcache
```

## Run special version

```bash
helm  install --set image.tag=10.0.3  my-release dcache/dcache
```

## Run only pools

Start pools `d` and `f`

```bash
helm  install --set image.tag=10.0.3 \
    --set dcache.door.enabled=false  \
    --set "dcache.pools={d,f}"  my-release dcache/dcache
```


## Acknowledgement

This project is based on work done by Michael Schuh, DESY-IT
