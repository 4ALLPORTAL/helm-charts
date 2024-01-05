{{/* vim: set filetype=mustache: */}}

{{- define "fourAllPortal.system.api.key " -}}
{{ (printf "%s-%s-%s-%s-%s" (randAlphaNum 8) (randAlphaNum 4) (randAlphaNum 4) (randAlphaNum 4) (randAlphaNum 12)) | lower | quote}}
{{- end -}}


{{- define "4allportal.fourallportal.database.user" -}}
{{- if .Values.maxscale.enabled -}}
{{- .Values.maxscale.mariadb.db.user -}}
{{- else -}}
{{- required "MySQL deployment is disabled, please provide a user for the existing database" .Values.fourAllPortal.database.existing.user -}}
{{- end -}}
{{- end -}}

{{- define  "4allportal.fourallportal.database.password" -}}
{{- if .Values.maxscale.enabled -}}
{{- required "You must provide a password for the bundled MariaDB deployment" .Values.maxscale.mariadb.db.password -}}
{{- else -}}
{{- required "You must provide a password for the existing database" .Values.fourAllPortal.database.existing.password -}}
{{- end -}}
{{- end -}}

{{- define  "4allportal.fourallportal.database.type" -}}
{{- if .Values.maxscale.enabled -}}
mariadb
{{- else -}}
{{- required "You must provide a type for the existing database" .Values.fourAllPortal.database.existing.type -}}
{{- end -}}
{{- end -}}

{{- define  "4allportal.fourallportal.database.host" -}}
{{- if and .Values.maxscale.enabled -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "maxscale" "chartValues" .Values.maxscale "context" $) -}}
{{- else -}}
{{- required "Bundled DB deployment is disabled, please provide a host for the existing database" (tpl .Values.fourAllPortal.database.existing.host .) -}}
{{- end -}}
{{- end -}}

{{- define  "4allportal.fourallportal.database.port" -}}
{{- if or .Values.maxscale.enabled (and (not .Values.fourAllPortal.database.existing.port) ((list "mysql" "mariadb") | has (include "4allportal.fourallportal.database.type" .))) -}}
3306
{{- else -}}
{{- required "Bundled DB deployment is disabled, please provide a port for the existing database" .Values.fourAllPortal.database.existing.port -}}
{{- end -}}
{{- end -}}

{{- define  "4allportal.fourallportal.database.name" -}}
{{- if .Values.maxscale.enabled -}}
{{- .Values.maxscale.mariadb.db.name -}}
{{- else -}}
{{- required "MySQL deployment is disabled, please provide a name for the existing database" .Values.fourAllPortal.database.existing.name -}}
{{- end -}}
{{- end -}}

{{- define "4allportal.isHa" -}}
{{- and (eq (include "4allportal.component.isHa" .Values.fourAllPortal) "true") (or (not .Values.maxscale.enabled) (and (eq (include "4allportal.component.isHa" .Values.maxscale) "true") (eq (include "4allportal.component.isHa" .Values.maxscale.mariadb) "true"))) -}}
{{- end -}}

{{- define "4allportal.component.isHa" -}}
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
