{{/* Kafka related templates */}}

{{/* Overwrite the kafka fullname template. */}}
{{- define "kafka.fullname" -}}
{{- printf "%s-kafka" .Release.Name -}}
{{- end -}}

{{/*
Return the kafka host.
*/}}
{{- define "rasa-x.kafka.url" -}}
  {{- if .Values.kafka.install -}}
    {{- template "kafka.fullname" . -}}
  {{- else -}}
    {{- .Values.kafka.existingUrl -}}
  {{- end -}}
{{- end -}}

{{/*
Return the kafka topic.
*/}}
{{- define "rasa-x.kafka.topic" -}}
{{- default "kafka-topic" .Values.kafka.topic -}}
{{- end -}}


{{/*
Return the kafka security protocol.
*/}}
{{- define "rasa-x.kafka.securityProtocol" -}}
{{- default "PLAINTEXT" .Values.kafka.security_protocol -}}
{{- end -}}

{{/*
Return the kafka sasl username.
*/}}
{{- define "rasa-x.kafka.saslUsername" -}}
{{- default "username" .Values.kafka.sasl_username -}}
{{- end -}}

{{/*
Return the kafka sasl password.
*/}}
{{- define "rasa-x.kafka.saslPassword" -}}
{{- default "password" .Values.kafka.sasl_password -}}
{{- end -}}
