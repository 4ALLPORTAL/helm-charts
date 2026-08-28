{{/*
Single source of truth for upstream chart versions managed by this chart.

Bump the constants here when upgrading a component, and the corresponding
HelmRelease will pick it up. Pin EXACT versions — never `x.x.x` ranges — so
chart bumps are explicit, reviewable PRs.

Each constant carries a `renovate:` annotation so Renovate proposes updates
automatically (see the customManager in .github/renovate.json). Keep the
annotation on the line directly above its define. DHI (dhi.io) is a private
OCI registry — Renovate needs hostRules credentials for dhi.io to resolve
those tags.

All charts are sourced from DHI (dhi.io) except flux2 (fluxcd-community),
reflector (emberstack repo), mimir and k8sMonitoring (grafana repo),
ingressMonitor (stakater repo), janitor (ghcr.io OCI), descheduler
(kubernetes-sigs repo) and stash (appscode repo).
*/}}

{{- /* renovate: datasource=helm depName=cilium registryUrl=https://helm.cilium.io/ */ -}}
{{- define "base-cluster.versions.cilium.chart" -}}1.19.3{{- end -}}

{{- /* renovate: datasource=docker depName=flux2 packageName=ghcr.io/fluxcd-community/charts/flux2 */ -}}
{{- define "base-cluster.versions.flux2.chart" -}}2.18.3{{- end -}}

{{- /* renovate: datasource=docker depName=traefik-chart packageName=dhi.io/traefik-chart */ -}}
{{- define "base-cluster.versions.traefik.chart" -}}39.0.8{{- end -}}

{{- /* renovate: datasource=docker depName=cert-manager-chart packageName=dhi.io/cert-manager-chart */ -}}
{{- define "base-cluster.versions.certManager.chart" -}}1.20.2{{- end -}}

{{- /* renovate: datasource=docker depName=external-dns-chart packageName=dhi.io/external-dns-chart */ -}}
{{- define "base-cluster.versions.externalDns.chart" -}}1.20.0{{- end -}}

{{- /* renovate: datasource=docker depName=sealed-secrets-chart packageName=dhi.io/sealed-secrets-chart */ -}}
{{- define "base-cluster.versions.sealedSecrets.chart" -}}0.36.6{{- end -}}

{{- /* renovate: datasource=helm depName=reflector registryUrl=https://emberstack.github.io/helm-charts */ -}}
{{- define "base-cluster.versions.reflector.chart" -}}10.0.42{{- end -}}

{{- /* renovate: datasource=docker depName=metrics-server-chart packageName=dhi.io/metrics-server-chart */ -}}
{{- define "base-cluster.versions.metricsServer.chart" -}}3.13.0{{- end -}}

{{/* Housekeeping. k8s-cleaner (janitor) from its ghcr.io OCI repo; descheduler
     from the kubernetes-sigs HTTPS repo. Neither is DHI-hardened — mirror via
     global.imageRegistry if required. */}}

{{- /* renovate: datasource=docker depName=k8s-cleaner packageName=ghcr.io/gianlucam76/charts/k8s-cleaner */ -}}
{{- define "base-cluster.versions.janitor.chart" -}}0.21.0{{- end -}}

{{- /* renovate: datasource=helm depName=descheduler registryUrl=https://kubernetes-sigs.github.io/descheduler/ */ -}}
{{- define "base-cluster.versions.descheduler.chart" -}}0.33.0{{- end -}}

{{/* Stash (AppsCode) backup operator, from the `appscode` HTTPS repo. Not
     DHI-hardened. */}}

{{- /* renovate: datasource=helm depName=stash registryUrl=https://charts.appscode.com/stable versioning=loose */ -}}
{{- define "base-cluster.versions.stash.chart" -}}v2025.10.17{{- end -}}

{{/* Observability stack. Mimir and k8s-monitoring come from the upstream
     grafana HelmRepository because DHI does not mirror either; all others
     are pinned DHI charts. */}}

{{- /* renovate: datasource=helm depName=mimir-distributed registryUrl=https://grafana.github.io/helm-charts */ -}}
{{- define "base-cluster.versions.mimir.chart" -}}6.0.6{{- end -}}

{{- /* renovate: datasource=docker depName=loki-chart packageName=dhi.io/loki-chart */ -}}
{{- define "base-cluster.versions.loki.chart" -}}13.7.2{{- end -}}

{{- /* renovate: datasource=docker depName=tempo-chart packageName=dhi.io/tempo-chart */ -}}
{{- define "base-cluster.versions.tempo.chart" -}}2.1.0{{- end -}}

{{- /* renovate: datasource=docker depName=grafana-chart packageName=dhi.io/grafana-chart */ -}}
{{- define "base-cluster.versions.grafana.chart" -}}12.3.2{{- end -}}

{{/* k8s-monitoring bundles the Alloy Operator (alloy-metrics/alloy-singleton/
     alloy-logs) plus kube-state-metrics and node-exporter as its own
     telemetryServices toggles. */}}

{{- /* renovate: datasource=helm depName=k8s-monitoring registryUrl=https://grafana.github.io/helm-charts */ -}}
{{- define "base-cluster.versions.k8sMonitoring.chart" -}}4.4.0{{- end -}}

{{- /* renovate: datasource=docker depName=opentelemetry-collector-chart packageName=dhi.io/opentelemetry-collector-chart */ -}}
{{- define "base-cluster.versions.otelCollector.chart" -}}0.154.0{{- end -}}

{{/* IngressMonitorController (Stakater) — reconciles EndpointMonitor CRs into
     UptimeRobot monitors. Chart from the `stakater` HTTPS repo; image from
     ghcr.io/stakater (not DHI-hardened). */}}

{{- /* renovate: datasource=helm depName=ingressmonitorcontroller registryUrl=https://stakater.github.io/stakater-charts */ -}}
{{- define "base-cluster.versions.ingressMonitor.chart" -}}2.2.13{{- end -}}
