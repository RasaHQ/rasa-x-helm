{{/* MongoDB related templates */}}


{{/*
Return the mongodb host.
*/}}
{{- define "rasa.mongodb.host" -}}
{{- .Values.rasa.trackerStore.url -}}
{{- end -}}