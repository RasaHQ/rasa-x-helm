{{/* Return Rasa OSS URL - the production environment */}}
{{- define "rasa.production.url" -}}
{{- if and (not .Values.rasa.versions.rasaProduction.enabled) .Values.rasa.versions.rasaProduction.external.enabled (not (empty .Values.rasa.versions.rasaProduction.external.url)) (not ((index .Values "rasa-bot").subchart)) }}
{{- print .Values.rasa.versions.rasaProduction.external.url }}
{{- else if and (not .Values.rasa.versions.rasaProduction.enabled) (index .Values "rasa-bot").subchart }}
{{- printf "%s://%s-%s.%s.svc:%d" (index .Values "rasa-bot").applicationSettings.scheme (include "rasa-x.fullname" .) "rasa-bot" .Release.Namespace ((index .Values "rasa-bot").applicationSettings.port | int) }}
{{- else }}
{{- printf "%s://%s-%s.%s.svc:%d" .Values.rasa.scheme (include "rasa-x.fullname" .) .Values.rasa.versions.rasaProduction.serviceName .Release.Namespace (.Values.rasa.port | int) }}
{{- end }}
{{- end -}}

{{/* Return Rasa OSS URL - the worker environment */}}
{{- define "rasa.worker.url" -}}
{{- if and (not .Values.rasa.versions.rasaWorker.enabled) .Values.rasa.versions.rasaWorker.external.enabled (not (empty .Values.rasa.versions.rasaWorker.external.url)) (not ((index .Values "rasa-bot").subchart)) }}
{{- print .Values.rasa.versions.rasaWorker.external.url }}
{{- else }}
{{- printf "%s://%s-%s.%s.svc:%d" .Values.rasa.scheme (include "rasa-x.fullname" .) .Values.rasa.versions.rasaWorker.serviceName .Release.Namespace (.Values.rasa.port | int) }}
{{- end }}
{{- end -}}
