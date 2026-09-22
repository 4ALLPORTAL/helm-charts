# base-cluster-v2

![Version: 2.4.0](https://img.shields.io/badge/Version-2.4.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.36.4](https://img.shields.io/badge/AppVersion-1.36.4-informational?style=flat-square)

Foundational base cluster setup — FluxCD, Traefik ingress,
cert-manager, ExternalDNS, an internal Librespeed speedtest endpoint, and a
full LGTM observability stack (Grafana, Loki, Mimir, Tempo, and Alloy-based
metrics/log/trace collection), and a least-privilege RBAC baseline.
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
- **RBAC baseline** — least-privilege ClusterRoles for platform staff and for
  tenant namespaces, bound to your identity provider's groups from values
  (`rbac.enabled`). See [RBAC](#rbac).

**Out of scope** — security scanning, and the authentication half of access
control: this chart decides what a group may do, not how a person becomes a
member of one. Wiring kube-apiserver to the identity provider is its own story.

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

## RBAC

Five roles, bound to nobody until you say so. Installing or upgrading the chart
with the defaults adds the role definitions and changes no one's access — every
subject list under `rbac` ships empty.

| Role | Kind | Grants |
| --- | --- | --- |
| `cluster-admin` (built-in) | ClusterRoleBinding | everything. Bound only from `rbac.cluster.admin`, which is empty by default |
| `base-cluster:cluster-reader` | ClusterRoleBinding | read-only cluster-wide, **no Secrets** |
| `base-cluster:cluster-operator` | ClusterRoleBinding | the reader rules, plus restart/scale workloads, evict pods, cordon nodes, `flux reconcile`/`suspend` |
| `base-cluster:tenant-admin` | RoleBinding per namespace | the namespace, including its Secrets, ServiceAccounts and RoleBindings |
| `base-cluster:tenant-developer` | RoleBinding per namespace | the namespace's workloads, exec and port-forward — **no Secrets** |
| `base-cluster:tenant-viewer` | RoleBinding per namespace | read-only in the namespace, **no Secrets** |

The tenant roles are ClusterRoles bound with a RoleBinding, the same way the
built-in `admin`/`edit`/`view` work: one definition, confined to a namespace by
the binding. A Role per tenant would be N copies drifting apart.

### What the tiers deliberately cannot do

RBAC has no deny rule, so a permission is excluded by never being granted. The
exclusions below are the ones that would otherwise turn a tier into
cluster-admin by a side door, and they are why the core (`""`) API group is
enumerated resource by resource in the templates while every other group is
covered by `rbac.readableApiGroups`:

- **Secrets** are absent from every tier but `tenant-admin`. Adding `""` to
  `rbac.readableApiGroups` would hand out every Secret in the cluster; extend
  the enumerated core rule instead.

  For the two cluster tiers and `tenant-viewer` that exclusion is absolute.
  For `tenant-developer` it is not, and no RBAC rule can make it so: anyone who
  can create a workload in a namespace can mount that namespace's Secrets into
  a pod and read them from there. What the tier does buy is that `kubectl get
  secret` fails, a Secret cannot be read or modified by accident, and the
  roundabout route leaves a Pod spec behind in the audit log. Where a
  credential must be unreachable, put it in a namespace whose developers are
  not bound — the namespace is the boundary, the tier is not.
- **`escalate`, `bind` and `impersonate`** appear nowhere. `tenant-admin` can
  create RoleBindings, but the RBAC authorizer refuses a binding that grants
  more than the binder already holds — so it can delegate its own permissions
  and no more.
- **NetworkPolicies and CiliumNetworkPolicies** are read-only in all five
  tiers. A tenant that can widen its own ingress rules is not isolated, and the
  cluster's default-deny posture depends on those objects.
- **`pods/exec` and `pods/portforward` are off cluster-wide**
  (`rbac.cluster.operator.allowExec`, `.allowPortForward`, both `false`). A
  shell in any pod reads every Secret mounted anywhere. Inside a tenant
  namespace both are on, where the blast radius is the tenant's own.
- **CRDs, admission webhooks, ResourceQuotas and LimitRanges** stay with the
  platform team in every tier.

### Binding groups

```yaml
rbac:
  cluster:
    operator:
      groups: ["8f1c1d2e-...-...."]      # platform on-call
    reader:
      groups: ["2b90ffac-...-...."]      # everyone else
  tenants:
    team-a:
      admin:
        groups: ["c07a41b9-...-...."]
      developer:
        users: ["j.doe@example.com"]
```

Entra ID puts group *object IDs* in the token, not display names, so on
Entra-backed clusters these values are GUIDs. Until kube-apiserver is wired to
the identity provider there are no group claims to match: list `users` (the
`username` claim, or a client-certificate CN) or `serviceAccounts` instead —
the shape is identical, so switching over later is an edit to one list.

The tenant namespaces must already exist; the chart binds into them, it does
not create them. A RoleBinding naming a missing namespace fails the release,
which beats rendering a binding that silently protects nothing.

Leaving `rbac.cluster.admin` empty locks nobody out. The Talos/kubeadm admin
kubeconfig authenticates as `system:masters`, which the authorizer honours
ahead of RBAC — that stays the break-glass path.

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
| backup.retryBackup.image.tag | string | `"1.37.0"` |  |
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
| global.networkPolicy.metallbMetricsPorts[0] | string | `"9120"` |  |
| global.networkPolicy.metallbMetricsPorts[1] | string | `"9121"` |  |
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
| rbac.cluster.admin.groups | list | `[]` |  |
| rbac.cluster.admin.serviceAccounts | list | `[]` |  |
| rbac.cluster.admin.users | list | `[]` |  |
| rbac.cluster.operator.allowExec | bool | `false` |  |
| rbac.cluster.operator.allowPortForward | bool | `false` |  |
| rbac.cluster.operator.groups | list | `[]` |  |
| rbac.cluster.operator.serviceAccounts | list | `[]` |  |
| rbac.cluster.operator.users | list | `[]` |  |
| rbac.cluster.reader.groups | list | `[]` |  |
| rbac.cluster.reader.serviceAccounts | list | `[]` |  |
| rbac.cluster.reader.users | list | `[]` |  |
| rbac.createRoles | bool | `true` |  |
| rbac.enabled | bool | `true` |  |
| rbac.extraRules.clusterOperator | list | `[]` |  |
| rbac.extraRules.clusterReader | list | `[]` |  |
| rbac.extraRules.tenantAdmin | list | `[]` |  |
| rbac.extraRules.tenantDeveloper | list | `[]` |  |
| rbac.extraRules.tenantViewer | list | `[]` |  |
| rbac.readableApiGroups[0] | string | `"admissionregistration.k8s.io"` |  |
| rbac.readableApiGroups[10] | string | `"certificates.k8s.io"` |  |
| rbac.readableApiGroups[11] | string | `"cilium.io"` |  |
| rbac.readableApiGroups[12] | string | `"coordination.k8s.io"` |  |
| rbac.readableApiGroups[13] | string | `"discovery.k8s.io"` |  |
| rbac.readableApiGroups[14] | string | `"events.k8s.io"` |  |
| rbac.readableApiGroups[15] | string | `"helm.toolkit.fluxcd.io"` |  |
| rbac.readableApiGroups[16] | string | `"image.toolkit.fluxcd.io"` |  |
| rbac.readableApiGroups[17] | string | `"kubevirt.io"` |  |
| rbac.readableApiGroups[18] | string | `"kustomize.toolkit.fluxcd.io"` |  |
| rbac.readableApiGroups[19] | string | `"metrics.k8s.io"` |  |
| rbac.readableApiGroups[1] | string | `"apiextensions.k8s.io"` |  |
| rbac.readableApiGroups[20] | string | `"monitoring.coreos.com"` |  |
| rbac.readableApiGroups[21] | string | `"mysql.oracle.com"` |  |
| rbac.readableApiGroups[22] | string | `"networking.k8s.io"` |  |
| rbac.readableApiGroups[23] | string | `"node.k8s.io"` |  |
| rbac.readableApiGroups[24] | string | `"notification.toolkit.fluxcd.io"` |  |
| rbac.readableApiGroups[25] | string | `"objectbucket.io"` |  |
| rbac.readableApiGroups[26] | string | `"policy"` |  |
| rbac.readableApiGroups[27] | string | `"rbac.authorization.k8s.io"` |  |
| rbac.readableApiGroups[28] | string | `"scheduling.k8s.io"` |  |
| rbac.readableApiGroups[29] | string | `"snapshot.storage.k8s.io"` |  |
| rbac.readableApiGroups[2] | string | `"apiregistration.k8s.io"` |  |
| rbac.readableApiGroups[30] | string | `"source.toolkit.fluxcd.io"` |  |
| rbac.readableApiGroups[31] | string | `"stash.appscode.com"` |  |
| rbac.readableApiGroups[32] | string | `"storage.k8s.io"` |  |
| rbac.readableApiGroups[3] | string | `"apps"` |  |
| rbac.readableApiGroups[4] | string | `"autoscaling"` |  |
| rbac.readableApiGroups[5] | string | `"batch"` |  |
| rbac.readableApiGroups[6] | string | `"bitnami.com"` |  |
| rbac.readableApiGroups[7] | string | `"cdi.kubevirt.io"` |  |
| rbac.readableApiGroups[8] | string | `"ceph.rook.io"` |  |
| rbac.readableApiGroups[9] | string | `"cert-manager.io"` |  |
| rbac.serviceAccounts | list | `[]` |  |
| rbac.tenant.admin.allowExec | bool | `true` |  |
| rbac.tenant.admin.allowPortForward | bool | `true` |  |
| rbac.tenant.developer.allowExec | bool | `true` |  |
| rbac.tenant.developer.allowIngress | bool | `true` |  |
| rbac.tenant.developer.allowPortForward | bool | `true` |  |
| rbac.tenants | object | `{}` |  |
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
| speedtest.image.tag | string | `"6.3.0"` |  |
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
| traefik.resources.limits.memory | string | `"2Gi"` |  |
| traefik.resources.requests.cpu | string | `"1"` |  |
| traefik.resources.requests.memory | string | `"250Mi"` |  |
| traefik.service.annotations | object | `{}` |  |
| traefik.service.externalIPs | list | `[]` |  |
| traefik.service.loadBalancerIP | string | `""` |  |
| traefik.service.spec | object | `{}` |  |
| traefik.service.type | string | `"LoadBalancer"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.8.1](https://github.com/norwoodj/helm-docs/releases/v1.8.1)
