{{- define "4allportal.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.fourAllPortal.image .Values.dreiDRenderer.image .Values.webdav.image) "global" .Values.global) -}}
{{- end -}}

{{- define "4allportal.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.fourAllPortal.image "global" .Values.global) }}
{{- end -}}

{{- define "4allportal.dreiDRenderer.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.dreiDRenderer.image "global" .Values.global) }}
{{- end -}}

{{- define "4allportal.webdav.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.webdav.image "global" .Values.global) }}
{{- end -}}

{{- define "4allportal.backup.mysql.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.maxscale.mariadb.image "global" .Values.global) }}
{{- end -}}

{{- define "4allportal.backup.s3.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.backups.s3.image "global" .Values.global) }}
{{- end -}}

{{- define "4allportal.samba.image" -}}
{{- $repo := "samba.org/samba-server" -}}
{{- if .Values.samba.activeDirectory.enabled -}}
{{- $repo := "samba.org/samba-ad-server" -}}
{{- end -}}
{{ printf "%s/%s:%s" .Values.global.imageRegistry $repo .Values.samba.image.tag }}
{{- end -}}