{{- if not (eq (without (list .Values.maxscale.enabled (not (empty .Values.fourAllPortal.database.existing.host))) false | len) 1) -}}
{{- fail "Need to use either mariadb or an existing database" -}}
{{- end -}}

{{- if and .Release.IsInstall .Values.maxscale.enabled -}}
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

{{- if eq .Values.fourAllPortal.database.operator.enabled -}}
{{- if eq .Values.fourAllPortal.database.operator.user "CHANGEME" -}}
{{- fail "You need to change fourAllPortal.database.operator.user" -}}
{{- end -}}

{{- if eq .Values.fourAllPortal.database.operator.password "CHANGEME" -}}
{{- fail "You need to change fourAllPortal.database.operator.password" -}}
{{- end -}}

{{- if eq .Values.fourAllPortal.database.operator.databaseName "CHANGEME" -}}
{{- fail "You need to change fourAllPortal.database.operator.databaseName" -}}
{{- end -}}

{{- if eq .Values.fourAllPortal.database.operator.databaseRef "CHANGEME" -}}
{{- fail "You need to change fourAllPortal.database.operator.databaseRef" -}}
{{- end -}}
{{- end -}}