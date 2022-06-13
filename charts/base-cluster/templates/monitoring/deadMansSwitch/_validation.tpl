{{- if .Values.monitoring.deadMansSwitch.enabled }}
{{- if not .Values.monitoring.deadMansSwitch.apiKey -}}
{{- fail "You need to provide the `.Values.monitoring.deadMansSwitch.apiKey`" -}}
{{- end -}}

{{- if not .Values.monitoring.deadMansSwitch.pingKey -}}
{{- fail "You need to provide the `.Values.monitoring.deadMansSwitch.pingKey`" -}}
{{- end -}}
{{- end -}}
