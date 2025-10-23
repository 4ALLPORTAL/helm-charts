{{- define "4allportal.fourallportal.persistence.assets.mount" -}}
      {{- if or $.Values.global.persistence.enabled $.Values.fourAllPortal.persistence.assets.enabled -}}
persistentVolumeClaim:
        {{- if $.Values.fourAllPortal.persistence.assets.existingClaim }}
  claimName: {{ $.Values.fourAllPortal.persistence.assets.existingClaim }}
        {{- else }}
  claimName:  "{{ include "common.names.fullname" $ }}-assets"
          {{- end }}
      {{- else -}}
emptyDir: {}
    {{- end -}}
{{- end -}}

{{- define "4allportal.fourallportal.persistence.config.mount" -}}
      {{- if or $.Values.global.persistence.enabled $.Values.fourAllPortal.persistence.config.enabled -}}
persistentVolumeClaim:
        {{- if .Values.fourAllPortal.persistence.config.existingClaim }}
  claimName: {{ .Values.fourAllPortal.persistence.config.existingClaim }}
        {{- else }}
  claimName:  "{{ include "common.names.fullname" . }}-config"
          {{- end }}
      {{- else -}}
emptyDir: {}
        {{- end -}}
{{- end -}}

{{- define "4allportal.fourallportal.persistence.storage.mount" -}}
      {{- if or $.Values.global.persistence.enabled $.Values.fourAllPortal.persistence.storage.enabled -}}
persistentVolumeClaim:
        {{- if .Values.fourAllPortal.persistence.storage.existingClaim }}
  claimName: {{ .Values.fourAllPortal.persistence.storage.existingClaim }}
        {{- else }}
  claimName:  "{{ include "common.names.fullname" . }}-storage"
          {{- end }}
      {{- else -}}
emptyDir: {}
        {{- end -}}
{{- end -}}

{{- define "fourAllPortal.checkPersistence" -}}
{{- $persistenceTypes := list "config" "assets" "storage" -}}
{{- $allValid := true -}}
{{- range $persistenceTypes }}
  {{- $persistence := index $.Values.fourAllPortal.persistence . -}}
  {{- $enabled := or $.Values.global.persistence.enabled $persistence.enabled -}}
  {{- $isRWX := eq $persistence.accessMode "ReadWriteMany" -}}
  {{- if and $enabled (not $isRWX) }}
    {{- $allValid = false -}}
  {{- end }}
{{- end }}
{{- $allValid -}}
{{- end -}}