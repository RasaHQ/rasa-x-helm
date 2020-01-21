{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "rasa-x.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "rasa-x.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "rasa-x.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels.
*/}}
{{- define "rasa-x.labels" -}}
helm.sh/chart: {{ include "rasa-x.chart" . }}
{{ include "rasa-x.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels.
*/}}
{{- define "rasa-x.selectorLabels" -}}
app.kubernetes.io/name: {{ include "rasa-x.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Common container spec.
*/}}
{{- define "rasa-x.spec" -}}
{{- include "rasa-x.imagePullSecrets" . | nindent 6 }}
{{- include "rasa-x.securityContext" . | nindent 6 }}
{{- end -}}

{{/*
Secrets to pull images from private registries.
*/}}
{{- define "rasa-x.imagePullSecrets" -}}
 {{- with .Values.images.imagePullSecrets -}}
imagePullSecrets:
{{ toYaml . }}
 {{- end -}}
{{- end -}}

{{/*
Security context for the containers.
*/}}
{{- define "rasa-x.securityContext" -}}
 {{- with .Values.securityContext -}}
securityContext:
  {{- toYaml . | nindent 2 }}
 {{- end -}}
{{- end -}}

{{/*
Returns the name of the rasa secret.
*/}}
{{- define "rasa-x.secret" -}}
  {{- if .Values.rasaSecret -}}
{{ .Values.rasaSecret }}
  {{- else -}}
{{ .Release.Name }}-rasa
  {{- end -}}
{{- end -}}

{{/*
Return the name of the config map which stores the rasa configuration files.
*/}}
{{- define "rasa-x.rasa.configuration-files" -}}
"{{ .Release.Name }}-rasa-configuration-files"
{{- end -}}

{{/*
Return the rasa-x host.
*/}}
{{- define "rasa-x.host" -}}
  {{- include "rasa-x.fullname" . -}}-rasa-x
{{- end -}}

{{/*
Return the name of the config map which stores the rasa x configuration files.
*/}}
{{- define "rasa-x.rasa-x.configuration-files" -}}
"{{ .Release.Name }}-rasa-x-configuration-files"
{{- end -}}

{{/*
Return the name of the rasa x volume claim.
*/}}
{{- define "rasa-x.rasa-x.claim" -}}
{{ .Values.rasax.persistence.existingClaim | default (printf "%s-%s" .Release.Name "rasa-x-claim") }}
{{- end -}}

{{/*
Return the name of config map which stores the nginx agreement.
*/}}
{{- define "rasa-x.nginx.agreement" -}}
"{{ .Release.Name }}-agreement"
{{- end -}}

{{/*
Return the port of the action container.
*/}}
{{- define "rasa-x.custom-actions.port" -}}
{{- default 5055 .Values.app.port -}}
{{- end -}}
