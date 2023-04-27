{{- define "base-cluster.flux2.repo" -}}
https://fluxcd-community.github.io/helm-charts
{{- end -}}

{{- define "base-cluster.flux2.chartName" -}}
flux2
{{- end -}}

{{- define "base-cluster.flux2.chartVersion" -}}
1.x.x
{{- end -}}

{{- define "base-cluster.flux2.version" -}}
v0.36.0
{{- end -}}

{{- define "base-cluster.flux2.values" -}}
{{- if $.Values.global.imageRegistry }}
cli:
  image: "{{ $.Values.global.imageRegistry }}/fluxcd/flux-cli"
{{- end }}
{{- if $.Values.global.imageRegistry }}
helmcontroller:
  image: "{{ $.Values.global.imageRegistry }}/fluxcd/helm-controller"
{{- end }}
{{- if $.Values.global.imageRegistry }}
imageautomationcontroller:
  image: "{{ $.Values.global.imageRegistry }}/fluxcd/image-automation-controller"
{{- end }}
{{- if $.Values.global.imageRegistry }}
imagereflectorcontroller:
  image: "{{ $.Values.global.imageRegistry }}/fluxcd/image-reflector-controller"
{{- end }}
{{- if $.Values.global.imageRegistry }}
kustomizecontroller:
  image: "{{ $.Values.global.imageRegistry }}/fluxcd/kustomize-controller"
{{- end }}
{{- if $.Values.global.imageRegistry }}
notificationcontroller:
  image: "{{ $.Values.global.imageRegistry }}/fluxcd/notification-controller"
{{- end }}
{{- if $.Values.global.imageRegistry }}
sourcecontroller:
  image: "{{ $.Values.global.imageRegistry }}/fluxcd/source-controller"
{{- end }}
prometheus:
  podMonitor:
    create: {{ .Values.monitoring.prometheus.enabled }}
{{- end -}}
