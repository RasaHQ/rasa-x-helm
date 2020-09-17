{{/* Redis related templates */}}

{{/* Overwrite the redis fullname template. */}}
{{- define "redis.fullname" -}}
{{- printf "%s-redis" .Release.Name -}}
{{- end -}}

{{/*
Return the redis host.
*/}}
{{- define "rasa-x.redis.host" -}}
  {{- if .Values.redis.install -}}
    {{- printf "%s-master" (include "redis.fullname" .) -}}
  {{- else -}}
    {{- .Values.redis.existingHost -}}
  {{- end -}}
{{- end -}}

{{/*
Return the redis password secret name.
*/}}
{{- define "rasa-x.redis.password.secret" -}}
{{- default (include "redis.fullname" .) .Values.redis.existingSecret | quote -}}
{{- end -}}

{{/*
Return the redis password secret key.
*/}}
{{- define "rasa-x.redis.password.key" -}}
  {{- if and .Values.redis.install .Values.redis.existingSecret -}}
    {{- coalesce .Values.redis.existingSecretPasswordKey "redis-password" | quote -}}
  {{- else if .Values.redis.install -}}
    "redis-password"
  {{- else -}}
    {{- default "redis-password" .Values.redis.existingSecretPasswordKey | quote -}}
  {{- end -}}
{{- end -}}
