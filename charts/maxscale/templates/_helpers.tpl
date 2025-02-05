{{- define "maxscale.isHa" -}}
{{- and (eq (include "maxscale.component.isHa" .Values) "true") (eq (include "maxscale.component.isHa" .Values.mariadb) "true") -}}
{{- end -}}

{{- define "maxscale.component.isHa" -}}
{{- $podDisruptionBudgetEnabled := false -}}
{{- if typeIs "bool" .podDisruptionBudget -}}
    {{- $podDisruptionBudgetEnabled = .podDisruptionBudget -}}
{{ else if .podDisruptionBudget }}
    {{- if hasKey .podDisruptionBudget "create" -}}
        {{- $podDisruptionBudgetEnabled = .podDisruptionBudget.create -}}
    {{- end -}}
{{- end -}}
{{- $hasEnoughReplicas := ge (.replicas | default .replicaCount | int) 2 -}}
{{- if hasKey . "hpa" -}}
    {{- if .hpa.enabled -}}
        {{- $hasEnoughReplicas = ge (.hpa.minReplicas | int) 2 -}}
    {{- end -}}
{{- end -}}
{{- and $podDisruptionBudgetEnabled $hasEnoughReplicas -}}
{{- end -}}

{{- define "maxscale.priorityClassName" -}}
{{- if or .custom .global.priorityClassName -}}
priorityClassName: {{ .custom | default .global.priorityClassName -}}
{{- end -}}
{{- end -}}

{{- define "maxscale.maxscale.priorityClassName" -}}
{{- include "maxscale.priorityClassName" (dict "custom" $.Values.priorityClassName "global" $.Values.global) -}}
{{- end -}}

{{- define "common.networkPolicy.type" -}}
{{- if eq .Values.global.networkPolicy.type "auto" -}}
{{- if .Capabilities.APIVersions.Has "cilium.io/v2/CiliumNetworkPolicy" -}}
cilium
{{- else -}}
none
{{- end -}}
{{- else -}}
{{- .Values.global.networkPolicy.type -}}
{{- end -}}
{{- end -}}

{{- define "common.dict.filterEmptyValues" -}}
{{- $out := dict -}}
{{- range $key, $value := . -}}
{{- if $value -}}
{{- $out = set $out $key $value -}}
{{- end -}}
{{- end -}}
{{ $out | toYaml }}
{{- end -}}

{{- define "maxscale.cnf.cpu.limit" -}}
{{- if hasSuffix "m" .Values.resources.limits.cpu }}
    {{- ceil (divf (trimSuffix "m" .Values.resources.limits.cpu) (1000)) }}
{{- else -}}
    1
{{- end -}}
{{- end -}}

{{- define "maxscale.cnf.memory.limit" -}}
{{- if hasSuffix "Mi" .Values.resources.limits.memory }}
    {{- ceil (mulf (trimSuffix "Mi" .Values.resources.limits.memory) (0.15)) }}Mi
{{- else if hasSuffix "Gi" .Values.resources.limits.memory -}}
    {{- ceil (mulf (trimSuffix "Gi" .Values.resources.limits.memory) (0.15)) }}Gi
{{- else -}}
    {{- fail "Please insert the maxscale ressource limits in Gi or Mi" }}
{{- end -}}
{{- end -}}

{{- define "mariadb.buffer.limit" -}} 
{{- if hasSuffix "Gi" .Values.mariadb.resources.limits.memory }} 
    {{- div (mulf (mulf (trimSuffix "Gi" .Values.mariadb.resources.limits.memory) (1000) ) (8) ) (10) }}M
{{- else if hasSuffix "Mi" .Values.mariadb.resources.limits.memory }}
    {{- div (mulf (trimSuffix "Mi" .Values.mariadb.resources.limits.memory) (8) ) (10) }}M
{{- else }} 
    {{- fail "Please insert the mariadb memory ressource limits in Gi or Mi" }} 
{{- end -}} 
{{- end -}}

{{/*
Define Maxscale Secret Helper Functions
*/}}

{{- define "maxscale.password.secret.name" -}}
{{- if and .Values.mariadb.existingSecret (ne .Values.mariadb.existingSecret "") -}}
{{ .Values.mariadb.existingSecret }}
{{- else -}}
{{ include "common.secrets.name" (dict "existingSecret" (dict) "defaultNameSuffix" "" "context" $) }}
{{- end -}}
{{- end -}}

{{- define "maxscale.password.secret.key" -}}
{{- if and .Values.mariadb.existingSecret (ne .Values.mariadb.existingSecret "") -}}
mariadb-root-password
{{- else -}}
{{ include "common.secrets.key" (dict "existingSecret" (dict) "key" "root-password") }}
{{- end -}}
{{- end -}}