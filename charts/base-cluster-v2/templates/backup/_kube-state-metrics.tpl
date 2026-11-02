{{/*
kube-state-metrics values that turn Stash custom resources into metrics.
Backup alerts read these instead of the Stash Pushgateway, which only holds
the last value a run pushed and loses everything on a Stash restart.
Repository status.lastBackupTime only advances when a run completes all
post-backup steps, so a stuck or half-failed run shows up as an old value.
*/}}
{{- define "base-cluster.backup.kubeStateMetricsValues" -}}
rbac:
  extraRules:
    - apiGroups: [stash.appscode.com]
      resources: [repositories, backupsessions]
      verbs: [list, watch]
customResourceState:
  enabled: true
  config:
    kind: CustomResourceStateMetrics
    spec:
      resources:
        - groupVersionKind:
            group: stash.appscode.com
            version: v1alpha1
            kind: Repository
          metricNamePrefix: kube_stash_repository
          labelsFromPath:
            namespace: [metadata, namespace]
            repository: [metadata, name]
          metrics:
            - name: created
              help: Unix creation timestamp of the Repository.
              each:
                type: Gauge
                gauge:
                  path: [metadata, creationTimestamp]
            - name: last_backup_time
              help: Unix time of the last backup run that completed all post-backup steps.
              each:
                type: Gauge
                gauge:
                  path: [status, lastBackupTime]
            - name: integrity
              help: Result of the last repository integrity check (1 = ok).
              each:
                type: Gauge
                gauge:
                  path: [status, integrity]
        - groupVersionKind:
            group: stash.appscode.com
            version: v1beta1
            kind: BackupSession
          metricNamePrefix: kube_stash_backupsession
          labelsFromPath:
            namespace: [metadata, namespace]
            backupsession: [metadata, name]
            invoker: [spec, invoker, name]
          metrics:
            - name: created
              help: Unix creation timestamp of the BackupSession.
              each:
                type: Gauge
                gauge:
                  path: [metadata, creationTimestamp]
            - name: status_phase
              help: Current phase of the BackupSession.
              each:
                type: StateSet
                stateSet:
                  labelName: phase
                  path: [status, phase]
                  list: [Pending, Running, Succeeded, Failed, Skipped]
{{- end -}}
