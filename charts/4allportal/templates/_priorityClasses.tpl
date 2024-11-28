{{- define "4allportal.priorityClassName" -}}
{{- if or .custom .global.priorityClassName -}}
priorityClassName: {{ .custom | default .global.priorityClassName -}}
{{- end -}}
{{- end -}}

{{- define "4allportal.fourAllPortal.priorityClassName" -}}
{{- include "4allportal.priorityClassName" (dict "custom" $.Values.fourAllPortal.priorityClassName "global" $.Values.global) -}}
{{- end -}}

{{- define "4allportal.dreiDRenderer.priorityClassName" -}}
{{- include "4allportal.priorityClassName" (dict "custom" $.Values.dreiDRenderer.priorityClassName "global" $.Values.global) -}}
{{- end -}}

{{- define "4allportal.webdav.priorityClassName" -}}
{{- include "4allportal.priorityClassName" (dict "custom" $.Values.webdav.priorityClassName "global" $.Values.global) -}}
{{- end -}}

{{- define "4allportal.samba.priorityClassName" -}}
{{- include "4allportal.priorityClassName" (dict "custom" $.Values.samba.priorityClassName "global" $.Values.global) -}}
{{- end -}}