{{- if gt (len .Values.mariadb.rootUser.password) 32 -}}
{{- fail "`.mariadb.rootUser.password` cannot be longer than 32 characters" -}}
{{- end -}}
{{- if gt (len .Values.mariadb.galera.mariabackup.password) 32 -}}
{{- fail "`.mariadb.galera.mariabackup.password` cannot be longer than 32 characters" -}}
{{- end -}}
{{- if gt (len .Values.mariadb.db.password) 32 -}}
{{- fail "`.mariadb.db.password` cannot be longer than 32 characters" -}}
{{- end -}}

