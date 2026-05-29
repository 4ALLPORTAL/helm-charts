# base-cluster-v2

![Version: 1.4.0](https://img.shields.io/badge/Version-1.4.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.4.0](https://img.shields.io/badge/AppVersion-1.4.0-informational?style=flat-square)

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
- **Sealed Secrets** — Bitnami controller for storing encrypted secrets in
  Git (`sealedSecrets.enabled`).
- **Reflector** — mirrors source Secrets/ConfigMaps into other namespaces
  via annotations (`reflector.enabled`).
- **metrics-server** — exposes `metrics.k8s.io` for `kubectl top` and HPAs
  (`metricsServer.enabled`).
- **Observability stack** — Grafana Alloy (collector) → Mimir/Loki/Tempo
  backends + Grafana UI + OTEL Collector for traces; Mimir-internal
  Alertmanager pings an UptimeRobot heartbeat. IngressMonitorController
  auto-creates UptimeRobot monitors from `EndpointMonitor` CRs. Opt-in via
  `monitoring.enabled`; each sub-component has its own toggle.

**Out of scope** — backups, RBAC scaffolding, descheduler, security scanning.
These will land in separate charts/stories.

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
| Christopher Schwarz | <c.schwarz@4allportal.com> |  |

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
| global.clusterDomain | string | `"cluster.local"` |  |
| global.clusterName | string | `""` |  |
| global.imagePullSecretName | string | `""` |  |
| global.imageRegistry | string | `""` |  |
| global.networkPolicy.defaultDeny.enabled | bool | `true` |  |
| global.networkPolicy.defaultDeny.excludedNamespaces[0] | string | `"kube-system"` |  |
| global.networkPolicy.defaultDeny.excludedNamespaces[1] | string | `"rook-ceph"` |  |
| global.networkPolicy.dnsLabels."io.kubernetes.pod.namespace" | string | `"kube-system"` |  |
| global.networkPolicy.dnsLabels.k8s-app | string | `"kube-dns"` |  |
| global.networkPolicy.type | string | `"auto"` |  |
| metricsServer.enabled | bool | `true` |  |
| metricsServer.kubeletInsecureTLS | bool | `true` |  |
| metricsServer.resources.limits.cpu | string | `"200m"` |  |
| metricsServer.resources.limits.memory | string | `"256Mi"` |  |
| metricsServer.resources.requests.cpu | string | `"50m"` |  |
| metricsServer.resources.requests.memory | string | `"64Mi"` |  |
| monitoring.alloy.enabled | bool | `true` |  |
| monitoring.alloy.resources.limits.cpu | string | `"1"` |  |
| monitoring.alloy.resources.limits.memory | string | `"1Gi"` |  |
| monitoring.alloy.resources.requests.cpu | string | `"100m"` |  |
| monitoring.alloy.resources.requests.memory | string | `"256Mi"` |  |
| monitoring.enabled | bool | `false` |  |
| monitoring.grafana.enabled | bool | `true` |  |
| monitoring.grafana.existingAdminSecret | string | `""` |  |
| monitoring.grafana.host | string | `"grafana"` |  |
| monitoring.grafana.oidc.allowSignUp | bool | `true` |  |
| monitoring.grafana.oidc.allowedDomains | string | `""` |  |
| monitoring.grafana.oidc.apiUrl | string | `""` |  |
| monitoring.grafana.oidc.authUrl | string | `""` |  |
| monitoring.grafana.oidc.autoLogin | bool | `false` |  |
| monitoring.grafana.oidc.clientAuthentication | string | `""` |  |
| monitoring.grafana.oidc.clientId | string | `""` |  |
| monitoring.grafana.oidc.disableLoginForm | bool | `false` |  |
| monitoring.grafana.oidc.enabled | bool | `false` |  |
| monitoring.grafana.oidc.existingSecret | string | `""` |  |
| monitoring.grafana.oidc.name | string | `"SSO"` |  |
| monitoring.grafana.oidc.oauthAllowInsecureEmailLookup | bool | `false` |  |
| monitoring.grafana.oidc.roleAttributePath | string | `""` |  |
| monitoring.grafana.oidc.scopes | string | `"openid profile email"` |  |
| monitoring.grafana.oidc.tokenUrl | string | `""` |  |
| monitoring.grafana.resources.limits.cpu | string | `"500m"` |  |
| monitoring.grafana.resources.limits.memory | string | `"512Mi"` |  |
| monitoring.grafana.resources.requests.cpu | string | `"100m"` |  |
| monitoring.grafana.resources.requests.memory | string | `"256Mi"` |  |
| monitoring.ingressMonitor.enabled | bool | `false` |  |
| monitoring.ingressMonitor.existingConfigSecret | string | `""` |  |
| monitoring.ingressMonitor.image.registry | string | `""` |  |
| monitoring.ingressMonitor.resources.limits.cpu | string | `"200m"` |  |
| monitoring.ingressMonitor.resources.limits.memory | string | `"128Mi"` |  |
| monitoring.ingressMonitor.resources.requests.cpu | string | `"25m"` |  |
| monitoring.ingressMonitor.resources.requests.memory | string | `"64Mi"` |  |
| monitoring.kubeStateMetrics.enabled | bool | `true` |  |
| monitoring.kubeStateMetrics.resources.limits.cpu | string | `"200m"` |  |
| monitoring.kubeStateMetrics.resources.limits.memory | string | `"256Mi"` |  |
| monitoring.kubeStateMetrics.resources.requests.cpu | string | `"50m"` |  |
| monitoring.kubeStateMetrics.resources.requests.memory | string | `"64Mi"` |  |
| monitoring.loki.enabled | bool | `true` |  |
| monitoring.loki.resources.limits.cpu | string | `"1"` |  |
| monitoring.loki.resources.limits.memory | string | `"2Gi"` |  |
| monitoring.loki.resources.requests.cpu | string | `"250m"` |  |
| monitoring.loki.resources.requests.memory | string | `"512Mi"` |  |
| monitoring.loki.retention | string | `"336h"` |  |
| monitoring.loki.size | string | `"50Gi"` |  |
| monitoring.mimir.enabled | bool | `true` |  |
| monitoring.mimir.kafkaSize | string | `"20Gi"` |  |
| monitoring.mimir.resources.limits.cpu | string | `"2"` |  |
| monitoring.mimir.resources.limits.memory | string | `"4Gi"` |  |
| monitoring.mimir.resources.requests.cpu | string | `"500m"` |  |
| monitoring.mimir.resources.requests.memory | string | `"1Gi"` |  |
| monitoring.mimir.retention | string | `"720h"` |  |
| monitoring.mimir.size | string | `"50Gi"` |  |
| monitoring.nodeExporter.enabled | bool | `true` |  |
| monitoring.nodeExporter.resources.limits.cpu | string | `"200m"` |  |
| monitoring.nodeExporter.resources.limits.memory | string | `"128Mi"` |  |
| monitoring.nodeExporter.resources.requests.cpu | string | `"50m"` |  |
| monitoring.nodeExporter.resources.requests.memory | string | `"64Mi"` |  |
| monitoring.otelCollector.enabled | bool | `true` |  |
| monitoring.otelCollector.resources.limits.cpu | string | `"500m"` |  |
| monitoring.otelCollector.resources.limits.memory | string | `"512Mi"` |  |
| monitoring.otelCollector.resources.requests.cpu | string | `"100m"` |  |
| monitoring.otelCollector.resources.requests.memory | string | `"128Mi"` |  |
| monitoring.rookCeph.enabled | bool | `false` |  |
| monitoring.rookCeph.namespace | string | `"rook-ceph"` |  |
| monitoring.storageClass | string | `""` |  |
| monitoring.tempo.enabled | bool | `true` |  |
| monitoring.tempo.resources.limits.cpu | string | `"1"` |  |
| monitoring.tempo.resources.limits.memory | string | `"2Gi"` |  |
| monitoring.tempo.resources.requests.cpu | string | `"250m"` |  |
| monitoring.tempo.resources.requests.memory | string | `"512Mi"` |  |
| monitoring.tempo.retention | string | `"168h"` |  |
| monitoring.tempo.size | string | `"20Gi"` |  |
| monitoring.uptimeRobot.enabled | bool | `false` |  |
| monitoring.uptimeRobot.existingSecret | string | `""` |  |
| monitoring.uptimeRobot.heartbeatUrl | string | `""` |  |
| monitoring.uptimeRobot.monitors | list | `[]` |  |
| monitoring.uptimeRobot.reconciler.image.digest | string | `""` |  |
| monitoring.uptimeRobot.reconciler.image.repository | string | `"python"` |  |
| monitoring.uptimeRobot.reconciler.image.tag | string | `"3.13"` |  |
| monitoring.uptimeRobot.reconciler.resources.limits.cpu | string | `"200m"` |  |
| monitoring.uptimeRobot.reconciler.resources.limits.memory | string | `"128Mi"` |  |
| monitoring.uptimeRobot.reconciler.resources.requests.cpu | string | `"50m"` |  |
| monitoring.uptimeRobot.reconciler.resources.requests.memory | string | `"64Mi"` |  |
| monitoring.uptimeRobot.reconciler.schedule | string | `"*/15 * * * *"` |  |
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
