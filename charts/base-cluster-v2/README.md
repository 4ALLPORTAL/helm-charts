# base-cluster-v2

![Version: 1.0.2](https://img.shields.io/badge/Version-1.0.2-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0.2](https://img.shields.io/badge/AppVersion-1.0.2-informational?style=flat-square)

Foundational base cluster setup — Cilium CNI, FluxCD, Traefik ingress,
cert-manager, ExternalDNS, and an internal Librespeed speedtest endpoint.
Successor to the base-cluster chart.

**Homepage:** <https://4allportal.com>

## Scope

This chart bootstraps the **foundation** of a Kubernetes cluster:

- **FluxCD** — the GitOps engine. Deployed by this chart only when
  `flux.install=true`; the default assumes Flux was already installed via
  `flux bootstrap`.
- **Traefik** — the cluster's primary ingress controller.
- **cert-manager** — issues TLS certificates from Let's Encrypt via the
  Cloudflare DNS01 solver. CRDs ship in `crds/` so first-install ordering is
  predictable.
- **ExternalDNS** — publishes DNS records for ingresses to Cloudflare.
- **Librespeed speedtest** — an internal endpoint at
  `https://speedtest.<cluster>.<domain>` that doubles as a connectivity smoke
  test.

**Out of scope** — monitoring, backups, RBAC scaffolding, descheduler,
sealedsecrets, security scanning. These will land in separate charts/stories.

## Versions

Component upstream versions are pinned exactly in
`templates/_versions.tpl`. Bumping any component is an explicit edit to that
file plus a chart version bump.

## Network policies

`global.networkPolicy.type` defaults to `auto`: the chart emits
CiliumNetworkPolicy objects when the `cilium.io/v2` API is present, otherwise
nothing. On Talos pre-Cilium, set this to `none` if you'd rather not pre-stage
the policies (they are inert without Cilium).

## Successor to `base-cluster`

This is a clean v1 of a chart that succeeds the older `base-cluster` chart.
The older chart remains in this repo for clusters that haven't migrated.

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| jpkraemer-mg | <j.kraemer@4allportal.com> |  |
| Dominic-Beer | <d.beer@4allportal.com> |  |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| certManager.caInjector.resources.limits.cpu | string | `"500m"` |  |
| certManager.caInjector.resources.limits.memory | string | `"512Mi"` |  |
| certManager.caInjector.resources.requests.cpu | string | `"250m"` |  |
| certManager.caInjector.resources.requests.memory | string | `"512Mi"` |  |
| certManager.resources.limits.cpu | string | `"500m"` |  |
| certManager.resources.limits.memory | string | `"512Mi"` |  |
| certManager.resources.requests.cpu | string | `"250m"` |  |
| certManager.resources.requests.memory | string | `"512Mi"` |  |
| certManager.webhook.resources.limits.cpu | string | `"1"` |  |
| certManager.webhook.resources.limits.memory | string | `"512Mi"` |  |
| certManager.webhook.resources.requests.cpu | string | `"250m"` |  |
| certManager.webhook.resources.requests.memory | string | `"512Mi"` |  |
| cilium.bgpControlPlane.enabled | bool | `false` |  |
| cilium.bpfMasquerade | bool | `false` |  |
| cilium.cgroup.autoMount | bool | `true` |  |
| cilium.cgroup.hostRoot | string | `"/sys/fs/cgroup"` |  |
| cilium.devices | string | `""` |  |
| cilium.encryption.enabled | bool | `true` |  |
| cilium.hubble.enabled | bool | `true` |  |
| cilium.hubble.relay.enabled | bool | `true` |  |
| cilium.hubble.ui.enabled | bool | `true` |  |
| cilium.install | bool | `true` |  |
| cilium.k8sServiceHost | string | `""` |  |
| cilium.k8sServicePort | int | `6443` |  |
| cilium.kubeProxyReplacement | bool | `true` |  |
| cilium.mtu | int | `1450` |  |
| cilium.operator.replicas | int | `2` |  |
| cilium.podCIDR | string | `"10.244.0.0/16"` |  |
| cilium.podCIDRMaskSize | int | `24` |  |
| cilium.routingMode | string | `"tunnel"` |  |
| cilium.tunnelProtocol | string | `"vxlan"` |  |
| dns.domains | list | `[]` |  |
| dns.email | string | `""` |  |
| dns.existingSecret | string | `""` |  |
| externalDNS.resources.limits.cpu | string | `"200m"` |  |
| externalDNS.resources.limits.memory | string | `"128Mi"` |  |
| externalDNS.resources.requests.cpu | string | `"50m"` |  |
| externalDNS.resources.requests.memory | string | `"64Mi"` |  |
| flux.install | bool | `false` |  |
| flux.resources.limits.cpu | string | `"500m"` |  |
| flux.resources.limits.memory | string | `"512Mi"` |  |
| flux.resources.requests.cpu | string | `"100m"` |  |
| flux.resources.requests.memory | string | `"128Mi"` |  |
| git.instances | object | `{}` |  |
| global.baseDomain | string | `""` |  |
| global.certificates | object | `{}` |  |
| global.clusterName | string | `""` |  |
| global.imagePullSecretName | string | `""` |  |
| global.imageRegistry | string | `""` |  |
| global.networkPolicy.defaultDeny.enabled | bool | `true` |  |
| global.networkPolicy.defaultDeny.excludedNamespaces[0] | string | `"kube-system"` |  |
| global.networkPolicy.defaultDeny.excludedNamespaces[1] | string | `"rook-ceph"` |  |
| global.networkPolicy.dnsLabels."io.kubernetes.pod.namespace" | string | `"kube-system"` |  |
| global.networkPolicy.dnsLabels.k8s-app | string | `"kube-dns"` |  |
| global.networkPolicy.type | string | `"auto"` |  |
| reflector.resources.limits.cpu | string | `"200m"` |  |
| reflector.resources.limits.memory | string | `"128Mi"` |  |
| reflector.resources.requests.cpu | string | `"50m"` |  |
| reflector.resources.requests.memory | string | `"64Mi"` |  |
| sealedSecrets.enabled | bool | `true` |  |
| sealedSecrets.resources.limits.cpu | string | `"250m"` |  |
| sealedSecrets.resources.limits.memory | string | `"256Mi"` |  |
| sealedSecrets.resources.requests.cpu | string | `"50m"` |  |
| sealedSecrets.resources.requests.memory | string | `"64Mi"` |  |
| sealedSecrets.values | object | `{}` |  |
| speedtest.enabled | bool | `true` |  |
| speedtest.host | string | `"speedtest"` |  |
| speedtest.image.digest | string | `"sha256:871ec7a1c908e7c9288e51e074b321088a297c37fc672a4c882b0309f61ddef7"` |  |
| speedtest.image.registry | string | `"ghcr.io"` |  |
| speedtest.image.repository | string | `"librespeed/speedtest"` |  |
| speedtest.image.tag | string | `"6.0.2"` |  |
| speedtest.replicas | int | `2` |  |
| speedtest.resources.limits.cpu | string | `"200m"` |  |
| speedtest.resources.limits.memory | string | `"128Mi"` |  |
| speedtest.resources.requests.cpu | string | `"50m"` |  |
| speedtest.resources.requests.memory | string | `"64Mi"` |  |
| traefik.additionalArguments | list | `[]` |  |
| traefik.cipherSuites | list | `[]` |  |
| traefik.ingressIP | string | `""` |  |
| traefik.log.level | string | `"WARN"` |  |
| traefik.maxReplicas | int | `8` |  |
| traefik.minReplicas | int | `2` |  |
| traefik.resources.limits.cpu | string | `"4"` |  |
| traefik.resources.limits.memory | string | `"500Mi"` |  |
| traefik.resources.requests.cpu | string | `"1"` |  |
| traefik.resources.requests.memory | string | `"250Mi"` |  |
| traefik.service.externalIPs | list | `[]` |  |
| traefik.service.loadBalancerIP | string | `""` |  |
| traefik.service.type | string | `"LoadBalancer"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.8.1](https://github.com/norwoodj/helm-docs/releases/v1.8.1)
