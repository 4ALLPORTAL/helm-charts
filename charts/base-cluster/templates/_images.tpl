{{- define "base-cluster.kubectl.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.global.kubectl.image "global" .Values.global) }}
{{- end -}}

{{- define "base-cluster.helm.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.global.helm.image "global" .Values.global) }}
{{- end -}}
