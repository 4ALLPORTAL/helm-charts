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

{{- define "4allportal.fourallportal.database.jdbcUrl" -}}
{{- $jdbc := default "" $.Values.fourAllPortal.database.existing.jdbcUrl -}}
{{- if eq $jdbc "" -}}
jdbc:sqlserver://{{ $.Values.fourAllPortal.database.existing.host }}{{ if not (empty $.Values.fourAllPortal.database.existing.port) }}:{{ $.Values.fourAllPortal.database.existing.port }}{{ end }};databaseName={{ $.Values.fourAllPortal.database.existing.name }};encrypt=true;trustServerCertificate=false
{{- else -}}
{{- if not (hasPrefix "jdbc:sqlserver://" $jdbc) -}}
{{- fail "fourAllPortal.database.existing.jdbcUrl must start with 'jdbc:sqlserver://'" -}}
{{- end -}}
{{ $jdbc }}
{{- end -}}
{{- end -}}

{{- define "fourAllPortal.env.javaOpts" -}}
{{- range $name, $value := .Values.fourAllPortal.env -}}
{{- if eq "JAVA_OPTS" $name -}}
{{ $value }}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "fourAllPortal.env.derivateOpts" -}}
{{- range $name, $value := .Values.fourAllPortal.env -}}
{{- if eq "DERIVATESERVICE_JAVA_OPTIONS" $name -}}
{{ $value }}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "fourAllPortal.env.derivateDebugOpts" -}}
{{- range $name, $value := .Values.fourAllPortal.env -}}
{{- if eq "DERIVATESERVICE_DEBUG_JAVA_OPTIONS" $name -}}
{{ $value }}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Helper functions for secret references instead of clear text references for data
*/}}

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

{{- define "4allportal.fourallportal.database.existing.secret.name" -}}
{{- if .Values.fourAllPortal.database.existing.secret -}}
{{- if and (not (empty .Values.fourAllPortal.database.existing.secret.name)) (not (empty .Values.fourAllPortal.database.existing.secret.key)) -}}
{{ .Values.fourAllPortal.database.existing.secret.name }}
{{- else -}}
{{ include "common.secrets.name" (dict "existingSecret" .Values.fourAllPortal.database.existing.existingSecret "defaultNameSuffix" "database" "context" $) }}
{{- end -}}
{{- else if and .Values.maxscale.mariadb.existingSecret (ne .Values.maxscale.mariadb.existingSecret "") -}}
{{ .Values.maxscale.mariadb.existingSecret }}
{{- else -}}
{{ include "common.secrets.name" (dict "existingSecret" .Values.fourAllPortal.database.existing.existingSecret "defaultNameSuffix" "database" "context" $) }}
{{- end -}}
{{- end -}}

{{- define "4allportal.fourallportal.database.existing.secret.key" -}}
{{- if .Values.fourAllPortal.database.existing.secret -}}
{{- if and (not (empty .Values.fourAllPortal.database.existing.secret.name)) (not (empty .Values.fourAllPortal.database.existing.secret.key)) -}}
{{ .Values.fourAllPortal.database.existing.secret.key }}
{{- else -}}
{{ include "common.secrets.key" (dict "existingSecret" .Values.fourAllPortal.database.existing.existingSecret "key" "password") }}
{{- end -}}
{{- else if and .Values.maxscale.mariadb.existingSecret (ne .Values.maxscale.mariadb.existingSecret "") -}}
mariadb-root-password
{{- else -}}
{{ include "common.secrets.key" (dict "existingSecret" .Values.fourAllPortal.database.existing.existingSecret "key" "password") }}
{{- end -}}
{{- end -}}

{{- define "4allportal.fourallportal.database.operator.secretName" -}}
{{- if ne .Values.fourAllPortal.database.operator.secretName "" -}}
{{ .Values.fourAllPortal.database.operator.secretName | quote }}
{{- else -}}
{{ printf "%s%s" .Release.Name "-databaseuser-secret" | quote }}
{{- end -}}
{{- end -}}

{{- define "4allportal.webdav.secretName" -}}
{{- if ne .Values.webdav.secretName "" -}}
{{ .Values.webdav.secretName }}
{{- else -}}
{{ include "common.secrets.name" (dict "existingSecret" (dict) "defaultNameSuffix" "webdav" "context" $) }}
{{- end -}}
{{- end -}}

{{- define "4allportal.samba.secret.name" -}}
{{- if and (ne .Values.samba.secret.name "") (ne .Values.samba.secret.key "") -}}
{{ .Values.samba.secret.name }}
{{- else -}}
{{ include "common.secrets.name" (dict "existingSecret" (dict) "defaultNameSuffix" "samba" "context" $) }}
{{- end -}}
{{- end -}}

{{- define "4allportal.samba.secret.key" -}}
{{- if and (ne .Values.samba.secret.name "") (ne .Values.samba.secret.key "") -}}
{{ .Values.samba.secret.key }}
{{- else -}}
users
{{- end -}}
{{- end -}}

{{- define "4allportal.backup.mysql.secretName" -}}
{{- if ne .Values.backups.mysql.secretName "" -}}
{{ .Values.backups.mysql.secretName }}
{{- else -}}
{{ include "common.secrets.name" (dict "existingSecret" (dict) "defaultNameSuffix" "mysql-backup" "context" $) }}
{{- end -}}
{{- end -}}

{{- define "4allportal.backup.volumes.secretName" -}}
{{- if ne .Values.backups.volumes.secretName "" -}}
{{ .Values.backups.volumes.secretName }}
{{- else -}}
{{ include "common.secrets.name" (dict "existingSecret" (dict) "defaultNameSuffix" "backup" "context" $) }}
{{- end -}}
{{- end -}}

{{/*
Other functions, split for readability of secret ref helpers
*/}}

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
