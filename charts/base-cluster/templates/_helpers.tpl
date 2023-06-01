{{- define "base-cluster.domain" -}}
{{ required "You must provide a cluster name" $.Values.global.clusterName }}.{{- required "You must provide a base domain" $.Values.global.baseDomain -}}
{{- end -}}

{{- define "base-cluster.grafana.host" -}}
{{- required "You must provide a host for the grafana server" .Values.monitoring.grafana.host -}}.{{ include "base-cluster.domain" $ }}
{{- end -}}

{{- define "base-cluster.speedtest.host" -}}
{{- required "You must provide a host for the speedtest server" .Values.speedtest.host -}}.{{ include "base-cluster.domain" $ }}
{{- end -}}

{{- define "base-cluster.grafana.config" -}}
auth:
  signout_redirect_url: https://{{- include "base-cluster.grafana.host" . }}
server:
  root_url: https://{{- include "base-cluster.grafana.host" . }}
{{- end -}}

{{- define "base-cluster.jaeger.host" -}}
{{- required "You must provide a host for the jaeger server" .Values.monitoring.jaeger.host -}}.{{ include "base-cluster.domain" $ }}
{{- end -}}

{{- define "base-cluster.prometheus.host" -}}
{{- required "You must provide a host for the prometheus server" .Values.monitoring.prometheus.host -}}.{{ include "base-cluster.domain" $ }}
{{- end -}}

{{- define "base-cluster.alertmanager.host" -}}
{{- required "You must provide a host for the prometheus alertmanager server" .Values.monitoring.prometheus.alertmanager.host -}}.{{ include "base-cluster.domain" $ }}
{{- end -}}

{{- define "base-cluster.alertmanager.email.tls" -}}
{{- if not (empty .Values.monitoring.prometheus.alertmanager.emailconfig) -}}
{{- with index .Values.monitoring.prometheus.alertmanager.emailconfig 0 }}
{{- $config := get . "email_configs" -}}
{{- $port := (split ":" (get (index $config 0) "smarthost"))._1 -}}
{{- ne $port "465" -}}
{{- end -}}
{{- else -}}
true
{{- end -}}
{{- end -}}

{{- define "base-cluster.goldpinger.host" -}}
{{- required "You must provide a host for the goldpinger server" .Values.monitoring.goldpinger.host -}}.{{ include "base-cluster.domain" $ }}
{{- end -}}

{{- define "common.networkPolicy.type" -}}
{{- if eq .Values.global.networkPolicy.type "auto" -}}
{{- if .Capabilities.APIVersions.Has "cilium.io/v2/CiliumNetworkPolicy" -}}
cilium
{{- else -}}
none
{{- end -}}
{{- else -}}
{{- .Values.global.networkPolicy.type -}}
{{- end -}}
{{- end -}}

{{- define "common.dict.filterEmptyValues" -}}
{{- $out := dict -}}
{{- range $key, $value := . -}}
{{- if $value -}}
{{- $out = set $out $key $value -}}
{{- end -}}
{{- end -}}
{{ $out | toYaml }}
{{- end -}}

{{- define "base-cluster.install.helm-chart" -}}
{{- $repo := .repo -}}
{{- $chart := .chart -}}
{{- $version := .version -}}
{{- $name := .name -}}
{{- $namespace := .namespace -}}
{{- $values := .values -}}
{{- $context := .context -}}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ $name }}-installation
  namespace: {{ $context.Release.Namespace }}
  labels: {{- include "common.labels.standard" $context | nindent 4 }}
    app.kubernetes.io/component: {{ $name }}
  annotations:
    helm.sh/hook: pre-install,pre-upgrade
    helm.sh/hook-weight: "0"
    helm.sh/hook-delete-policy: before-hook-creation,hook-succeeded
data:
  values.yaml: {{- $values | toYaml | nindent 4 }}
---
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ $name }}-installation
  namespace: {{ $context.Release.Namespace }}
  labels: {{- include "common.labels.standard" $context | nindent 4 }}
    app.kubernetes.io/component: {{ $name }}
  annotations:
    helm.sh/hook: pre-install,pre-upgrade
    helm.sh/hook-weight: "0"
    helm.sh/hook-delete-policy: before-hook-creation,hook-succeeded
spec:
  template:
    spec:
      restartPolicy: OnFailure
      serviceAccountName: helm-setup
      automountServiceAccountToken: true
      containers:
        - name: install-{{ $name }}
          image: {{ include "base-cluster.helm.image" $context }}
          {{- if $context.Values.global.helm.image.repository | contains "@" }}
          imagePullPolicy: IfNotPresent
          {{- else }}
          imagePullPolicy: Always
          {{- end }}
          command:
            - helm
            - upgrade
            - --install
            - --atomic
            - --namespace={{ $namespace }}
            - {{ $namespace }}-{{ $name }}
            - --repo={{ $repo }}
            - {{ $chart }}
            - --version={{ $version }}
            - --values=/tmp/values.yaml
          volumeMounts:
            - mountPath: /tmp/values.yaml
              name: values
              subPath: values.yaml
      volumes:
        - name: values
          configMap:
            name: {{ $name }}-installation
{{- end -}}

{{- define "base-cluster.uninstall.helm-chart" -}}
{{- $name := .name -}}
{{- $namespace := .namespace -}}
{{- $context := .context -}}
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ $name }}-uninstallation
  namespace: {{ $context.Release.Namespace }}
  labels: {{- include "common.labels.standard" $context | nindent 4 }}
    app.kubernetes.io/component: {{ $name }}
  annotations:
    helm.sh/hook: post-upgrade
    helm.sh/hook-weight: "0"
    helm.sh/hook-delete-policy: before-hook-creation,hook-succeeded
spec:
  template:
    spec:
      restartPolicy: OnFailure
      serviceAccountName: helm-setup
      automountServiceAccountToken: true
      containers:
        - name: uninstall-{{ $name }}
          image: {{ include "base-cluster.helm.image" $context }}
          {{- if $context.Values.global.helm.image.repository | contains "@" }}
          imagePullPolicy: IfNotPresent
          {{- else }}
          imagePullPolicy: Always
          {{- end }}
          command:
            - ash
            - -ex
            - -c
            - |
              if helm --namespace={{ $namespace }} history {{ $namespace }}-{{ $name }} --max 1; then
                helm uninstall --namespace={{ $namespace }} {{ $namespace }}-{{ $name }}
              fi
{{- end -}}
