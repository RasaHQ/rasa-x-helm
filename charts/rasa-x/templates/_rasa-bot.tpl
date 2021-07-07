{{/* Return Rasa Bot URL */}}
{{- define "rasa-bot.production.url" -}}
{{- if and (not .Values.rasa.versions.rasaProduction.enabled) .Values.rasa.versions.rasaProduction.external.enabled (not (empty .Values.rasa.versions.rasaProduction.external.url)) (not ((index .Values "rasa-bot").subchart)) }}
{{- print .Values.rasa.versions.rasaProduction.external.url }}
{{- else if and (not .Values.rasa.versions.rasaProduction.enabled) (index .Values "rasa-bot").subchart }}
{{- printf "%s://%s-%s.%s.svc:%d" (index .Values "rasa-bot").applicationSettings.scheme (include "rasa-x.fullname" .) "rasa-bot" .Release.Namespace ((index .Values "rasa-bot").applicationSettings.port | int) }}
{{- else }}
{{- printf "%s://%s-%s.%s.svc:%d" .Values.rasa.scheme (include "rasa-x.fullname" .) .Values.rasa.versions.rasaProduction.serviceName .Release.Namespace (.Values.rasa.port | int) }}
{{- end }}
{{- end -}}
