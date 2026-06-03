{{/*
Common labels — applied to every object emitted by this chart.
The Bitnami `common` subchart used to provide this; we inline a small version
here so the chart has no external Helm dependencies.
*/}}
{{- define "base-cluster.labels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end -}}

{{/*
Stable selector labels — never change across upgrades.
*/}}
{{- define "base-cluster.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
The fully-qualified base domain for this cluster, e.g. "gt-office.4allportal.com".
*/}}
{{- define "base-cluster.domain" -}}
{{ required "global.clusterName is required" .Values.global.clusterName }}.{{ required "global.baseDomain is required" .Values.global.baseDomain }}
{{- end -}}

{{/*
Speedtest hostname.
*/}}
{{- define "base-cluster.speedtest.host" -}}
{{- required "speedtest.host is required when speedtest is enabled" .Values.speedtest.host -}}.{{ include "base-cluster.domain" . }}
{{- end -}}

{{/*
Grafana hostname.
*/}}
{{- define "base-cluster.grafana.host" -}}
{{- required "monitoring.grafana.host is required when grafana is enabled" .Values.monitoring.grafana.host -}}.{{ include "base-cluster.domain" . }}
{{- end -}}

{{/*
In-cluster DNS suffix (e.g. cluster.local). Overridable via global.clusterDomain.
*/}}
{{- define "base-cluster.clusterDomain" -}}
{{- default "cluster.local" .Values.global.clusterDomain -}}
{{- end -}}

{{/*
Resolve a registry: explicit per-component overrides win, otherwise the global
imageRegistry pull-through, otherwise empty (Docker Hub default).
*/}}
{{- define "base-cluster.speedtest.image" -}}
{{- $reg := default .Values.global.imageRegistry .Values.speedtest.image.registry -}}
{{- $ref := printf "%s:%s" .Values.speedtest.image.repository .Values.speedtest.image.tag -}}
{{- if $reg -}}
{{- $ref = printf "%s/%s" $reg $ref -}}
{{- end -}}
{{- with .Values.speedtest.image.digest -}}
{{- $ref = printf "%s@%s" $ref . -}}
{{- end -}}
{{ $ref }}
{{- end -}}

{{/*
NetworkPolicy mode resolver. Returns "cilium" or "none".
- auto:   detect Cilium via the cluster's installed APIs.
- cilium: always return cilium (use when you're about to install Cilium and
          want the policies to land before the controller).
- none:   never emit NetworkPolicies.
*/}}
{{- define "base-cluster.networkPolicy.type" -}}
{{- $mode := .Values.global.networkPolicy.type -}}
{{- if eq $mode "auto" -}}
  {{- if .Capabilities.APIVersions.Has "cilium.io/v2/CiliumNetworkPolicy" -}}
cilium
  {{- else -}}
none
  {{- end -}}
{{- else -}}
{{- $mode -}}
{{- end -}}
{{- end -}}

{{/*
Render a dict as YAML, dropping keys whose value is empty. Used by
NetworkPolicy templates so users can blank out a label without leaving an
empty selector match in the rendered output.
*/}}
{{- define "base-cluster.dict.filterEmpty" -}}
{{- $out := dict -}}
{{- range $k, $v := . -}}
  {{- if $v -}}{{- $out = set $out $k $v -}}{{- end -}}
{{- end -}}
{{ $out | toYaml }}
{{- end -}}
