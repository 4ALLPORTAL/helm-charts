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
{{- if .Values.global.persistence.useCombinedVolumes }}
    {{- if or
      (not (or .Values.global.persistence.enabled .Values.fourAllPortal.persistence.storage.enabled))
      (eq .Values.fourAllPortal.persistence.storage.accessMode "ReadWriteMany")
     -}}
    true
    {{- else }}
    false
    {{- end }}
{{- else }}
    {{- if (and
        (or
          (not (or .Values.global.persistence.enabled .Values.fourAllPortal.persistence.config.enabled))
          (eq .Values.fourAllPortal.persistence.config.accessMode "ReadWriteMany")
        )
        (or
          (not (or .Values.global.persistence.enabled .Values.fourAllPortal.persistence.assets.enabled))
          (eq .Values.fourAllPortal.persistence.assets.accessMode "ReadWriteMany")
        )
    ) -}}
    true
    {{- else }}
    false
    {{- end }}
{{- end }}
{{- end -}}
