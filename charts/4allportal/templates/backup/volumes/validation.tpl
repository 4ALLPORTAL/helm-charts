{{- if and (or $.Values.global.persistence.enabled $.Values.fourAllPortal.persistence.assets.enabled $.Values.fourAllPortal.persistence.storage.enabled) .Values.backups.volumes.enabled -}}
{{- if $.Values.global.persistence.useCombinedVolumes }}
{{- if not (eq (index (index $.Values.fourAllPortal.persistence "storage") "accessMode") "ReadWriteMany") -}}
{{- fail (printf "To enable backups, the volume storage must be ReadWriteMany") -}}
{{- else -}}
{{- range $volume := list "config" "assets" -}}
{{- if not (eq (index (index $.Values.fourAllPortal.persistence $volume) "accessMode") "ReadWriteMany") -}}
{{- fail (printf "To enable backups, the volume '%s' must be ReadWriteMany" $volume) -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}
