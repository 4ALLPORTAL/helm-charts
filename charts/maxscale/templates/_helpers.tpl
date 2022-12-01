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
