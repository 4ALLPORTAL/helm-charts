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
