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

## Add extra onfiguraton to dcache.conf of layout.conf files

Two configuration properties control the: `dcache.configExtra` and `dcache.layoutExtra`. With a value files the confuguration can be adjusted as needed:

```yaml
dcache:
  configExtra: |
    custom.property = value

  layoutExtra: |
    [customDomain]
    [customDomain/cell]
```

```bash
helm  install --values custom-config.yaml my-release dcache/dcache
```

> [!NOTE]: The custom configurations are added at the end of dcache and layout conf files.

## Enable CTA plugin

```bash
helm  install --set dcache.plugins.cta.enabled=true  my-release dcache/dcache
```

## Accessing admin interface

```bash
kubectl run --rm -ti admin-ssh --image kroniak/ssh-client -- ssh -p 22224 -l admin <my-release>-door-svc
```

## Accessing Frontend

```bash
kubectl port-forward svc/<my-release>-door-svc 3880:3880
```


## Acknowledgement

This project is based on work done by Michael Schuh, DESY-IT
