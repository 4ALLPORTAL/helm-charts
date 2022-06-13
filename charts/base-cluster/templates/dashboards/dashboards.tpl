{{- define "base-cluster.dashboards.configmap" -}}
{{- $context := .context -}}
{{- if $context.Values.monitoring.prometheus.enabled -}}
{{- range $path, $bytes := $context.Files.Glob (printf "dashboards/%s/*.json" .folder) -}}
{{- $pathList := splitList "/" $path -}}
{{- $folder := index $pathList 1 -}}
{{- $fileName := index $pathList 2 }}
{{- $name := $fileName | trimSuffix ".json" -}}
apiVersion: v1
kind: ConfigMap
metadata:
  name: "{{ include "common.names.fullname" $context }}-{{ $folder }}-{{ $name }}"
  namespace: monitoring
  labels: {{- include "common.labels.standard" $context | nindent 4 }}
    grafana_dashboard: "1"
    app.kubernetes.io/component: {{ printf "%s-%s" $folder $name  }}
data:
  "{{ $folder }}-{{ $fileName }}": |-
    {{- $context.Files.Get $path | nindent 4 }}
---
{{ end -}}
{{- end }}
{{- end -}}
