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

The configuration properties `dcache.configExtraPre`, `dcache.configExtra`, `dcache.layoutExtraPre`
and `dcache.layoutExtra` allow adding an extra configurations at the begging and at the end of the
generated `dcache.conf` and `layout.conf` files.

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

## Zookeeper

dCache requires a Zookeeper instance to operate. You can either use an external Zookeeper or deploy an embedded Zookeeper instance together with dCache.
By default, the chart is configured to use an external Zookeeper instance running at `cells-zookeeper:2181`. To deploy an embedded Zookeeper instance, set the following value:

```yaml
zookeeper:
  embedded: true
```

or use the command line:

```bash
helm  install --set zookeeper.embedded=true my-release dcache/dcache
```

The list of Zookeeper servers can be configured via the `zookeeper.servers` value.

```yaml
zookeeper:
  servers: zookeeper1:2181,zookeeper2:2181,zookeeper3:2181
```

or via command line:

```bash
helm  install --set zookeeper.servers="zookeeper1:2181,zookeeper2:2181,zookeeper3:2181" my-release dcache/dcache
```

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
