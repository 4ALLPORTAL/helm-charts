{{- if not (eq (without (list .Values.maxscale.enabled .Values.fourAllPortal.database.operator.enabled (or (not (empty .Values.fourAllPortal.database.existing.host)) (not (empty .Values.fourAllPortal.database.existing.jdbcUrl)))) false | len) 1) -}}
{{- fail "Exactly one of maxscale.enabled, fourAllPortal.database.operator.enabled, or fourAllPortal.database.existing.(host|jdbcUrl) must be set." -}}
{{- end -}}

{{- if and .Release.IsInstall .Values.maxscale.enabled -}}
{{- if not .Values.maxscale.mariadb.existingSecret -}}
{{- if eq .Values.maxscale.mariadb.rootUser.password "CHANGEME" -}}
{{- fail "You need to change mariadb.rootUser.password" -}}
{{- end -}}

{{- if eq .Values.maxscale.mariadb.db.password "CHANGEME" -}}
{{- fail "You need to change mariadb.db.password" -}}
{{- end -}}

{{- if eq .Values.maxscale.mariadb.galera.mariabackup.password "CHANGEME" -}}
{{- fail "You need to change mariadb.galera.mariabackup.password" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- if and (eq .Values.fourAllPortal.database.operator.enabled true) (eq .Values.fourAllPortal.database.operator.secretName "") -}}
{{- if eq .Values.fourAllPortal.database.operator.user "CHANGEME" -}}
{{- fail "You need to change fourAllPortal.database.operator.user" -}}
{{- end -}}

{{- if and (eq .Values.fourAllPortal.database.operator.password "CHANGEME") (eq .Values.fourAllPortal.database.operator.secretName "") -}}
{{- fail "You need to change fourAllPortal.database.operator.password" -}}
{{- end -}}

{{- if eq .Values.fourAllPortal.database.operator.databaseName "CHANGEME" -}}
{{- fail "You need to change fourAllPortal.database.operator.databaseName" -}}
{{- end -}}

{{- if eq .Values.fourAllPortal.database.operator.databaseRef "CHANGEME" -}}
{{- fail "You need to change fourAllPortal.database.operator.databaseRef" -}}
{{- end -}}
{{- end -}}

{{- if (ne "" .Values.fourAllPortal.systemApiKey) -}}
{{- if not (regexMatch "^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$" .Values.fourAllPortal.systemApiKey) -}}
{{- fail "You need to set fourAllPortal.systemApiKey in uuidv4 format or leave blank" -}}
{{- end -}}
{{- end -}}

{{- if eq .Values.samba.enabled true -}}
{{- if eq .Values.samba.adminPassword "CHANGEME" -}}
{{- fail "You need to change samba.adminPassword" -}}
{{- end -}}
{{- end -}}