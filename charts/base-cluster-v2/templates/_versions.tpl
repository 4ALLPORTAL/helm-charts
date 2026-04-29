{{/*
Single source of truth for upstream chart versions managed by this chart.

Bump the constants here when upgrading a component, and the corresponding
HelmRelease will pick it up. Pin EXACT versions — never `x.x.x` ranges — so
chart bumps are explicit, reviewable PRs.

Versions verified against upstream releases on 2026-04-15:
  - flux2 community chart: https://github.com/fluxcd-community/helm-charts/releases
  - traefik chart:         https://github.com/traefik/traefik-helm-chart/releases
  - cert-manager:          https://github.com/cert-manager/cert-manager/releases
  - external-dns chart:    https://kubernetes-sigs.github.io/external-dns/index.yaml
*/}}

{{- define "base-cluster.versions.flux2.chart" -}}2.18.3{{- end -}}

{{- define "base-cluster.versions.traefik.chart" -}}39.0.7{{- end -}}

{{- define "base-cluster.versions.certManager.chart" -}}v1.20.2{{- end -}}

{{- define "base-cluster.versions.externalDns.chart" -}}1.20.0{{- end -}}

{{/*
Image digests for container images used by HelmRelease values.
When bumping a chart version, update the corresponding digest from the
running cluster: kubectl get pods -A -o jsonpath='...' | grep <image>
*/}}
{{- define "base-cluster.digests.traefik" -}}sha256:171c9c3565b29f6c133f1c1b43c5d4e5853415198e9e1078c001f8702ff66aec{{- end -}}
{{- define "base-cluster.digests.certManager.controller" -}}sha256:fe0623d7d04a382c888f03343a3a2da716e0d96ad3d5d790c0ebcbcb2a4329a5{{- end -}}
{{- define "base-cluster.digests.certManager.cainjector" -}}sha256:6f5a644135887b2aa7d5cc145072fa56421560e3586ff1f184358022d490f4e1{{- end -}}
{{- define "base-cluster.digests.certManager.webhook" -}}sha256:baf651128b9f05c426cbd5e60e2036bf382c99ca270f49d0757d6f7d2452f4e5{{- end -}}
{{- define "base-cluster.digests.externalDns" -}}sha256:ddc7f4212ed09a21024deb1f470a05240837712e74e4b9f6d1f2632ff10672e7{{- end -}}
