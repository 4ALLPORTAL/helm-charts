{{- if and (not .Values.enterpriseLicensed) (or (and (not .Values.hpa.enabled) (gt (.Values.replicas | int) 2)) (and .Values.hpa.enabled (or (gt (.Values.hpa.minReplicas | int) 2) (gt (.Values.hpa.maxReplicas | int) 2)))) -}}
{{- fail "To have more than 2 replicas, you need an enterprise license for MaxScale. If that is the case, set `.enterpriseLicensed` to `true`" -}}
{{- end -}}
