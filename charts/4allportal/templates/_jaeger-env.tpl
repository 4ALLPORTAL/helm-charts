{{- define "4allportal.tracing.jaeger.env" -}}
{{- if or .local.enabled .Values.global.tracing.enabled }}
{{ $local := set .local.jaeger "reporter" (dict) -}}
{{- $global := set .Values.global.tracing.jaeger "reporter" (dict) -}}
- name: JAEGER_SERVICE_NAME
  value: "{{- $local.serviceName | default $global.serviceName | required "When enabling jaeger tracing, you need to provide a service name" -}}"
{{- if $local.agent.useDaemonSet | default $global.agent.useDaemonSet }}
- name: JAEGER_AGENT_HOST
  valueFrom:
    fieldRef:
      fieldPath: status.hostIP
{{- else }}
{{- with ($local.agent.host | default $global.agent.host) }}
- name: JAEGER_AGENT_HOST
  value: "{{- . -}}"
{{- end }}
{{- end }}
{{- with ($local.agent.port | default $global.agent.port) }}
- name: JAEGER_AGENT_PORT
  value: "{{- . -}}"
{{- end }}
{{- with ($local.endpoint | default $global.endpoint) }}
- name: JAEGER_ENDPOINT
  value: "{{- . -}}"
{{- end }}
{{- with ($local.authToken | default $global.authToken) }}
- name: JAEGER_AUTH_TOKEN
  value: "{{- . -}}"
{{- end }}
{{- with ($local.user | default $global.user) }}
- name: JAEGER_USER
  value: "{{- . -}}"
{{- end }}
{{- with ($local.password | default $global.password) }}
- name: JAEGER_PASSWORD
  value: "{{- . -}}"
{{- end }}
{{- with ($local.propagation | default $global.propagation) }}
- name: JAEGER_PROPAGATION
  value: "{{- . -}}"
{{- end }}
{{- with ($local.reporter.logSpans | default $global.reporter.logSpans) }}
- name: JAEGER_REPORTER_LOG_SPANS
  value: "{{- . -}}"
{{- end }}
{{- with ($local.reporter.maxQueueSize | default $global.reporter.maxQueueSize) }}
- name: JAEGER_REPORTER_MAX_QUEUE_SIZE
  value: "{{- . -}}"
{{- end }}
{{- with ($local.reporter.flushInterval | default $global.reporter.flushInterval) }}
- name: JAEGER_REPORTER_FLUSH_INTERVAL
  value: "{{- . -}}"
{{- end }}
{{- with ($local.sampler.type | default $global.sampler.type) }}
- name: JAEGER_SAMPLER_TYPE
  value: "{{- . -}}"
{{- end }}
{{- with ($local.sampler.param | default $global.sampler.param) }}
- name: JAEGER_SAMPLER_PARAM
  value: "{{- . -}}"
{{- end }}
{{- with ($local.sampler.managerHostPort | default $global.sampler.managerHostPort) }}
- name: JAEGER_SAMPLER_MANAGER_HOST_PORT
  value: "{{- . -}}"
{{- end }}
- name: JAEGER_TAGS
  value: "app.kubernetes.io/name={{- .Chart.Name -}},app.kubernetes.io/instance={{- .Release.Name -}},app.kubernetes.io/namespace={{- .Release.Namespace }}
{{- ($local.tags | default $global.tags) | join "," -}}"
{{- end }}
{{- end -}}
