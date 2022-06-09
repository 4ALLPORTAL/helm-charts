{{- if .Values.webdav.enabled -}}
{{- range $path, $permissions := .Values.webdav.mounts -}}
    {{- with $users := $permissions.users -}}
        {{- range $user := $users -}}
            {{- if not ($user | hasKey $.Values.webdav.users) -}}
                {{- fail (printf "User '%s' must be declared in '.webdav.users'" $user) -}}
            {{- end -}}
        {{- end -}}
    {{- end -}}

    {{- with $groups := $permissions.groups -}}
        {{- range $group := $groups -}}
            {{- if not ($group | hasKey $.Values.webdav.groups) -}}
                {{- fail (printf "Group '%s' must be declared in '.webdav.groups'" $group) -}}
            {{- end -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{- range $group, $users := .Values.webdav.groups -}}
    {{- range $user := $users }}
        {{- if not ($user | hasKey $.Values.webdav.users)}}
            {{- fail (printf "User '%s' must be declared in '.webdav.users'" $user) -}}
        {{- end -}}
    {{- end -}}
{{- end -}}
{{- end -}}
