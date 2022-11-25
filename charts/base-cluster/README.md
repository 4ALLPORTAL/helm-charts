# base-cluster

![Version: 34.9.0](https://img.shields.io/badge/Version-34.9.0-informational?style=flat-square)

A generic, base cluster setup

**Homepage:** <https://4allportal.com>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| tasches | <s.tasche@4allportal.net> |  |

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | common | 1.16.1 |

This helm chart requires flux v2 to be installed (https://fluxcd.io/docs/installation)

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| backup.enabled | bool | `false` |  |
| certManager.caInjector.resources.limits.cpu | string | `"250m"` |  |
| certManager.caInjector.resources.limits.memory | string | `"512Mi"` |  |
| certManager.caInjector.resources.requests.cpu | string | `"250m"` |  |
| certManager.caInjector.resources.requests.memory | string | `"512Mi"` |  |
| certManager.resources.limits.cpu | string | `"250m"` |  |
| certManager.resources.limits.memory | string | `"512Mi"` |  |
| certManager.resources.requests.cpu | string | `"250m"` |  |
| certManager.resources.requests.memory | string | `"512Mi"` |  |
| certManager.webhook.resources.limits.cpu | int | `1` |  |
| certManager.webhook.resources.limits.memory | string | `"512Mi"` |  |
| certManager.webhook.resources.requests.cpu | string | `"250m"` |  |
| certManager.webhook.resources.requests.memory | string | `"512Mi"` |  |
| descheduler.enabled | bool | `true` |  |
| descheduler.strategies.LowNodeUtilization.enabled | bool | `true` |  |
| descheduler.strategies.LowNodeUtilization.params.nodeResourceUtilizationThresholds.targetThresholds.cpu | int | `70` |  |
| descheduler.strategies.LowNodeUtilization.params.nodeResourceUtilizationThresholds.targetThresholds.memory | int | `80` |  |
| descheduler.strategies.LowNodeUtilization.params.nodeResourceUtilizationThresholds.targetThresholds.pods | int | `95` |  |
| descheduler.strategies.LowNodeUtilization.params.nodeResourceUtilizationThresholds.thresholds.cpu | int | `50` |  |
| descheduler.strategies.LowNodeUtilization.params.nodeResourceUtilizationThresholds.thresholds.memory | int | `50` |  |
| descheduler.strategies.LowNodeUtilization.params.nodeResourceUtilizationThresholds.thresholds.pods | int | `50` |  |
| descheduler.strategies.RemoveDuplicates.enabled | bool | `true` |  |
| descheduler.strategies.RemovePodsHavingTooManyRestarts.enabled | bool | `true` |  |
| descheduler.strategies.RemovePodsHavingTooManyRestarts.params.podsHavingTooManyRestarts.podRestartThreshold | int | `10` |  |
| descheduler.strategies.RemovePodsViolatingInterPodAntiAffinity.enabled | bool | `true` |  |
| descheduler.strategies.RemovePodsViolatingNodeAffinity.enabled | bool | `true` |  |
| descheduler.strategies.RemovePodsViolatingNodeAffinity.params.nodeAffinityType[0] | string | `"requiredDuringSchedulingIgnoredDuringExecution"` |  |
| descheduler.strategies.RemovePodsViolatingNodeTaints.enabled | bool | `true` |  |
| descheduler.strategies.RemovePodsViolatingTopologySpreadConstraint.enabled | bool | `true` |  |
| descheduler.strategies.RemovePodsViolatingTopologySpreadConstraint.params.includeSoftContraints | bool | `true` |  |
| dns.apiKey | string | `""` |  |
| dns.domains | list | `[]` |  |
| externalDNS.resources.limits.cpu | string | `"50m"` |  |
| externalDNS.resources.limits.memory | string | `"128Mi"` |  |
| externalDNS.resources.requests.cpu | string | `"50m"` |  |
| externalDNS.resources.requests.memory | string | `"64Mi"` |  |
| flux.resources | object | `{}` |  |
| git.instances | object | `{}` |  |
| global.authentication.config.clientId | string | `""` |  |
| global.authentication.config.clientSecret | string | `""` |  |
| global.authentication.config.cookieSecret | string | `""` |  |
| global.authentication.config.emailDomains | list | `[]` |  |
| global.authentication.config.issuerHost | string | `""` |  |
| global.authentication.config.issuerPath | string | `""` |  |
| global.authentication.enabled | bool | `false` |  |
| global.authentication.oauth.resources.limits.cpu | string | `"100m"` |  |
| global.authentication.oauth.resources.limits.memory | string | `"32Mi"` |  |
| global.authentication.oauth.resources.requests.cpu | string | `"10m"` |  |
| global.authentication.oauth.resources.requests.memory | string | `"16Mi"` |  |
| global.baseDomain | string | `"4allportal.com"` |  |
| global.certificates | object | `{}` |  |
| global.clusterName | string | `"eu-west-1"` |  |
| global.helm.image.registry | string | `"docker.io"` |  |
| global.helm.image.repository | string | `"alpine/helm"` |  |
| global.helm.image.tag | string | `"3.10.2"` |  |
| global.imageCredentials | object | `{}` |  |
| global.imageRegistry | string | `""` |  |
| global.kubectl.image.registry | string | `"docker.io"` |  |
| global.kubectl.image.repository | string | `"bitnami/kubectl"` |  |
| global.kubectl.image.tag | string | `"1.24.3"` |  |
| global.networkPolicy.dnsLabels."io.kubernetes.pod.namespace" | string | `"kube-system"` |  |
| global.networkPolicy.dnsLabels.k8s-app | string | `"kube-dns"` |  |
| global.networkPolicy.metricsLabels."app.kubernetes.io/name" | string | `"prometheus"` |  |
| global.networkPolicy.metricsLabels."io.kubernetes.pod.namespace" | string | `"monitoring"` |  |
| global.networkPolicy.type | string | `"auto"` |  |
| global.priorityClasses.classes | object | `{}` |  |
| global.priorityClasses.default | object | `{}` |  |
| global.priorityClasses.defaultClasses.high.preemptionPolicy | string | `"PreemptLowerPriority"` |  |
| global.priorityClasses.defaultClasses.high.value | int | `7000` |  |
| global.priorityClasses.defaultClasses.low.description | string | `"Meant for development / testing workloads"` |  |
| global.priorityClasses.defaultClasses.low.preemptionPolicy | string | `"PreemptLowerPriority"` |  |
| global.priorityClasses.defaultClasses.low.value | int | `3000` |  |
| global.priorityClasses.defaultClasses.normal.preemptionPolicy | string | `"PreemptLowerPriority"` |  |
| global.priorityClasses.defaultClasses.normal.value | int | `5000` |  |
| global.priorityClasses.defaultClasses.very-high.description | string | `"Meant for production workloads"` |  |
| global.priorityClasses.defaultClasses.very-high.preemptionPolicy | string | `"PreemptLowerPriority"` |  |
| global.priorityClasses.defaultClasses.very-high.value | int | `10000` |  |
| janitor.enabled | bool | `true` |  |
| monitoring.costAnalysis.currency | string | `"currencyEUR"` |  |
| monitoring.costAnalysis.storageClassMapping | object | `{}` |  |
| monitoring.deadMansSwitch.apiKey | string | `""` |  |
| monitoring.deadMansSwitch.enabled | bool | `false` |  |
| monitoring.deadMansSwitch.pingKey | string | `""` |  |
| monitoring.goldpinger.enabled | bool | `true` |  |
| monitoring.goldpinger.host | string | `"pinger"` |  |
| monitoring.goldpinger.pingHosts | list | `[]` |  |
| monitoring.goldpinger.resources.limits.cpu | string | `"250m"` |  |
| monitoring.goldpinger.resources.limits.memory | string | `"64Mi"` |  |
| monitoring.goldpinger.resources.requests.cpu | string | `"10m"` |  |
| monitoring.goldpinger.resources.requests.memory | string | `"64Mi"` |  |
| monitoring.grafana.additionalDashboards | object | `{}` |  |
| monitoring.grafana.adminPassword | string | `""` |  |
| monitoring.grafana.config | object | `{}` |  |
| monitoring.grafana.dashboards.fourAllPortal | bool | `true` |  |
| monitoring.grafana.dashboards.mariadb | bool | `true` |  |
| monitoring.grafana.host | string | `"grafana"` |  |
| monitoring.grafana.notifiers | list | `[]` |  |
| monitoring.grafana.resources.limits.cpu | string | `"500m"` |  |
| monitoring.grafana.resources.limits.memory | string | `"256Mi"` |  |
| monitoring.grafana.resources.requests.cpu | string | `"500m"` |  |
| monitoring.grafana.resources.requests.memory | string | `"256Mi"` |  |
| monitoring.grafana.sidecar.resources.limits.cpu | int | `1` |  |
| monitoring.grafana.sidecar.resources.limits.memory | string | `"128Mi"` |  |
| monitoring.grafana.sidecar.resources.requests.cpu | int | `1` |  |
| monitoring.grafana.sidecar.resources.requests.memory | string | `"128Mi"` |  |
| monitoring.ingress.creationDelay | string | `"10m"` |  |
| monitoring.ingress.enableMonitorDeletion | bool | `true` |  |
| monitoring.ingress.enabled | bool | `false` |  |
| monitoring.ingress.providers | list | `[]` |  |
| monitoring.jaeger.agent.resources.limits.cpu | string | `"200m"` |  |
| monitoring.jaeger.agent.resources.limits.memory | string | `"64Mi"` |  |
| monitoring.jaeger.agent.resources.requests.cpu | string | `"100m"` |  |
| monitoring.jaeger.agent.resources.requests.memory | string | `"16Mi"` |  |
| monitoring.jaeger.authentication | object | `{}` |  |
| monitoring.jaeger.collector.resources.limits.cpu | int | `1` |  |
| monitoring.jaeger.collector.resources.limits.memory | string | `"64Mi"` |  |
| monitoring.jaeger.collector.resources.requests.cpu | string | `"500m"` |  |
| monitoring.jaeger.collector.resources.requests.memory | string | `"32Mi"` |  |
| monitoring.jaeger.elasticsearch.resources.limits.cpu | int | `2` |  |
| monitoring.jaeger.elasticsearch.resources.limits.memory | string | `"4Gi"` |  |
| monitoring.jaeger.elasticsearch.resources.requests.cpu | int | `2` |  |
| monitoring.jaeger.elasticsearch.resources.requests.memory | string | `"4Gi"` |  |
| monitoring.jaeger.elasticsearch.storage.size | string | `"5Gi"` |  |
| monitoring.jaeger.enabled | bool | `true` |  |
| monitoring.jaeger.host | string | `"jaeger"` |  |
| monitoring.jaeger.query.resources.limits.cpu | string | `"100m"` |  |
| monitoring.jaeger.query.resources.limits.memory | string | `"64Mi"` |  |
| monitoring.jaeger.query.resources.requests.cpu | string | `"50m"` |  |
| monitoring.jaeger.query.resources.requests.memory | string | `"32Mi"` |  |
| monitoring.loki.enabled | bool | `true` |  |
| monitoring.loki.promtail.resources.limits.cpu | int | `1` |  |
| monitoring.loki.promtail.resources.limits.memory | string | `"128Mi"` |  |
| monitoring.loki.promtail.resources.requests.cpu | string | `"100m"` |  |
| monitoring.loki.promtail.resources.requests.memory | string | `"64Mi"` |  |
| monitoring.loki.replicas | int | `1` |  |
| monitoring.loki.resources.limits.cpu | int | `1` |  |
| monitoring.loki.resources.limits.memory | string | `"1Gi"` |  |
| monitoring.loki.resources.requests.cpu | string | `"250m"` |  |
| monitoring.loki.resources.requests.memory | string | `"256Mi"` |  |
| monitoring.loki.storageSize | string | `"10Gi"` |  |
| monitoring.metricsServer.enabled | bool | `true` |  |
| monitoring.prometheus.alertmanager.host | string | `"alertmanager"` |  |
| monitoring.prometheus.alertmanager.pagerduty.enabled | bool | `false` |  |
| monitoring.prometheus.alertmanager.pagerduty.routingKey | string | `""` |  |
| monitoring.prometheus.alertmanager.pagerduty.url | string | `""` |  |
| monitoring.prometheus.alertmanager.storage.retention | string | `"120h"` |  |
| monitoring.prometheus.alertmanager.storage.size | string | `"1Gi"` |  |
| monitoring.prometheus.authentication | object | `{}` |  |
| monitoring.prometheus.enabled | bool | `true` |  |
| monitoring.prometheus.host | string | `"prometheus"` |  |
| monitoring.prometheus.kubeStateMetrics.resources.limits.cpu | string | `"100m"` |  |
| monitoring.prometheus.kubeStateMetrics.resources.limits.memory | string | `"512Mi"` |  |
| monitoring.prometheus.kubeStateMetrics.resources.requests.cpu | string | `"100m"` |  |
| monitoring.prometheus.kubeStateMetrics.resources.requests.memory | string | `"128Mi"` |  |
| monitoring.prometheus.nodeExporter.resources.limits.cpu | string | `"2"` |  |
| monitoring.prometheus.nodeExporter.resources.limits.memory | string | `"128Mi"` |  |
| monitoring.prometheus.nodeExporter.resources.requests.cpu | string | `"500m"` |  |
| monitoring.prometheus.nodeExporter.resources.requests.memory | string | `"64Mi"` |  |
| monitoring.prometheus.operator.resources.limits.cpu | string | `"500m"` |  |
| monitoring.prometheus.operator.resources.limits.memory | string | `"512Mi"` |  |
| monitoring.prometheus.operator.resources.requests.cpu | string | `"100m"` |  |
| monitoring.prometheus.operator.resources.requests.memory | string | `"256Mi"` |  |
| monitoring.prometheus.overrides | object | `{}` |  |
| monitoring.prometheus.resources.limits.cpu | string | `"2"` |  |
| monitoring.prometheus.resources.limits.memory | string | `"8Gi"` |  |
| monitoring.prometheus.resources.requests.cpu | string | `"2"` |  |
| monitoring.prometheus.resources.requests.memory | string | `"8Gi"` |  |
| monitoring.prometheus.storage.retention | string | `"4w"` |  |
| monitoring.prometheus.storage.size | string | `"100Gi"` |  |
| monitoring.securityScanning.enabled | bool | `true` |  |
| rbac.admin.groups | list | `[]` |  |
| rbac.admin.users | list | `[]` |  |
| rbac.create | bool | `true` |  |
| rbac.users | list | `[]` |  |
| rbac.view.authenticated | bool | `false` |  |
| rbac.view.groups | list | `[]` |  |
| rbac.view.users | list | `[]` |  |
| speedtest.enabled | bool | `true` |  |
| speedtest.host | string | `"speedtest"` |  |
| traefik.maxReplicas | int | `8` |  |
| traefik.minReplicas | int | `2` |  |
| traefik.resources.limits.cpu | string | `"4"` |  |
| traefik.resources.limits.memory | string | `"500Mi"` |  |
| traefik.resources.requests.cpu | string | `"1"` |  |
| traefik.resources.requests.memory | string | `"250Mi"` |  |

# Upgrading

## To 25.0.0

Prometheus requires a CRD upgrade;

```
kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.52.0/example/prometheus-operator-crd/monitoring.coreos.com_alertmanagerconfigs.yaml
kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.52.0/example/prometheus-operator-crd/monitoring.coreos.com_alertmanagers.yaml
kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.52.0/example/prometheus-operator-crd/monitoring.coreos.com_podmonitors.yaml
kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.52.0/example/prometheus-operator-crd/monitoring.coreos.com_probes.yaml
kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.52.0/example/prometheus-operator-crd/monitoring.coreos.com_prometheuses.yaml
kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.52.0/example/prometheus-operator-crd/monitoring.coreos.com_prometheusrules.yaml
kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.52.0/example/prometheus-operator-crd/monitoring.coreos.com_servicemonitors.yaml
kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.52.0/example/prometheus-operator-crd/monitoring.coreos.com_thanosrulers.yaml
```

## To 26.0.0

Prometheus requires a CRD upgrade;

```
kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.53.1/example/prometheus-operator-crd/monitoring.coreos.com_alertmanagerconfigs.yaml
kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.53.1/example/prometheus-operator-crd/monitoring.coreos.com_alertmanagers.yaml
kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.53.1/example/prometheus-operator-crd/monitoring.coreos.com_podmonitors.yaml
kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.53.1/example/prometheus-operator-crd/monitoring.coreos.com_probes.yaml
kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.53.1/example/prometheus-operator-crd/monitoring.coreos.com_prometheuses.yaml
kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.53.1/example/prometheus-operator-crd/monitoring.coreos.com_prometheusrules.yaml
kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.53.1/example/prometheus-operator-crd/monitoring.coreos.com_servicemonitors.yaml
kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.53.1/example/prometheus-operator-crd/monitoring.coreos.com_thanosrulers.yaml
```

## To 27.0.0

Prometheus requries a CRD upgrade

```
kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.54.0/example/prometheus-operator-crd/monitoring.coreos.com_alertmanagerconfigs.yaml
kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.54.0/example/prometheus-operator-crd/monitoring.coreos.com_alertmanagers.yaml
kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.54.0/example/prometheus-operator-crd/monitoring.coreos.com_podmonitors.yaml
kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.54.0/example/prometheus-operator-crd/monitoring.coreos.com_probes.yaml
kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.54.0/example/prometheus-operator-crd/monitoring.coreos.com_prometheuses.yaml
kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.54.0/example/prometheus-operator-crd/monitoring.coreos.com_prometheusrules.yaml
kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.54.0/example/prometheus-operator-crd/monitoring.coreos.com_servicemonitors.yaml
kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.54.0/example/prometheus-operator-crd/monitoring.coreos.com_thanosrulers.yaml
```

## To 28.0.0

The following components are now under the `monitoring` section:

- `ingressMonitoring` as `ingress`
- `grafana`
- `costAnalysis`
- `prometheus`
- `loki`
- `metricsServer`
- `securityScanning`
- `jaeger`
- `goldpinger`

## To 29.0.0

The helm-operator will now be installed / upgraded via a pre-install/pre-upgrade hook.

Therefore the `HelmRelease` `helm-operator` has been deleted. This means this chart has to be upgraded manually after the helm-operator  will be uninstalled.

## To 30.0.0

Loki HelmRelease moves from namespace `flux` to `monitoring`. You either need to reconnect the PV with the new PVC, or start fresh with 0 logs.

Traefik HelmRelease moves from namespace `flux` to `ingress`. You may need to adjust some things referencing the resources.

## To 31.0.0

This release supports cilium network policies. To create the correct ones, the `.spec.values.global.authentication.config.issuerURL` has been split into `spec.values.global.authentication.config.issuerHost` and `spec.values.global.authentication.config.issuerPath`.

## To 32.0.0

This release installs flux v2 alongside flux v1 and prepares the migration

## To 33.0.0

You have to migrate your resources, at least this cluster resource, to flux v2 after this upgrade to reenable syncing

After this upgrade, flux v1 and the helm-operator will be removed, therefore you have to migrate your resources accordingly

Also, the `.git.instances.$name.url` should not contain `$(GIT_AUTHUSER):$(GIT_AUTHKEY)@` anymore

## To 34.0.0

This concludes the migration, the following HelmReleases will be recreated by this upgrade;

- Loki
- Jaeger

You either need to reconnect the PVs with the new PVCs, or start fresh with no data.
