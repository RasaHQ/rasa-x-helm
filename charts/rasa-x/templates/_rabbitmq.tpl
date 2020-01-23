{{/* RabbitMQ related templates */}}

{{/* Overwrite the rabbit fullname template. */}}
{{- define "rabbitmq.fullname" -}}
{{- printf "%s-rabbit" .Release.Name -}}
{{- end -}}

{{/*
Return the rabbitmq host.
*/}}
{{- define "rasa-x.rabbitmq.host" -}}
  {{- if .Values.rabbitmq.install -}}
    {{- template "rabbitmq.fullname" . -}}
  {{- else -}}
    {{- .Values.rabbitmq.existingHost -}}
  {{- end -}}
{{- end -}}

{{/*
Return the rabbitmq password secret name.
*/}}
{{- define "rasa-x.rabbitmq.password.secret" -}}
{{- default (include "rabbitmq.fullname" .) .Values.rabbitmq.rabbitmq.existingPasswordSecret | quote -}}
{{- end -}}

{{/*
Return the rabbitmq password secret key.
*/}}
{{- define "rasa-x.rabbitmq.password.key" -}}
  {{- if .Values.rabbitmq.install -}}
"rabbitmq-password"
  {{- else -}}
    {{- .Values.rabbitmq.existingPasswordSecretKey -}}
  {{- end -}}
{{- end -}}

{{/*
Return the rabbitmq queue.
*/}}
{{- define "rasa-x.rabbitmq.queue" -}}
{{- default "rasa_production_events" .Values.rasa.rabbitQueue | quote -}}
{{- end -}}
