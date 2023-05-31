{{- define "base-cluster.prometheus.config" -}}
grafana:
{{- if .Values.global.imageRegistry }}
  image:
    repository: "{{ $.Values.global.imageRegistry }}/grafana/grafana"
  initChownData:
    image:
      repository: "{{ $.Values.global.imageRegistry }}/busybox"
  testFramework:
    image: "{{ $.Values.global.imageRegistry }}/bats/bats"
  downloadDashboardsImage:
    repository: "{{ $.Values.global.imageRegistry }}/curlimages/curl"
  imageRenderer:
    enabled: true
    image:
      repository: "{{ $.Values.global.imageRegistry }}/grafana/grafana-image-renderer"
    {{- else }}
  imageRenderer:
    enabled: true
    {{- end }}
  enabled: true
  resources: {{- $.Values.monitoring.grafana.resources | toYaml | nindent 4 }}
  serviceMonitor:
    interval: "30s"
  adminPassword: {{ required "You must provide an adminPassword for grafana" $.Values.monitoring.grafana.adminPassword | quote }}
  plugins:
    - grafana-piechart-panel
  {{- with $.Values.monitoring.grafana.additionalPlugins }}
  {{ . | toYaml | nindent 4 }}
  {{- end }}
  defaultDashboardsEnabled: true
  grafana.ini:
  {{- if $.Values.monitoring.grafana.config -}}
  {{ merge $.Values.monitoring.grafana.config (include "base-cluster.grafana.config" $ | fromYaml) | toYaml | nindent 4 -}}
  {{- else -}}
  {{ include "base-cluster.grafana.config" $ | nindent 4 -}}
  {{- end }}
  {{ if $.Values.monitoring.grafana.notifiers -}}
  extraEmptyDirMounts:
    - name: provisioning-notifiers
      mountPath: /etc/grafana/provisioning/notifiers
  notifiers:
    notifiers.yaml:
      notifiers:
  {{- $.Values.monitoring.grafana.notifiers | toYaml | nindent 8 }}
  {{- end }}
  dashboardProviders:
    dashboardproviders.yaml:
      apiVersion: 1
      providers:
        - name: 'custom'
          orgId: 1
          folder: ''
          type: file
          disableDeletion: true
          editable: true
          options:
            path: /var/lib/grafana/dashboards/custom
  sidecar:
  {{- if .Values.global.imageRegistry }}
    image:
      repository: "{{ $.Values.global.imageRegistry }}/kiwigrid/k8s-sidecar"
  {{- end }}
    dashboards:
      enabled: true
      searchNamespace: ALL
      provider:
        disableDelete: true
    datasources:
      enabled: true
    resources: {{- $.Values.monitoring.grafana.sidecar.resources | toYaml | nindent 6 }}
  dashboards:
    custom:
      #capacity-planning:
      #  gnetId: 22
      #  revision: 7
      #  datasource: Prometheus
      kubernetes-cluster-monitoring-via-prometheus: &dashboard
        datasource: Prometheus
        gnetId: 315
        revision: 3
      node-exporter-full:
        <<: *dashboard
        gnetId: 1860
        revision: 16
      metrics:
        <<: *dashboard
        gnetId: 8588
      jvm:
        <<: *dashboard
        gnetId: 4701
        revision: 9
      {{ if .Values.monitoring.securityScanning.enabled }}
      trivy:
        <<: *dashboard
        gnetId: 17813
        revision: 2
      {{ end }}
      {{ if .Values.monitoring.jaeger.enabled }}
      jaeger:
        <<: *dashboard
        gnetId: 10001
        revision: 2
      {{ end }}
      {{ if .Values.monitoring.goldpinger.enabled }}
      goldpinger:
        <<: *dashboard
        gnetId: 10949
        revision: 1
      {{ end }}
  {{- with $.Values.monitoring.grafana.additionalDashboards }}
  {{ . | toYaml | nindent 6 }}
  {{- end }}
  ingress:
    enabled: true
    hosts:
      - {{ include "base-cluster.grafana.host" $ }}
    tls:
      - hosts:
          - {{ include "base-cluster.grafana.host" $ }}
        secretName: cluster-wildcard-certificate
prometheusOperator:
  secretFieldSelector: 'type!=helm.sh/release.v1'
    {{- if .Values.global.imageRegistry }}
  configmapReloadImage:
    repository: "{{ $.Values.global.imageRegistry }}/jimmidyson/configmap-reload"
    {{- end }}
  resources: {{- $.Values.monitoring.prometheus.operator.resources | toYaml | nindent 6 }}
  priorityClassName: system-cluster-critical
kubelet:
  serviceMonitor:
    resource: false
kube-state-metrics:
  resources: {{- $.Values.monitoring.prometheus.kubeStateMetrics.resources | toYaml | nindent 6 }}
  extraArgs:
    - --metric-labels-allowlist=pods=[app.kubernetes.io/name,app.kubernetes.io/component,app.kubernetes.io/instance,statefulset.kubernetes.io/pod-name],deployments=[app.kubernetes.io/name,app.kubernetes.io/component,app.kubernetes.io/instance],statefulsets=[app.kubernetes.io/name,app.kubernetes.io/component,app.kubernetes.io/instance]
  priorityClassName: system-cluster-critical
