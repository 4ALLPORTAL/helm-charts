# 4allportal

![Version: 19.0.25](https://img.shields.io/badge/Version-19.0.25-informational?style=flat-square) ![AppVersion: 3.10.30](https://img.shields.io/badge/AppVersion-3.10.30-informational?style=flat-square)

A Helm chart for 4ALLPORTAL version 3.10.0 and up

**Homepage:** <https://4allportal.com>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| tasches | <s.tasche@4allportal.com> |  |

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://4allportal.github.io/helm-charts | maxscale | 4.0.9 |
| https://charts.bitnami.com/bitnami | common | 2.2.3 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| backups.mysql.containerSecurityContext.allowPrivilegeEscalation | bool | `false` |  |
| backups.mysql.containerSecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| backups.mysql.containerSecurityContext.privileged | bool | `false` |  |
| backups.mysql.containerSecurityContext.readOnlyRootFilesystem | bool | `true` |  |
| backups.mysql.containerSecurityContext.runAsGroup | int | `1000` |  |
| backups.mysql.containerSecurityContext.runAsNonRoot | bool | `true` |  |
| backups.mysql.containerSecurityContext.runAsUser | int | `1000` |  |
| backups.mysql.daysToKeep | int | `7` |  |
| backups.mysql.enabled | bool | `false` |  |
| backups.mysql.monthsToKeep | int | `6` |  |
| backups.mysql.nodeSelector | object | `{}` |  |
| backups.mysql.persistence | object | `{}` |  |
| backups.mysql.resources.limits.cpu | int | `2` |  |
| backups.mysql.resources.limits.memory | string | `"1Gi"` |  |
| backups.mysql.resources.requests.cpu | string | `"100m"` |  |
| backups.mysql.resources.requests.memory | string | `"256Mi"` |  |
| backups.mysql.securityContext.fsGroup | int | `1000` |  |
| backups.mysql.securityContext.runAsGroup | int | `1000` |  |
| backups.mysql.securityContext.runAsNonRoot | bool | `true` |  |
| backups.mysql.securityContext.runAsUser | int | `1000` |  |
| backups.mysql.securityOptions.hostIPC | bool | `false` |  |
| backups.mysql.securityOptions.hostNetwork | bool | `false` |  |
| backups.mysql.securityOptions.hostPID | bool | `false` |  |
| backups.mysql.tolerations | list | `[]` |  |
| backups.mysql.weeksToKeep | int | `4` |  |
| backups.s3.image.registry | string | `"docker.io"` |  |
| backups.s3.image.repository | string | `"jess/s3cmd"` |  |
| backups.s3.image.tag | string | `"latest@sha256:96280e09b8e73e50139c26fb2477792484b81f022e01bc5ad1acdae9b4923642"` |  |
| backups.s3.resources.limits.cpu | int | `2` |  |
| backups.s3.resources.limits.memory | string | `"1Gi"` |  |
| backups.s3.resources.requests.cpu | string | `"100m"` |  |
| backups.s3.resources.requests.memory | string | `"256Mi"` |  |
| backups.target.s3.accessKey | string | `""` |  |
| backups.target.s3.bucket | string | `""` |  |
| backups.target.s3.endpoint | string | `""` |  |
| backups.target.s3.secretKey | string | `""` |  |
| backups.volumes.enabled | bool | `false` |  |
| backups.volumes.password | string | `""` |  |
| backups.volumes.retention.policy | object | `{}` |  |
| backups.volumes.retention.prune | bool | `true` |  |
| backups.volumes.schedule | string | `""` |  |
| dreiDRenderer.affinity | object | `{}` |  |
| dreiDRenderer.containerSecurityContext.allowPrivilegeEscalation | bool | `false` |  |
| dreiDRenderer.containerSecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| dreiDRenderer.containerSecurityContext.privileged | bool | `false` |  |
| dreiDRenderer.containerSecurityContext.readOnlyRootFilesystem | bool | `true` |  |
| dreiDRenderer.containerSecurityContext.runAsGroup | int | `1000` |  |
| dreiDRenderer.containerSecurityContext.runAsNonRoot | bool | `true` |  |
| dreiDRenderer.containerSecurityContext.runAsUser | int | `1000` |  |
| dreiDRenderer.enabled | bool | `false` |  |
| dreiDRenderer.hpa.enabled | bool | `false` |  |
| dreiDRenderer.hpa.maxReplicas | int | `4` |  |
| dreiDRenderer.hpa.minReplicas | int | `1` |  |
| dreiDRenderer.image.registry | string | `"registry.4allportal.net"` |  |
| dreiDRenderer.image.repository | string | `"3d-renderer"` |  |
| dreiDRenderer.image.tag | string | `"latest"` |  |
| dreiDRenderer.livenessProbe.enabled | bool | `true` |  |
| dreiDRenderer.livenessProbe.failureThreshold | int | `8` |  |
| dreiDRenderer.livenessProbe.initialDelaySeconds | int | `10` |  |
| dreiDRenderer.livenessProbe.periodSeconds | int | `10` |  |
| dreiDRenderer.livenessProbe.successThreshold | int | `1` |  |
| dreiDRenderer.livenessProbe.timeoutSeconds | int | `5` |  |
| dreiDRenderer.nodeSelector | object | `{}` |  |
| dreiDRenderer.podDisruptionBudget | bool | `true` |  |
| dreiDRenderer.readinessProbe.enabled | bool | `true` |  |
| dreiDRenderer.readinessProbe.failureThreshold | int | `3` |  |
| dreiDRenderer.readinessProbe.initialDelaySeconds | int | `0` |  |
| dreiDRenderer.readinessProbe.periodSeconds | int | `1` |  |
| dreiDRenderer.readinessProbe.successThreshold | int | `1` |  |
| dreiDRenderer.readinessProbe.timeoutSeconds | int | `1` |  |
| dreiDRenderer.replicas | int | `1` |  |
| dreiDRenderer.resources.limits.cpu | int | `2` |  |
| dreiDRenderer.resources.limits.memory | string | `"2Gi"` |  |
| dreiDRenderer.resources.requests.cpu | string | `"10m"` |  |
| dreiDRenderer.resources.requests.memory | string | `"128Mi"` |  |
| dreiDRenderer.securityContext.fsGroup | int | `1000` |  |
| dreiDRenderer.securityContext.runAsGroup | int | `1000` |  |
| dreiDRenderer.securityContext.runAsNonRoot | bool | `true` |  |
| dreiDRenderer.securityContext.runAsUser | int | `1000` |  |
| dreiDRenderer.securityOptions.hostIPC | bool | `false` |  |
| dreiDRenderer.securityOptions.hostNetwork | bool | `false` |  |
| dreiDRenderer.securityOptions.hostPID | bool | `false` |  |
| dreiDRenderer.tolerations | list | `[]` |  |
| dreiDRenderer.tracing.enabled | bool | `false` |  |
| dreiDRenderer.tracing.jaeger.agent.useDaemonSet | bool | `true` |  |
| dreiDRenderer.tracing.jaeger.sampler.param | int | `1` |  |
| dreiDRenderer.tracing.jaeger.sampler.type | string | `"const"` |  |
| dreiDRenderer.tracing.jaeger.serviceName | string | `"4ALLPORTAL-3D-Renderer"` |  |
| fourAllPortal.affinity | object | `{}` |  |
| fourAllPortal.containerSecurityContext.allowPrivilegeEscalation | bool | `false` |  |
| fourAllPortal.containerSecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| fourAllPortal.containerSecurityContext.privileged | bool | `false` |  |
| fourAllPortal.containerSecurityContext.readOnlyRootFilesystem | bool | `true` |  |
| fourAllPortal.containerSecurityContext.runAsGroup | int | `1000` |  |
| fourAllPortal.containerSecurityContext.runAsNonRoot | bool | `true` |  |
| fourAllPortal.containerSecurityContext.runAsUser | int | `1000` |  |
| fourAllPortal.database.acquireIncrement | int | `5` |  |
| fourAllPortal.database.existing | object | `{}` |  |
| fourAllPortal.database.initialPoolSize | int | `5` |  |
| fourAllPortal.database.maxIdleTime | int | `180` |  |
| fourAllPortal.database.maxPoolSize | int | `90` |  |
| fourAllPortal.database.minPoolSize | int | `5` |  |
| fourAllPortal.database.numHelperThreads | int | `5` |  |
| fourAllPortal.debug | bool | `false` |  |
| fourAllPortal.env | object | `{}` |  |
| fourAllPortal.fourApps | object | `{}` |  |
| fourAllPortal.general.admin.firstName | string | `""` |  |
| fourAllPortal.general.admin.lastName | string | `""` |  |
| fourAllPortal.general.admin.password | string | `""` |  |
| fourAllPortal.general.admin.username | string | `"administrator"` |  |
| fourAllPortal.general.defaultLanguage | string | `"en_US"` |  |
| fourAllPortal.hostAliases | list | `[]` |  |
| fourAllPortal.hpa.enabled | bool | `false` |  |
| fourAllPortal.hpa.maxReplicas | int | `4` |  |
| fourAllPortal.hpa.minReplicas | int | `2` |  |
| fourAllPortal.image.registry | string | `"registry.4allportal.net"` |  |
| fourAllPortal.image.repository | string | `"4allportal"` |  |
| fourAllPortal.image.tag | string | `"3.10.8"` |  |
| fourAllPortal.ingress.additionalHosts | object | `{}` |  |
| fourAllPortal.ingress.annotations | object | `{}` |  |
| fourAllPortal.ingress.enabled | bool | `false` |  |
| fourAllPortal.ingress.endpointMonitor.enabled | bool | `false` |  |
| fourAllPortal.ingress.existingCertificate | object | `{}` |  |
| fourAllPortal.ingress.host | string | `""` |  |
| fourAllPortal.initContainers | list | `[]` |  |
| fourAllPortal.livenessProbe.enabled | bool | `true` |  |
| fourAllPortal.livenessProbe.failureThreshold | int | `3` |  |
| fourAllPortal.livenessProbe.initialDelaySeconds | int | `30` |  |
| fourAllPortal.livenessProbe.periodSeconds | int | `10` |  |
| fourAllPortal.livenessProbe.successThreshold | int | `1` |  |
| fourAllPortal.livenessProbe.timeoutSeconds | int | `5` |  |
| fourAllPortal.mail.enabled | bool | `false` |  |
| fourAllPortal.mail.host | string | `""` |  |
| fourAllPortal.mail.password | string | `""` |  |
| fourAllPortal.mail.port | int | `25` |  |
| fourAllPortal.mail.replyTo | bool | `false` |  |
| fourAllPortal.mail.security | string | `"SSL"` |  |
| fourAllPortal.mail.system.from.email | string | `""` |  |
| fourAllPortal.mail.system.from.name | string | `""` |  |
| fourAllPortal.mail.system.replyTo.email | string | `""` |  |
| fourAllPortal.mail.system.sender | string | `""` |  |
| fourAllPortal.mail.useAuthentication | bool | `true` |  |
| fourAllPortal.mail.user | string | `""` |  |
| fourAllPortal.metrics.enabled | bool | `true` |  |
| fourAllPortal.metrics.serviceMonitor.enabled | bool | `true` |  |
| fourAllPortal.nodeSelector | object | `{}` |  |
| fourAllPortal.persistence.assets.accessMode | string | `"ReadWriteMany"` |  |
| fourAllPortal.persistence.assets.annotations | object | `{}` |  |
| fourAllPortal.persistence.assets.enabled | bool | `false` |  |
| fourAllPortal.persistence.assets.size | string | `"5Gi"` |  |
| fourAllPortal.persistence.config.accessMode | string | `"ReadWriteMany"` |  |
| fourAllPortal.persistence.config.annotations | object | `{}` |  |
| fourAllPortal.persistence.config.enabled | bool | `false` |  |
| fourAllPortal.persistence.config.size | string | `"100Gi"` |  |
| fourAllPortal.podDisruptionBudget | bool | `true` |  |
| fourAllPortal.readinessProbe.enabled | bool | `true` |  |
| fourAllPortal.readinessProbe.failureThreshold | int | `3` |  |
| fourAllPortal.readinessProbe.initialDelaySeconds | int | `0` |  |
| fourAllPortal.readinessProbe.periodSeconds | int | `1` |  |
| fourAllPortal.readinessProbe.successThreshold | int | `1` |  |
| fourAllPortal.readinessProbe.timeoutSeconds | int | `5` |  |
| fourAllPortal.replicas | int | `2` |  |
| fourAllPortal.resources.limits.cpu | int | `4` |  |
| fourAllPortal.resources.limits.memory | string | `"4Gi"` |  |
| fourAllPortal.resources.requests.cpu | string | `"500m"` |  |
| fourAllPortal.resources.requests.memory | string | `"2Gi"` |  |
| fourAllPortal.securityContext.fsGroup | int | `1000` |  |
| fourAllPortal.securityContext.runAsGroup | int | `1000` |  |
| fourAllPortal.securityContext.runAsNonRoot | bool | `true` |  |
| fourAllPortal.securityContext.runAsUser | int | `1000` |  |
| fourAllPortal.securityOptions.hostIPC | bool | `false` |  |
| fourAllPortal.securityOptions.hostNetwork | bool | `false` |  |
| fourAllPortal.securityOptions.hostPID | bool | `false` |  |
| fourAllPortal.startupProbe.enabled | bool | `true` |  |
| fourAllPortal.startupProbe.failureThreshold | int | `33` |  |
| fourAllPortal.startupProbe.initialDelaySeconds | int | `30` |  |
| fourAllPortal.startupProbe.periodSeconds | int | `10` |  |
| fourAllPortal.startupProbe.successThreshold | int | `1` |  |
| fourAllPortal.startupProbe.timeoutSeconds | int | `5` |  |
| fourAllPortal.tolerations | list | `[]` |  |
| fourAllPortal.tracing.enabled | bool | `false` |  |
| fourAllPortal.tracing.jaeger.agent.useDaemonSet | bool | `true` |  |
| fourAllPortal.tracing.jaeger.sampler.param | int | `1` |  |
| fourAllPortal.tracing.jaeger.sampler.type | string | `"const"` |  |
| fourAllPortal.tracing.jaeger.serviceName | string | `"4ALLPORTAL"` |  |
| global.networkPolicy.applicationLabels."app.kubernetes.io/component" | string | `"backend"` |  |
| global.networkPolicy.applicationLabels."app.kubernetes.io/name" | string | `"4allportal"` |  |
| global.networkPolicy.dnsLabels."io.kubernetes.pod.namespace" | string | `"kube-system"` |  |
| global.networkPolicy.dnsLabels.k8s-app | string | `"kube-dns"` |  |
| global.networkPolicy.ingressLabels."app.kubernetes.io/name" | string | `"traefik"` |  |
| global.networkPolicy.ingressLabels."io.kubernetes.pod.namespace" | string | `"ingress"` |  |
| global.networkPolicy.metricsLabels."app.kubernetes.io/name" | string | `"prometheus"` |  |
| global.networkPolicy.metricsLabels."io.kubernetes.pod.namespace" | string | `"monitoring"` |  |
| global.networkPolicy.type | string | `"auto"` |  |
| global.persistence.enabled | bool | `true` |  |
| global.tracing.enabled | bool | `true` |  |
| global.tracing.jaeger.agent.port | int | `6831` |  |
| global.tracing.jaeger.agent.useDaemonSet | bool | `true` |  |
| global.tracing.jaeger.sampler.param | int | `1` |  |
| global.tracing.jaeger.sampler.type | string | `"const"` |  |
| maxscale.enabled | bool | `true` |  |
| maxscale.enterpriseLicensed | bool | `false` |  |
| maxscale.hpa.enabled | bool | `false` |  |
| maxscale.mariadb.db.name | string | `"4allportal"` |  |
| maxscale.mariadb.db.user | string | `"4allportal"` |  |
| maxscale.mariadb.podDisruptionBudget | object | `{}` |  |
| maxscale.replicas | int | `2` |  |
| users | list | `[]` |  |
| webdav.affinity | object | `{}` |  |
| webdav.containerSecurityContext.allowPrivilegeEscalation | bool | `false` |  |
| webdav.containerSecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| webdav.containerSecurityContext.privileged | bool | `false` |  |
| webdav.containerSecurityContext.readOnlyRootFilesystem | bool | `true` |  |
| webdav.containerSecurityContext.runAsGroup | int | `1000` |  |
| webdav.containerSecurityContext.runAsNonRoot | bool | `true` |  |
| webdav.containerSecurityContext.runAsUser | int | `1000` |  |
| webdav.enabled | bool | `false` |  |
| webdav.groups | object | `{}` |  |
| webdav.image.registry | string | `"docker.io"` |  |
| webdav.image.repository | string | `"httpd"` |  |
| webdav.image.tag | string | `"2.4.55"` |  |
| webdav.livenessProbe.enabled | bool | `true` |  |
| webdav.livenessProbe.failureThreshold | int | `4` |  |
| webdav.livenessProbe.initialDelaySeconds | int | `5` |  |
| webdav.livenessProbe.periodSeconds | int | `10` |  |
| webdav.livenessProbe.successThreshold | int | `1` |  |
| webdav.livenessProbe.timeoutSeconds | int | `5` |  |
| webdav.mounts | object | `{}` |  |
| webdav.nodeSelector | object | `{}` |  |
| webdav.podDisruptionBudget | bool | `true` |  |
| webdav.readinessProbe.enabled | bool | `true` |  |
| webdav.readinessProbe.failureThreshold | int | `3` |  |
| webdav.readinessProbe.initialDelaySeconds | int | `0` |  |
| webdav.readinessProbe.periodSeconds | int | `1` |  |
| webdav.readinessProbe.successThreshold | int | `1` |  |
| webdav.readinessProbe.timeoutSeconds | int | `1` |  |
| webdav.resources.limits.cpu | int | `4` |  |
| webdav.resources.limits.memory | string | `"1Gi"` |  |
| webdav.resources.requests.cpu | string | `"10m"` |  |
| webdav.resources.requests.memory | string | `"32Mi"` |  |
| webdav.securityContext.fsGroup | int | `1000` |  |
| webdav.securityContext.runAsGroup | int | `1000` |  |
| webdav.securityContext.runAsNonRoot | bool | `true` |  |
| webdav.securityContext.runAsUser | int | `1000` |  |
| webdav.securityOptions.hostIPC | bool | `false` |  |
| webdav.securityOptions.hostNetwork | bool | `false` |  |
| webdav.securityOptions.hostPID | bool | `false` |  |
| webdav.tolerations | list | `[]` |  |
| webdav.users | object | `{}` |  |

# Upgrading

## To 14.0.0

This version replaces the built-in maxscale deployment with a subchart.

This means that the service names and such will change.

This in turn doesn't allow for a zero-downtime update. You can circumvent this by setting `.maxscale.fullnameOverride` to `$RELEASE_NAME-4allportal-maxscale`

## To 15.0.0

The S3 configuration for the backups has been moved from `.backups.volumes.backends.s3` to `.backups.target.s3` and will be used by the mysql backups as well

## To 16.0.0

The webdav setup will change, including the configuration

## To 17.0.0

This release prepares the upgrade from the included maxscale chart from 1.x.x to 2.x.x.

During the upgrade, it deletes the mariadb statefulSet with `--cascade orphan`.

## To 18.0.0

This release concludes the upgrade from the included maxscale chart.

During the upgrade, it deletes the mariadb statefulSet with `--cascade orphan`.
