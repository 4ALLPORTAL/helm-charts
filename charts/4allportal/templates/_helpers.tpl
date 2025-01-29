{{/* vim: set filetype=mustache: */}}

{{- define "4allportal.fourAllPortal.systemApiKey" -}}
{{- if (eq "" .Values.fourAllPortal.systemApiKey) -}}
{{ printf uuidv4 }}
{{- else -}}
{{ printf .Values.fourAllPortal.systemApiKey }}
{{- end -}}
{{- end -}}

{{- define "4allportal.fourallportal.database.user" -}}
{{- if .Values.maxscale.enabled -}}
{{- .Values.maxscale.mariadb.db.user -}}
{{- else -}}
{{- if .Values.fourAllPortal.database.operator.enabled -}}
{{- required "MariaDB deployment is disabled and operator is enabled, please provide a username." .Values.fourAllPortal.database.operator.user -}}
{{- else -}}
{{- required "MariaDB deployment is disabled, please provide a user for the existing database" .Values.fourAllPortal.database.existing.user -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define  "4allportal.fourallportal.database.password" -}}
{{- if .Values.maxscale.enabled -}}
{{- required "You must provide a password for the bundled MariaDB deployment" .Values.maxscale.mariadb.db.password -}}
{{- else -}}
{{- if .Values.fourAllPortal.database.operator.enabled -}}
{{- if eq .Values.fourAllPortal.database.operator.secretName "" -}}
{{- required "You must provide a password for the database user to be created" .Values.fourAllPortal.database.operator.password }}
{{- end -}}
{{- else -}}
{{- required "You must provide a password for the existing database" .Values.fourAllPortal.database.existing.password -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define  "4allportal.fourallportal.database.type" -}}
{{- if .Values.maxscale.enabled -}}
mariadb
{{- else -}}
{{- if .Values.fourAllPortal.database.operator.enabled }}
{{- else -}}
{{- required "You must provide a type for the existing database" .Values.fourAllPortal.database.existing.type -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define  "4allportal.fourallportal.database.host" -}}
{{- if and .Values.maxscale.enabled -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "maxscale" "chartValues" .Values.maxscale "context" $) -}}
{{- else -}}
{{- if .Values.fourAllPortal.database.operator.enabled }}
{{- else -}}
{{- required "Bundled DB deployment is disabled, please provide a host for the existing database" (tpl .Values.fourAllPortal.database.existing.host .) -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define  "4allportal.fourallportal.database.port" -}}
{{- if .Values.fourAllPortal.database.operator.enabled }}
{{- else if or .Values.maxscale.enabled (and (not .Values.fourAllPortal.database.existing.port) ((list "mysql" "mariadb") | has (include "4allportal.fourallportal.database.type" .))) -}}
3306
{{- else if .Values.fourAllPortal.database.existing.port }}
{{- .Values.fourAllPortal.database.existing.port -}}
{{- else }}
{{- required "Bundled DB deployment is disabled, please provide a port for the existing database" .Values.fourAllPortal.database.existing.port -}}
{{- end -}}
{{- end -}}

{{- define  "4allportal.fourallportal.database.name" -}}
{{- if .Values.maxscale.enabled -}}
{{- .Values.maxscale.mariadb.db.name -}}
{{- else -}}
{{- if .Values.fourAllPortal.database.operator.enabled }}
{{- required "MariaDB deployment is disabled and operator is enabled, please provide a name for the database" .Values.fourAllPortal.database.operator.databaseName -}}
{{- else -}}
{{- required "MariaDB deployment is disabled, please provide a name for the existing database" .Values.fourAllPortal.database.existing.name -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "4allportal.fourallportal.general.secret.name" -}}
{{- if and (ne .Values.fourAllPortal.general.admin.secret.name "") (ne .Values.fourAllPortal.general.admin.secret.key "") -}}
{{ .Values.fourAllPortal.general.admin.secret.name }}
{{- else -}}
{{ include "common.secrets.name" (dict "existingSecret" (dict) "defaultNameSuffix" "general" "context" $) }}
{{- end -}}
{{- end -}}

{{- define "4allportal.fourallportal.general.secret.key" -}}
{{- if and (ne .Values.fourAllPortal.general.admin.secret.name "") (ne .Values.fourAllPortal.general.admin.secret.key "") -}}
{{ .Values.fourAllPortal.general.admin.secret.key }}
{{- else -}}
{{ include "common.secrets.key" (dict "existingSecret" (dict) "key" "admin-password") }}
{{- end -}}
{{- end -}}

{{- define "4allportal.fourallportal.mail.secret.name" -}}
{{- if and (ne .Values.fourAllPortal.mail.secret.name "") (ne .Values.fourAllPortal.mail.secret.key "") -}}
{{ .Values.fourAllPortal.mail.secret.name }}
{{- else -}}
{{ include "common.secrets.name" (dict "existingSecret" (dict) "defaultNameSuffix" "mail" "context" $) }}
{{- end -}}
{{- end -}}

{{- define "4allportal.fourallportal.mail.secret.key" -}}
{{- if and (ne .Values.fourAllPortal.mail.secret.name "") (ne .Values.fourAllPortal.mail.secret.key "") -}}
{{ .Values.fourAllPortal.mail.secret.key }}
{{- else -}}
{{ include "common.secrets.key" (dict "existingSecret" (dict) "key" "mail-password") }}
{{- end -}}
{{- end -}}

{{- define "4allportal.fourallportal.database.operator.secretName" -}}
{{- if ne .Values.fourAllPortal.database.operator.secretName "" -}}
{{ .Values.fourAllPortal.database.operator.secretName | quote }}
{{- else -}}
{{ printf "%s%s" .Release.Name "-databaseuser-secret" | quote }}
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
