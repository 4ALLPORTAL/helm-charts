# maxscale

![Version: 4.0.8](https://img.shields.io/badge/Version-4.0.8-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 22.08.3](https://img.shields.io/badge/AppVersion-22.08.3-informational?style=flat-square)

Deploys a maxscale mariadb-galera proxy including mariadb-galera

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| tasches | <s.tasche@4allportal.com> |  |

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | common | 2.2.3 |
| https://charts.bitnami.com/bitnami | mariadb(mariadb-galera) | 7.4.14 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| containerSecurityContext.allowPrivilegeEscalation | bool | `false` |  |
| containerSecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| containerSecurityContext.privileged | bool | `false` |  |
| containerSecurityContext.readOnlyRootFilesystem | bool | `true` |  |
| containerSecurityContext.runAsGroup | int | `996` |  |
| containerSecurityContext.runAsNonRoot | bool | `true` |  |
| containerSecurityContext.runAsUser | int | `998` |  |
| enterpriseLicensed | bool | `false` |  |
| global.networkPolicy.applicationLabels."app.kubernetes.io/instance" | string | `"{{ .Release.Name }}"` |  |
| global.networkPolicy.applicationLabels."app.kubernetes.io/name" | string | `nil` |  |
| global.networkPolicy.applicationLabels."io.kubernetes.pod.namespace" | string | `"{{ .Release.Namespace }}"` |  |
| global.networkPolicy.dnsLabels."io.kubernetes.pod.namespace" | string | `"kube-system"` |  |
| global.networkPolicy.dnsLabels.k8s-app | string | `"kube-dns"` |  |
| global.networkPolicy.metricsLabels."app.kubernetes.io/name" | string | `"prometheus"` |  |
| global.networkPolicy.metricsLabels."io.kubernetes.pod.namespace" | string | `"monitoring"` |  |
| global.networkPolicy.type | string | `"auto"` |  |
| hpa.enabled | bool | `false` |  |
| hpa.maxReplicas | int | `4` |  |
| hpa.minReplicas | int | `2` |  |
| image.registry | string | `"docker.io"` |  |
| image.repository | string | `"mariadb/maxscale"` |  |
| image.tag | string | `"22.08.4"` |  |
| livenessProbe.enabled | bool | `true` |  |
| livenessProbe.failureThreshold | int | `3` |  |
| livenessProbe.initialDelaySeconds | int | `2` |  |
| livenessProbe.periodSeconds | int | `10` |  |
| livenessProbe.successThreshold | int | `1` |  |
| livenessProbe.timeoutSeconds | int | `5` |  |
| mariadb.containerSecurityContext.allowPrivilegeEscalation | bool | `false` |  |
| mariadb.containerSecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| mariadb.containerSecurityContext.enabled | bool | `true` |  |
| mariadb.containerSecurityContext.privileged | bool | `false` |  |
| mariadb.containerSecurityContext.runAsNonRoot | bool | `true` |  |
| mariadb.db.forcePassword | bool | `true` |  |
| mariadb.db.password | string | `"CHANGEME"` |  |
| mariadb.extraEnvVars[0].name | string | `"MARIADB_EXTRA_FLAGS"` |  |
| mariadb.extraEnvVars[0].value | string | `"--skip-log-bin"` |  |
| mariadb.galera.mariabackup.forcePassword | bool | `true` |  |
| mariadb.galera.mariabackup.password | string | `"CHANGEME"` |  |
| mariadb.metrics.enabled | bool | `true` |  |
| mariadb.metrics.resources.limits.cpu | string | `"250m"` |  |
| mariadb.metrics.resources.limits.memory | string | `"32Mi"` |  |
| mariadb.metrics.resources.requests.cpu | string | `"10m"` |  |
| mariadb.metrics.resources.requests.memory | string | `"32Mi"` |  |
| mariadb.metrics.serviceMonitor.enabled | bool | `true` |  |
| mariadb.metrics.serviceMonitor.selector | bool | `false` |  |
| mariadb.persistence.enabled | bool | `true` |  |
| mariadb.persistence.size | string | `"8Gi"` |  |
| mariadb.podAntiAffinityPreset | string | `"hard"` |  |
| mariadb.podDisruptionBudget.create | bool | `true` |  |
| mariadb.podDisruptionBudget.minAvailable | int | `2` |  |
| mariadb.podSecurityContext.enabled | bool | `true` |  |
| mariadb.rbac.create | bool | `false` |  |
| mariadb.replicaCount | int | `3` |  |
| mariadb.resources.limits.cpu | int | `1` |  |
| mariadb.resources.limits.memory | string | `"2Gi"` |  |
| mariadb.resources.requests.cpu | string | `"100m"` |  |
| mariadb.resources.requests.memory | string | `"1Gi"` |  |
| mariadb.rootUser.forcePassword | bool | `true` |  |
| mariadb.rootUser.password | string | `"CHANGEME"` |  |
| mariadb.serviceAccount.create | bool | `false` |  |
| podDisruptionBudget | bool | `true` |  |
| readinessProbe.enabled | bool | `true` |  |
| readinessProbe.failureThreshold | int | `3` |  |
| readinessProbe.initialDelaySeconds | int | `0` |  |
| readinessProbe.periodSeconds | int | `1` |  |
| readinessProbe.successThreshold | int | `1` |  |
| readinessProbe.timeoutSeconds | int | `1` |  |
| replicas | int | `2` |  |
| resources.limits.cpu | string | `"500m"` |  |
| resources.limits.memory | string | `"512Mi"` |  |
| resources.requests.cpu | string | `"125m"` |  |
| resources.requests.memory | string | `"128Mi"` |  |
| securityContext.fsGroup | int | `996` |  |
| securityContext.runAsGroup | int | `996` |  |
| securityContext.runAsNonRoot | bool | `true` |  |
| securityContext.runAsUser | int | `998` |  |
| securityOptions.hostIPC | bool | `false` |  |
| securityOptions.hostNetwork | bool | `false` |  |
| securityOptions.hostPID | bool | `false` |  |

# Upgrading

## To 2.0.0

This release upgrades the included mariadb-galera chart from 6.x.x to 7.x.x.

During the upgrade, it deletes the mariadb statefulSet with `--cascade orphan`.

Before you upgrade beyond this version, you should upgrade to here first
