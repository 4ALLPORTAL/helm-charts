{{/*
Single source of truth for upstream chart versions managed by this chart.

Bump the constants here when upgrading a component, and the corresponding
HelmRelease will pick it up. Pin EXACT versions — never `x.x.x` ranges — so
chart bumps are explicit, reviewable PRs.

All charts are sourced from DHI (dhi.io) except flux2 (fluxcd-community).
*/}}

{{- define "base-cluster.versions.cilium.chart" -}}1.19.3{{- end -}}

{{- define "base-cluster.versions.flux2.chart" -}}2.18.3{{- end -}}

{{- define "base-cluster.versions.traefik.chart" -}}39.0.8{{- end -}}

{{- define "base-cluster.versions.certManager.chart" -}}1.20.2{{- end -}}

{{- define "base-cluster.versions.externalDns.chart" -}}1.20.0{{- end -}}

{{- define "base-cluster.versions.sealedSecrets.chart" -}}0.36.6{{- end -}}

{{- define "base-cluster.versions.reflector.chart" -}}10.0.42{{- end -}}

{{- define "base-cluster.versions.metricsServer.chart" -}}3.13.0{{- end -}}

{{/* Observability stack. Mimir comes from the upstream grafana HelmRepository
     because DHI does not mirror it; all others are pinned DHI charts. */}}

{{- define "base-cluster.versions.alloy.chart" -}}1.8.1{{- end -}}

{{- define "base-cluster.versions.mimir.chart" -}}6.0.6{{- end -}}

{{- define "base-cluster.versions.loki.chart" -}}13.7.2{{- end -}}

{{- define "base-cluster.versions.tempo.chart" -}}2.1.0{{- end -}}

{{- define "base-cluster.versions.grafana.chart" -}}12.3.2{{- end -}}

{{- define "base-cluster.versions.nodeExporter.chart" -}}4.55.0{{- end -}}

{{- define "base-cluster.versions.kubeStateMetrics.chart" -}}7.3.0{{- end -}}

{{- define "base-cluster.versions.otelCollector.chart" -}}0.154.0{{- end -}}