prometheus-node-exporter:
  resources: {{- $.Values.monitoring.prometheus.nodeExporter.resources | toYaml | nindent 6 }}
  priorityClassName: system-cluster-critical
alertmanager:
  enabled: true
  config:
  {{- if .Values.monitoring.prometheus.alertmanager.pagerduty.enabled }}
    global:
      pagerduty_url: {{ .Values.monitoring.prometheus.alertmanager.pagerduty.url  }}
  {{- end }}
      {{- with .Values.monitoring.prometheus.alertmanager.emailconfig }}
      smtp_require_tls: {{ include "base-cluster.alertmanager.email.tls" . }}
      {{- end }}
    route:
      {{- if .Values.monitoring.prometheus.alertmanager.pagerduty.enabled }}
      receiver: pagerduty
      {{- end }} 
      routes:
      - receiver: 'email'
        repeat_interval: 24h
        group_by: [alertname]
        matchers:
        - alertname="HighStorageUsage"
    receivers:
      {{- if .Values.monitoring.prometheus.alertmanager.pagerduty.enabled }}
      - name: pagerduty
        pagerduty_configs:
          - routing_key: {{ .Values.monitoring.prometheus.alertmanager.pagerduty.routingKey }}
      {{- end }}
      {{- with $.Values.monitoring.prometheus.alertmanager.emailconfig }}
      - name: email
        email_configs: {{ . | toYaml | nindent 12 }}
      {{- end }} 
      - name: "null"
  podDisruptionBudget:
    enabled: true
  {{- if not (empty $.Values.monitoring.prometheus.authentication.enabled | ternary $.Values.global.authentication.enabled $.Values.monitoring.prometheus.authentication.enabled) }}
  ingress:
    enabled: true
    hosts:
      - {{ include "base-cluster.alertmanager.host" $ }}
    tls:
      - hosts:
          - {{ include "base-cluster.alertmanager.host" $ }}
        secretName: cluster-wildcard-certificate
  {{- end }}
  alertmanagerSpec:
    replicas: 3
    podAntiAffinity: soft
    {{- if empty $.Values.monitoring.prometheus.authentication.enabled | ternary $.Values.global.authentication.enabled $.Values.monitoring.prometheus.authentication.enabled }}
    externalUrl: https://{{ include "base-cluster.alertmanager.host" $ }}
    {{- end }}
    retention: {{ $.Values.monitoring.prometheus.alertmanager.storage.retention }}
    priorityClassName: system-cluster-critical
    storageSpec:
      volumeClaimTemplate:
        spec:
          {{- if or $.Values.monitoring.prometheus.alertmanager.storageClass $.Values.monitoring.prometheus.storageClass $.Values.global.storageClass }}
          storageClassName: {{ $.Values.monitoring.prometheus.alertmanager.storageClass | default $.Values.monitoring.prometheus.storageClass | default $.Values.global.storageClass }}
          {{- end }}
          accessModes: ["ReadWriteOnce"]
          resources:
            requests:
              storage: {{ $.Values.monitoring.prometheus.alertmanager.storage.size }}
prometheus:
  enabled: true
  {{- if not (empty $.Values.monitoring.prometheus.authentication.enabled | ternary $.Values.global.authentication.enabled $.Values.monitoring.prometheus.authentication.enabled) }}
  ingress:
    enabled: true
    hosts:
      - {{ include "base-cluster.prometheus.host" $ }}
    tls:
      - hosts:
          - {{ include "base-cluster.prometheus.host" $ }}
        secretName: cluster-wildcard-certificate
  {{- end }}
  prometheusSpec:
    {{- if empty $.Values.monitoring.prometheus.authentication.enabled | ternary $.Values.global.authentication.enabled $.Values.monitoring.prometheus.authentication.enabled }}
    externalUrl: https://{{ include "base-cluster.prometheus.host" $ }}
    {{- end }}
    resources: {{- $.Values.monitoring.prometheus.resources | toYaml | nindent 6 }}
    priorityClassName: system-cluster-critical
    serviceMonitorSelectorNilUsesHelmValues: false
    ruleSelectorNilUsesHelmValues: false
    podMonitorSelectorNilUsesHelmValues: false
    probeSelectorNilUsesHelmValues: false
    retention: {{ $.Values.monitoring.prometheus.storage.retention }}
    storageSpec:
      volumeClaimTemplate:
        spec:
          {{- if or $.Values.monitoring.prometheus.storageClass $.Values.global.storageClass }}
          storageClassName: {{ default $.Values.monitoring.prometheus.storageClass $.Values.global.storageClass }}
          {{- end }}
          accessModes: ["ReadWriteOnce"]
          resources:
            requests:
              storage: {{ $.Values.monitoring.prometheus.storage.size }}
{{- end -}}
