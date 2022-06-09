{{- define "4allportal.mail.renderObject" -}}
{{- $map := .object -}}
{{- $label := .label -}}
{{- range $key, $val := $map -}}
  {{- $sublabel := list $label (regexReplaceAll "([[:upper:]])" $key "_$1" | lower) | join "_" | upper -}}
  {{- if kindOf $val | eq "map" -}}
    {{- include "4allportal.mail.renderObject" (dict "object" $val "label" $sublabel) | nindent 0 -}}
  {{- else -}}
- name: {{ $sublabel | quote }}
  value: {{ $val | quote }}
{{ end -}}
{{- end -}}
{{- end -}}
