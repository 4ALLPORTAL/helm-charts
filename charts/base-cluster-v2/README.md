# base-cluster-v2

![Version: 2.0.6](https://img.shields.io/badge/Version-2.0.6-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.36.4](https://img.shields.io/badge/AppVersion-1.36.4-informational?style=flat-square)

Foundational base cluster setup — FluxCD, Traefik ingress,
cert-manager, ExternalDNS, an internal Librespeed speedtest endpoint, and a
full LGTM observability stack (Grafana, Loki, Mimir, Tempo, and Alloy-based
metrics/log/trace collection). Successor to the base-cluster chart.

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
- **Janitor** — [k8s-cleaner](https://github.com/gianlucam76/k8s-cleaner), a
  CRD-driven controller that deletes stale resources on a schedule: completed
  Jobs and failed or evicted Pods by default, plus succeeded Pods via
  `janitor.cleaners.succeededPods` (off, because the owning controller normally
  reaps those). Rules are `Cleaner` CRs generated from `janitor.cleaners.*`;
  `janitor.excludedNamespaces` keeps them off system namespaces
  (`janitor.enabled`). Each rule only acts once a resource has been terminal for
  `minAgeHours` (default 24), so recent failures stay around long enough to
  debug. Cron schedules are evaluated in UTC.

  Before enabling a rule on a new cluster, set
  `janitor.cleaners.<rule>.dryRun: true` — the flag is per rule, there is no
  chart-wide switch. It renders that Cleaner with `action: Scan`, which matches
  and reports without deleting:

  ```console
  kubectl get reports.apps.projectsveltos.io
  kubectl get reports.apps.projectsveltos.io <cleaner-name> -o yaml   # matched resources
  ```

  Reports come from the `CleanerReport` notification that `janitor.report.enabled`
  attaches to every rule; without it the controller records matches only in its
  own log. A Report is a snapshot of the *last* run, not a log: it appears after
  the rule's first run and is overwritten on every subsequent one, so
  `resourceInfo: []` means "the last run matched nothing" — not "nothing was ever
  cleaned". No Report at all means the rule has not run yet (confirm with
  `.status.lastRunTime` on the Cleaner); use the controller log for history.
- **descheduler** — kubernetes-sigs descheduler as a CronJob for pod
  rebalancing. Off by default (it evicts running pods); enable per cluster via
  `descheduler.enabled`.
- **Observability stack** — grafana/k8s-monitoring (Alloy Operator, split
  into a clustered `alloy-metrics` collector and a node-local `alloy-logs`
  DaemonSet) → Mimir/Loki/Tempo backends + Grafana UI + OTEL Collector for
  traces; Mimir-internal Alertmanager pings an UptimeRobot heartbeat.
  IngressMonitorController auto-creates UptimeRobot monitors from
  `EndpointMonitor` CRs. Opt-in via `monitoring.enabled`; each sub-component
  has its own toggle.

**Out of scope** — backups, RBAC scaffolding, security scanning.
These will land in separate charts/stories.

## Versions

Component upstream versions are pinned exactly in
`templates/_versions.tpl`. Bumping any component is an explicit edit to that
file plus a chart version bump.

## Certificates

The cluster's own wildcard (`*.<clusterName>.<baseDomain>`) is issued into the
`traefik` namespace and used by ingresses that bring no certificate of their own.

`global.certificates` issues additional ones into the release namespace, keyed by
name, with the Secret named `<key>-certificate`:

```yaml
global:
  certificates:
    example-com-wildcard:
      dnsNames:
        - example.com
        - "*.example.com"
```

A Secret is only usable from the namespace it lives in, so a wildcard meant for
workloads elsewhere has to be mirrored. `secretTemplate` is handed to
cert-manager, which stamps its annotations and labels onto the issued Secret and
keeps them across renewals — which is what makes kubernetes-reflector pick it up.
Annotating the Secret by hand works until the first renewal quietly drops the
annotations and the mirrored copies stop being updated:

```yaml
      secretTemplate:
        annotations:
          reflector.v1.k8s.emberstack.com/reflection-allowed: "true"
          reflector.v1.k8s.emberstack.com/reflection-allowed-namespaces: "app-.*"
          reflector.v1.k8s.emberstack.com/reflection-auto-enabled: "true"
          reflector.v1.k8s.emberstack.com/reflection-auto-namespaces: "app-.*"
```

Name the target namespaces. A TLS Secret carries the private key, so leaving the
namespace annotations off — which mirrors into every namespace, including
`kube-system` — hands the wildcard's key to anyone who can read Secrets anywhere
in the cluster.

The namespace fields take a comma-separated list *or* a regular expression, so a
pattern covers namespaces that do not exist yet and needs no upkeep as they are
added. Reflector matches on the namespace name only; it does not read labels or
annotations on the namespace itself.

Note that a wildcard certificate matches exactly one label: `a.example.com` is
covered, `a.b.example.com` is not.

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
| C-schwarz-4ap | <c.schwarz@4allportal.com> |  |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| backup.enabled | bool | `false` |  |
| backup.licenseSecretName | string | `""` |  |
| backup.retryBackup.image.registry | string | `""` |  |
| backup.retryBackup.image.repository | string | `"alpine/k8s"` |  |
| backup.retryBackup.image.tag | string | `"1.36.2"` |  |
| backup.retryBackup.resources.limits.cpu | string | `"100m"` |  |
| backup.retryBackup.resources.limits.memory | string | `"64Mi"` |  |
| backup.retryBackup.resources.requests.cpu | string | `"10m"` |  |
| backup.retryBackup.resources.requests.memory | string | `"32Mi"` |  |
| backup.retryBackup.schedule | string | `"30 0-8 * * *"` |  |
| backup.values | object | `{}` |  |
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
| descheduler.enabled | bool | `false` |  |
| descheduler.image.registry | string | `""` |  |
| descheduler.image.tag | string | `""` |  |
| descheduler.profiles[0].name | string | `"default"` |  |
| descheduler.profiles[0].pluginConfig[0].args.evictLocalStoragePods | bool | `true` |  |
| descheduler.profiles[0].pluginConfig[0].args.ignorePvcPods | bool | `true` |  |
| descheduler.profiles[0].pluginConfig[0].name | string | `"DefaultEvictor"` |  |
| descheduler.profiles[0].pluginConfig[1].name | string | `"RemoveDuplicates"` |  |
| descheduler.profiles[0].pluginConfig[2].args.includingInitContainers | bool | `true` |  |
| descheduler.profiles[0].pluginConfig[2].args.podRestartThreshold | int | `10` |  |
| descheduler.profiles[0].pluginConfig[2].name | string | `"RemovePodsHavingTooManyRestarts"` |  |
| descheduler.profiles[0].pluginConfig[3].args.nodeAffinityType[0] | string | `"requiredDuringSchedulingIgnoredDuringExecution"` |  |
| descheduler.profiles[0].pluginConfig[3].name | string | `"RemovePodsViolatingNodeAffinity"` |  |
| descheduler.profiles[0].pluginConfig[4].name | string | `"RemovePodsViolatingNodeTaints"` |  |
| descheduler.profiles[0].pluginConfig[5].name | string | `"RemovePodsViolatingInterPodAntiAffinity"` |  |
| descheduler.profiles[0].pluginConfig[6].name | string | `"RemovePodsViolatingTopologySpreadConstraint"` |  |
| descheduler.profiles[0].pluginConfig[7].args.targetThresholds.cpu | int | `70` |  |
| descheduler.profiles[0].pluginConfig[7].args.targetThresholds.memory | int | `80` |  |
| descheduler.profiles[0].pluginConfig[7].args.targetThresholds.pods | int | `95` |  |
| descheduler.profiles[0].pluginConfig[7].args.thresholds.cpu | int | `50` |  |
| descheduler.profiles[0].pluginConfig[7].args.thresholds.memory | int | `50` |  |
| descheduler.profiles[0].pluginConfig[7].args.thresholds.pods | int | `50` |  |
| descheduler.profiles[0].pluginConfig[7].name | string | `"LowNodeUtilization"` |  |
| descheduler.profiles[0].plugins.balance.enabled[0] | string | `"RemoveDuplicates"` |  |
| descheduler.profiles[0].plugins.balance.enabled[1] | string | `"RemovePodsViolatingTopologySpreadConstraint"` |  |
| descheduler.profiles[0].plugins.balance.enabled[2] | string | `"LowNodeUtilization"` |  |
| descheduler.profiles[0].plugins.deschedule.enabled[0] | string | `"RemovePodsHavingTooManyRestarts"` |  |
| descheduler.profiles[0].plugins.deschedule.enabled[1] | string | `"RemovePodsViolatingNodeTaints"` |  |
| descheduler.profiles[0].plugins.deschedule.enabled[2] | string | `"RemovePodsViolatingNodeAffinity"` |  |
| descheduler.profiles[0].plugins.deschedule.enabled[3] | string | `"RemovePodsViolatingInterPodAntiAffinity"` |  |
| descheduler.resources.limits.cpu | string | `"200m"` |  |
| descheduler.resources.limits.memory | string | `"128Mi"` |  |
| descheduler.resources.requests.cpu | string | `"50m"` |  |
| descheduler.resources.requests.memory | string | `"64Mi"` |  |
| descheduler.schedule | string | `"*/15 * * * *"` |  |
| descheduler.values | object | `{}` |  |
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
| janitor.cleaners.completedJobs.dryRun | bool | `false` |  |
| janitor.cleaners.completedJobs.enabled | bool | `true` |  |
| janitor.cleaners.completedJobs.minAgeHours | int | `24` |  |
| janitor.cleaners.completedJobs.schedule | string | `"0 2 * * *"` |  |
| janitor.cleaners.completedJobs.skipOwned | bool | `true` |  |
| janitor.cleaners.failedPods.dryRun | bool | `false` |  |
| janitor.cleaners.failedPods.enabled | bool | `true` |  |
| janitor.cleaners.failedPods.minAgeHours | int | `24` |  |
| janitor.cleaners.failedPods.schedule | string | `"*/30 * * * *"` |  |
| janitor.cleaners.succeededPods.dryRun | bool | `false` |  |
| janitor.cleaners.succeededPods.enabled | bool | `false` |  |
| janitor.cleaners.succeededPods.minAgeHours | int | `24` |  |
| janitor.cleaners.succeededPods.schedule | string | `"*/30 * * * *"` |  |
| janitor.deleteOptions.propagationPolicy | string | `"Background"` |  |
| janitor.enabled | bool | `true` |  |
| janitor.excludedNamespaces[0] | string | `"kube-system"` |  |
| janitor.excludedNamespaces[1] | string | `"flux-system"` |  |
| janitor.image.registry | string | `""` |  |
| janitor.image.repository | string | `"projectsveltos/k8s-cleaner"` |  |
| janitor.image.tag | string | `"v0.23.0"` |  |
| janitor.report.enabled | bool | `true` |  |
| janitor.resources.limits.cpu | string | `"500m"` |  |
| janitor.resources.limits.memory | string | `"256Mi"` |  |
| janitor.resources.requests.cpu | string | `"50m"` |  |
| janitor.resources.requests.memory | string | `"128Mi"` |  |
| janitor.values | object | `{}` |  |
| metricsServer.enabled | bool | `true` |  |
| metricsServer.kubeletInsecureTLS | bool | `true` |  |
| metricsServer.resources.limits.cpu | string | `"200m"` |  |
| metricsServer.resources.limits.memory | string | `"256Mi"` |  |
| metricsServer.resources.requests.cpu | string | `"50m"` |  |
| metricsServer.resources.requests.memory | string | `"64Mi"` |  |
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
| monitoring.k8sMonitoring.resources.limits.cpu | string | `"1"` |  |
| monitoring.k8sMonitoring.resources.limits.memory | string | `"1Gi"` |  |
| monitoring.k8sMonitoring.resources.requests.cpu | string | `"100m"` |  |
| monitoring.k8sMonitoring.resources.requests.memory | string | `"256Mi"` |  |
| monitoring.kubeStateMetrics.enabled | bool | `true` |  |
| monitoring.loki.enabled | bool | `true` |  |
| monitoring.loki.resources.limits.cpu | string | `"1"` |  |
| monitoring.loki.resources.limits.memory | string | `"2Gi"` |  |
| monitoring.loki.resources.requests.cpu | string | `"250m"` |  |
| monitoring.loki.resources.requests.memory | string | `"512Mi"` |  |
| monitoring.loki.retention | string | `"336h"` |  |
| monitoring.loki.size | string | `"50Gi"` |  |
| monitoring.mimir.alertmanagerConfigSecret | string | `""` |  |
| monitoring.mimir.alertmanagerEgressFQDNs | list | `[]` |  |
| monitoring.mimir.enabled | bool | `true` |  |
| monitoring.mimir.extraRuleGroups | object | `{}` |  |
| monitoring.mimir.kafkaSize | string | `"20Gi"` |  |
| monitoring.mimir.resources.limits.cpu | string | `"2"` |  |
| monitoring.mimir.resources.limits.memory | string | `"4Gi"` |  |
| monitoring.mimir.resources.requests.cpu | string | `"500m"` |  |
| monitoring.mimir.resources.requests.memory | string | `"1Gi"` |  |
| monitoring.mimir.retention | string | `"720h"` |  |
| monitoring.mimir.size | string | `"50Gi"` |  |
| monitoring.nodeExporter.enabled | bool | `true` |  |
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
| monitoring.uptimeRobot.reconciler.image.tag | string | `"3.14"` |  |
| monitoring.uptimeRobot.reconciler.resources.limits.cpu | string | `"200m"` |  |
| monitoring.uptimeRobot.reconciler.resources.limits.memory | string | `"128Mi"` |  |
| monitoring.uptimeRobot.reconciler.resources.requests.cpu | string | `"50m"` |  |
| monitoring.uptimeRobot.reconciler.resources.requests.memory | string | `"64Mi"` |  |
| monitoring.uptimeRobot.reconciler.schedule | string | `"*/15 * * * *"` |  |
| reflector.enabled | bool | `true` |  |
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
| speedtest.image.tag | string | `"6.2.1"` |  |
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
