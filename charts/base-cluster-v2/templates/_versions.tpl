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
