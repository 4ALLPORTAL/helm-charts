{{/*
Default values for the upstream stash chart. helmrelease.yaml deep-merges
backup.values over these, so an override replaces single keys without
dropping the rest (e.g. one stash-catalog addon re-enabled).
*/}}
{{- define "base-cluster.backup.stashValues" -}}
{{- $edition := .Values.backup.edition -}}
global:
  {{- with .Values.global.imageRegistry }}
  registry: {{ printf "%s/stashed" . | quote }}
  {{- end }}
  licenseSecretName: {{ required "backup.licenseSecretName is required when backup.enabled is true" .Values.backup.licenseSecretName | quote }}
  {{- if eq $edition "enterprise" }}
  taskQueue:
    enabled: {{ .Values.backup.taskQueue.enabled }}
    maxConcurrentSessions: {{ .Values.backup.taskQueue.maxConcurrentSessions }}
  {{- end }}
features:
  {{ $edition }}: true
{{- if eq $edition "enterprise" }}
stash-catalog:
  {{- range list "elasticsearch" "etcd" "kubedump" "mariadb" "mongodb" "mysql" "nats" "perconaxtradb" "postgres" "redis" "vault" }}
  {{ . }}:
    enabled: false
  {{- end }}
{{- end }}
stash-{{ $edition }}:
  criticalAddon: true
  monitoring:
    agent: {{ .Values.monitoring.enabled | ternary "prometheus.io/operator" "none" | quote }}
    backup: true
    operator: true
  apiserver:
    enableValidatingWebhook: false
    servingCerts:
      generate: true
{{- end -}}
