# maxscale

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 6.2.0](https://img.shields.io/badge/AppVersion-6.2.0-informational?style=flat-square)

Deploys a maxscale mariadb-galera proxy including mariadb-galera

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | common | 1.11.3 |
| https://charts.bitnami.com/bitnami | mariadb(mariadb-galera) | 7.1.4 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| global.networkPolicy.type | string | `"auto"` |  |
| global.networkPolicy.metricsLabels."io.kubernetes.pod.namespace" | string | `"monitoring"` |  |
| global.networkPolicy.metricsLabels."app.kubernetes.io/name" | string | `"prometheus"` |  |
| global.networkPolicy.dnsLabels."io.kubernetes.pod.namespace" | string | `"kube-system"` |  |
| global.networkPolicy.dnsLabels.k8s-app | string | `"kube-dns"` |  |
| global.networkPolicy.applicationLabels."app.kubernetes.io/name" | string | `nil` |  |
| global.networkPolicy.applicationLabels."app.kubernetes.io/instance" | string | `"{{ .Release.Name }}"` |  |
| global.networkPolicy.applicationLabels."io.kubernetes.pod.namespace" | string | `"{{ .Release.Namespace }}"` |  |
| image.registry | string | `"docker.io"` |  |
| image.repository | string | `"mariadb/maxscale"` |  |
| image.tag | string | `"6.2.3"` |  |
| replicas | int | `2` |  |
| enterpriseLicensed | bool | `false` |  |
| hpa.enabled | bool | `false` |  |
| hpa.minReplicas | int | `2` |  |
| hpa.maxReplicas | int | `4` |  |
| resources.requests.cpu | string | `"125m"` |  |
| resources.requests.memory | string | `"128Mi"` |  |
| resources.limits.cpu | string | `"500m"` |  |
| resources.limits.memory | string | `"512Mi"` |  |
| livenessProbe.enabled | bool | `true` |  |
| livenessProbe.failureThreshold | int | `3` |  |
| livenessProbe.periodSeconds | int | `10` |  |
| livenessProbe.successThreshold | int | `1` |  |
| livenessProbe.timeoutSeconds | int | `5` |  |
| livenessProbe.initialDelaySeconds | int | `2` |  |
| readinessProbe.enabled | bool | `true` |  |
| readinessProbe.failureThreshold | int | `3` |  |
| readinessProbe.periodSeconds | int | `1` |  |
| readinessProbe.successThreshold | int | `1` |  |
| readinessProbe.timeoutSeconds | int | `1` |  |
| readinessProbe.initialDelaySeconds | int | `0` |  |
| securityContext.runAsNonRoot | bool | `true` |  |
| securityContext.fsGroup | int | `996` |  |
| securityContext.runAsUser | int | `998` |  |
| securityContext.runAsGroup | int | `996` |  |
| securityOptions.hostIPC | bool | `false` |  |
| securityOptions.hostPID | bool | `false` |  |
| securityOptions.hostNetwork | bool | `false` |  |
| containerSecurityContext.runAsNonRoot | bool | `true` |  |
| containerSecurityContext.allowPrivilegeEscalation | bool | `false` |  |
| containerSecurityContext.privileged | bool | `false` |  |
| containerSecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| containerSecurityContext.runAsGroup | int | `996` |  |
| containerSecurityContext.runAsUser | int | `998` |  |
| containerSecurityContext.readOnlyRootFilesystem | bool | `true` |  |
| podDisruptionBudget | bool | `true` |  |
| mariadb.replicaCount | int | `3` |  |
| mariadb.rootUser.forcePassword | bool | `true` |  |
| mariadb.rootUser.password | string | `"CHANGEME"` |  |
| mariadb.db.forcePassword | bool | `true` |  |
| mariadb.db.password | string | `"CHANGEME"` |  |
| mariadb.galera.mariabackup.forcePassword | bool | `true` |  |
| mariadb.galera.mariabackup.password | string | `"CHANGEME"` |  |
| mariadb.podDisruptionBudget.create | bool | `true` |  |
| mariadb.podDisruptionBudget.minAvailable | int | `2` |  |
| mariadb.podAntiAffinityPreset | string | `"hard"` |  |
| mariadb.extraEnvVars[0].name | string | `"MARIADB_EXTRA_FLAGS"` |  |
| mariadb.extraEnvVars[0].value | string | `"--skip-log-bin"` |  |
| mariadb.metrics.enabled | bool | `true` |  |
| mariadb.metrics.serviceMonitor.enabled | bool | `true` |  |
| mariadb.metrics.serviceMonitor.selector | bool | `false` |  |
| mariadb.metrics.resources.requests.memory | string | `"32Mi"` |  |
| mariadb.metrics.resources.requests.cpu | string | `"10m"` |  |
| mariadb.metrics.resources.limits.memory | string | `"32Mi"` |  |
| mariadb.metrics.resources.limits.cpu | string | `"250m"` |  |
| mariadb.persistence.enabled | bool | `true` |  |
| mariadb.persistence.size | string | `"8Gi"` |  |
| mariadb.resources.requests.memory | string | `"1Gi"` |  |
| mariadb.resources.requests.cpu | string | `"100m"` |  |
| mariadb.resources.limits.memory | string | `"2Gi"` |  |
| mariadb.resources.limits.cpu | int | `1` |  |
| mariadb.podSecurityContext.enabled | bool | `true` |  |
| mariadb.containerSecurityContext.enabled | bool | `true` |  |
| mariadb.containerSecurityContext.allowPrivilegeEscalation | bool | `false` |  |
| mariadb.containerSecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| mariadb.containerSecurityContext.privileged | bool | `false` |  |
| mariadb.containerSecurityContext.runAsNonRoot | bool | `true` |  |
| mariadb.serviceAccount.create | bool | `false` |  |
| mariadb.rbac.create | bool | `false` |  |

# Upgrading

## To 2.0.0

This release upgrades the included mariadb-galera chart from 6.x.x to 7.x.x.

During the upgrade, it deletes the mariadb statefulSet with `--cascade orphan`.

Before you upgrade beyond this version, you should upgrade to here first
