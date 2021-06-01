{{/* Return Rasa Bot URL */}}
{{- define "rasa-bot.production.url" -}}
{{- if and (not .Values.rasa.versions.rasaProduction.enabled) .Values.rasa.versions.rasaProduction.external.enabled (not (empty .Values.rasa.versions.rasaProduction.external.host)) }}
{{- print .Values.rasa.versions.rasaProduction.external.host }}
{{- else }}
{{- printf "%s://%s-%s.%s.svc:%d" .Values.rasa.scheme (include "rasa-x.fullname" .) .Values.rasa.versions.rasaProduction.serviceName .Release.Namespace (.Values.rasa.port | int) }}
{{- end }}
{{- end -}}
