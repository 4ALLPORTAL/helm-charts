# base-cluster

![Version: 41.1.4](https://img.shields.io/badge/Version-41.1.4-informational?style=flat-square)

A generic, base cluster setup

**Homepage:** <https://4allportal.com>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| jpkraemer-mg | <j.kraemer@4allportal.com> |  |
| Dominic-Beer | <d.beer@4allportal.com> |  |

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | common | 2.27.0 |

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
| dns.domains | list | `[]` |  |
| dns.existingSecret | string | `""` |  |
| externalDNS.resources.limits.cpu | string | `"50m"` |  |
| externalDNS.resources.limits.memory | string | `"128Mi"` |  |
| externalDNS.resources.requests.cpu | string | `"50m"` |  |
| externalDNS.resources.requests.memory | string | `"64Mi"` |  |
| flux.resources | object | `{}` |  |
| git.instances | object | `{}` |  |
| global.authentication.config.emailDomains | list | `[]` |  |
| global.authentication.config.existingSecret | string | `""` |  |
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
| global.helm.image.tag | string | `"3.18.5"` |  |
| global.imageCredentials | list | `[]` |  |
| global.imageRegistry | string | `""` |  |
| global.kubectl.image.registry | string | `"docker.io"` |  |
| global.kubectl.image.repository | string | `"alpine/k8s"` |  |
| global.kubectl.image.tag | string | `"1.33.4"` |  |
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
| monitoring.deadMansSnitch.enabled | bool | `false` |  |
| monitoring.deadMansSnitch.webhookUrl | string | `""` |  |
| monitoring.goldpinger.enabled | bool | `true` |  |
| monitoring.goldpinger.host | string | `"pinger"` |  |
| monitoring.goldpinger.pingHosts | list | `[]` |  |
| monitoring.goldpinger.resources.limits.cpu | string | `"250m"` |  |
| monitoring.goldpinger.resources.limits.memory | string | `"64Mi"` |  |
| monitoring.goldpinger.resources.requests.cpu | string | `"10m"` |  |
| monitoring.goldpinger.resources.requests.memory | string | `"64Mi"` |  |
| monitoring.grafana.additionalDashboards | object | `{}` |  |
| monitoring.grafana.config | object | `{}` |  |
| monitoring.grafana.dashboards.fourAllPortal | bool | `true` |  |
| monitoring.grafana.dashboards.mariadb | bool | `true` |  |
| monitoring.grafana.dashboards.mysql | bool | `true` |  |
| monitoring.grafana.envFromSecrets | list | `[]` |  |
| monitoring.grafana.existingAdminSecret | string | `""` |  |
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
| monitoring.ingress.enabled | bool | `false` |  |
| monitoring.ingress.existingConfigSecret | string | `""` |  |
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
| monitoring.loki.promtail.extraTolerations | list | `[]` |  |
| monitoring.loki.promtail.resources.limits.cpu | int | `1` |  |
| monitoring.loki.promtail.resources.limits.memory | string | `"128Mi"` |  |
| monitoring.loki.promtail.resources.requests.cpu | string | `"100m"` |  |
| monitoring.loki.promtail.resources.requests.memory | string | `"64Mi"` |  |
| monitoring.loki.pspEnabled | bool | `false` |  |
| monitoring.loki.replicas | int | `1` |  |
| monitoring.loki.resources.limits.cpu | int | `1` |  |
| monitoring.loki.resources.limits.memory | string | `"1Gi"` |  |
| monitoring.loki.resources.requests.cpu | string | `"250m"` |  |
| monitoring.loki.resources.requests.memory | string | `"256Mi"` |  |
| monitoring.loki.storageSize | string | `"10Gi"` |  |
| monitoring.metricsServer.enabled | bool | `true` |  |
| monitoring.metricsServer.resources.limits.cpu | string | `"100m"` |  |
| monitoring.metricsServer.resources.limits.memory | string | `"64Mi"` |  |
| monitoring.prometheus.alertmanager.emailconfig | list | `[]` |  |
| monitoring.prometheus.alertmanager.existingSecrets | list | `[]` |  |
| monitoring.prometheus.alertmanager.host | string | `"alertmanager"` |  |
| monitoring.prometheus.alertmanager.pagerduty.description | string | `nil` |  |
| monitoring.prometheus.alertmanager.pagerduty.enabled | bool | `false` |  |
| monitoring.prometheus.alertmanager.pagerduty.existingRoutingKeySecret | string | `""` |  |
| monitoring.prometheus.alertmanager.pagerduty.severity | string | `nil` |  |
| monitoring.prometheus.alertmanager.pagerduty.url | string | `""` |  |
| monitoring.prometheus.alertmanager.routes | list | `[]` |  |
| monitoring.prometheus.alertmanager.storage.retention | string | `"120h"` |  |
| monitoring.prometheus.alertmanager.storage.size | string | `"1Gi"` |  |
| monitoring.prometheus.alertmanager.templateFiles | object | `{}` |  |
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
| monitoring.securityScanning.resources.limits | object | `{}` |  |
| monitoring.securityScanning.resources.requests | object | `{}` |  |
| monitoring.securityScanning.scanJobTolerations | list | `[]` |  |
| rbac.admin.groups | list | `[]` |  |
| rbac.admin.users | list | `[]` |  |
| rbac.create | bool | `true` |  |
| rbac.users | list | `[]` |  |
| rbac.view.authenticated | bool | `false` |  |
| rbac.view.groups | list | `[]` |  |
| rbac.view.users | list | `[]` |  |
| sealedsecrets.enabled | bool | `false` |  |
| sealedsecrets.values | object | `{}` |  |
| speedtest.enabled | bool | `true` |  |
| speedtest.host | string | `"speedtest"` |  |
| speedtest.image.registry | string | `"ghcr.io"` |  |
| speedtest.image.repository | string | `"librespeed/speedtest"` |  |
| speedtest.image.tag | string | `"latest"` |  |
| traefik.cipherSuites | list | `[]` |  |
| traefik.debug.enabled | bool | `false` |  |
| traefik.log.level | string | `"ERROR"` |  |
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

## To 36.0.0

The update includes the upgrade of the prometheus chart to 45.x.x. In order for this upgrade to work, you need to delete the daemonset prometheus-operator-prometheus-node-exporter.

## To 37.0.0

This update removes the old security scanner estafette and installs aquasecurities trivy with the corresponding grafana dashboard.

### To 37.1.6

You can now add an email configuration for the alertmanager. If your email server uses port 456 SMARTTLS will be disabled automatically. It is also possible to add custom routes for the alertmanager. For the syntax please refer to the alertmanager [documentation](https://prometheus.io/docs/alerting/latest/configuration/) or our values.schema.json.

### To 38.0.0

Before executing the upgrade you have to modify the traefik helmrelease and disable the PodSecurityPolicy yourself. After that proceed with the following instruction.
This  update upgrades the ingress controller traefik with its helm chart to 23.x.x. There are some required changes that you need to be aware of. The clusterrole will be renamed and the PodPolicy will be delete because it is deprecated since k8s version 1.25. In order to perform this update you have to delete the traefik deployment manually.

### To 39.0.0

This update ensures compatibility with k8s v1.27.x, which no longer supports several api versions. It also upgrades the traefik chart to 25.x.x, as well as the oauth2-proxy chart to v3.x.x.
The upgrade to k8s v1.27.x also removes the in-tree AWS storage drivers.
Please check the following (urgent) upgrade notes before upgrading:

[traefik release notes](https://github.com/traefik/traefik-helm-chart/releases/tag/v25.0.0)

[k8s upgrade notes v1.24](https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-1.24.md#urgent-upgrade-notes)

[k8s upgrade notes v1.25](https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-1.25.md#urgent-upgrade-notes)

[k8s upgrade notes v1.26](https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-1.26.md#urgent-upgrade-notes)

[k8s upgrade notes v1.27](https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-1.27.md#urgent-upgrade-notes)

[redis 7.0 release notes](https://raw.githubusercontent.com/redis/redis/7.0/00-RELEASENOTES) before upgrading.

### To 39.0.1

Prometheus will now send alerts for levels where human interference might be necessary in regards to Node CPU / Memory usage as well as HikariCP.

### To 39.0.2

You can now add extra configurations for Trivy, allowing for more efficient resource usage and schedulable pods.

### To 40.0.0

Our implementation of the DeadMansSwitch was removed entirely and we swapped to the DeadMansSnitch from Prometheus.

### To 40.6.0

We've upgraded Traefik to v34.x.x, going from Traefik v2 to Traefik v3 Proxy.
We urge you to read the [traefik release notes](https://github.com/traefik/traefik-helm-chart/releases/tag/v26.0.0) of all versions >25.0.0 before upgrading.
We've linked Traefik v26.0.0, all other release notes are accessible from that link

### To 41.0.0

Credentials must now be specified as existing secrets to avoid plaintext passwords. The following entries must be adjusted:
| Old entry | New entry | Used key from secret | Description |
|-----|------|---------|-------------|
| global.imageCredentials.* | global.imageCredentials | .dockerconfigjson | An array of existing secret names. The secrets must contain .dockerconfigjson |
| global.authentication.config.* | authentication.config.existingSecret | client-id, client-secret, cookie-secret | Secret must contain client-id, client-secret, cookie-secret |
| git.instances.* | git.instances.existingSecret | username, password | Secret must contain username, password |
| dns.apiKey | dns.existingSecret | cloudflare_api_key | Secret must contain cloudflare_api_key |
| backup.license.instances.* | backup.licenseSecretName | key.txt | Secret must contain key.txt with a license certificate |
| backup.servingCerts.* | / | * | omitted because generate is now set to true |
| monitoring.prometheus.alertmanager.* | monitoring.prometheus.alertmanager.existingSecrets | * | A list of existing secrets which can be used in service_key_file |
| monitoring.prometheus.alertmanager.pagerduty. | monitoring.prometheus.alertmanager.pagerduty.existingRoutingKeySecret | pagerduty_routing_key | Secret must contain pagerduty_routing_key |
| monitoring.grafana.* | monitoring.grafana.envFromSecrets | * | A list of secret keys to be used in envFromSecret |
| monitoring.grafana.* | monitoring.grafana.existingAdminSecret | admin-user, admin-password | Secret must contain admin-user, admin-password |
| monitoring.ingress.* | monitoring.ingress.existingConfigSecret | * | Secret with the enableMonitorDeletion, creationDelay and providers |

### To 41.1.0

We've updated our Loki subchart to have configurable promtail tolerations, adding onto the default tolerations provided by the Chart.

### To 41.1.1

We've added a new MySQL Dashboard for Grafana, showing metrics with the Instance Name from Kubernetes instead of internal IP Address showing

### To 41.1.2

In respect of Bitnami moving their old(er) tagged images to a legacy repository (`docker.io/bitnamilegacy`), all image references were changed to pull from said new repository.