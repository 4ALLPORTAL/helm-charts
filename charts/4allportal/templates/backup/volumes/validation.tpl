{{- if and (or $.Values.global.persistence.enabled $.Values.fourAllPortal.persistence.assets.enabled) .Values.backups.volumes.enabled -}}
{{- range $volume := list "config" "assets" -}}
{{- if not (eq (index (index $.Values.fourAllPortal.persistence $volume) "accessMode") "ReadWriteMany") -}}
{{- fail (printf "To enable backups, the volume '%s' must be ReadWriteMany" $volume) -}}
{{- end -}}
{{- end -}}
{{- end -}}
