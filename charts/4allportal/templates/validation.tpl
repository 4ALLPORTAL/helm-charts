{{- if not (eq (without (list .Values.fourAllPortal.database.operator.enabled (or (not (empty .Values.fourAllPortal.database.existing.host)) (not (empty .Values.fourAllPortal.database.existing.jdbcUrl)))) false | len) 1) -}}
{{- fail "Exactly one of fourAllPortal.database.operator.enabled or fourAllPortal.database.existing.(host|jdbcUrl) must be set." -}}
{{- end -}}

{{- if and (eq .Values.fourAllPortal.database.operator.enabled true) (eq .Values.fourAllPortal.database.operator.secretName "") -}}
{{- if eq .Values.fourAllPortal.database.operator.user "CHANGEME" -}}
{{- fail "You need to change fourAllPortal.database.operator.user" -}}
{{- end -}}

{{- if and (eq .Values.fourAllPortal.database.operator.password "CHANGEME") (eq .Values.fourAllPortal.database.operator.secretName "") -}}
{{- fail "You need to change fourAllPortal.database.operator.password" -}}
{{- end -}}

{{- if eq .Values.fourAllPortal.database.operator.databaseName "CHANGEME" -}}
{{- fail "You need to change fourAllPortal.database.operator.databaseName" -}}
{{- end -}}

{{- if eq .Values.fourAllPortal.database.operator.databaseRef "CHANGEME" -}}
{{- fail "You need to change fourAllPortal.database.operator.databaseRef" -}}
{{- end -}}
{{- end -}}

{{- if (ne "" .Values.fourAllPortal.systemApiKey) -}}
{{- if not (regexMatch "^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$" .Values.fourAllPortal.systemApiKey) -}}
{{- fail "You need to set fourAllPortal.systemApiKey in uuidv4 format or leave blank" -}}
{{- end -}}
{{- end -}}

{{- if eq .Values.samba.enabled true -}}
{{- if and (eq .Values.samba.secret.name "") (eq .Values.samba.secret.key "") -}}
{{- if eq .Values.samba.adminPassword "CHANGEME" -}}
{{- fail "You need to change samba.adminPassword" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- $kafka := (.Values.fourAllPortal).kafka | default dict -}}
{{- $kafkaEnv := .Values.fourAllPortal.env | default dict -}}

{{- if and $kafka.brokers (hasKey $kafkaEnv "SPRING_KAFKA_BOOTSTRAP_SERVERS") -}}
{{- fail "Configure the broker either in fourAllPortal.kafka.brokers or in fourAllPortal.env.SPRING_KAFKA_BOOTSTRAP_SERVERS, not both." -}}
{{- end -}}

{{- if and ($kafka.consumer | default dict).groupId (hasKey $kafkaEnv "SPRING_KAFKA_CONSUMER_GROUP_ID") -}}
{{- fail "Configure the consumer group either in fourAllPortal.kafka.consumer.groupId or in fourAllPortal.env.SPRING_KAFKA_CONSUMER_GROUP_ID, not both." -}}
{{- end -}}

{{- if and $kafka.brokers (eq (include "common.networkPolicy.type" .) "cilium") (not ($kafka.networkPolicy | default dict).matchLabels) -}}
{{- fail "fourAllPortal.kafka.networkPolicy.matchLabels must select the broker pods when fourAllPortal.kafka.brokers is set, including io.kubernetes.pod.namespace. Without it a Cilium cluster renders no egress rule and drops the connection." -}}
{{- end -}}
