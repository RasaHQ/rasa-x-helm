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
{{- if .Values.global.additionalDeploymentLabels -}}
{{ toYaml .Values.global.additionalDeploymentLabels }}
{{- end -}}
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
Return the duckling host.
*/}}
{{- define "duckling.host" -}}
  {{- include "rasa-x.fullname" . -}}-duckling
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
Return the name of the standard config map which stores the nginx config.
*/}}
{{- define "rasa-x.nginx.standard-conf" -}}
"{{ .Release.Name }}-nginx-standard-conf"
{{- end -}}


{{/*
Return the name of the config map which stores the nginx config.
*/}}
{{- define "rasa-x.nginx.conf" -}}
  {{- if .Values.nginx.customConfConfigMap -}}
    {{- .Values.nginx.customConfConfigMap -}}
  {{- else -}}
   {{- template "rasa-x.nginx.standard-conf" . -}}
  {{- end -}}
{{- end -}}


{{/*
Return the port of the action container.
*/}}
{{- define "rasa-x.custom-actions.port" -}}
{{- default 5055 .Values.app.port -}}
{{- end -}}

{{/*
Include duckling extra env vars.
*/}}
{{- define "duckling.extra.envs" -}}
  {{- if .Values.duckling.extraEnvs -}}
{{ toYaml .Values.duckling.extraEnvs }}
  {{- end -}}
{{- end -}}

{{/*
Include rasa extra env vars.
*/}}
{{- define "rasa.extra.envs" -}}
  {{- if .Values.rasa.extraEnvs -}}
{{ toYaml .Values.rasa.extraEnvs }}
  {{- end -}}
{{- end -}}

{{/*
Include rasax extra env vars.
*/}}
{{- define "rasax.extra.envs" -}}
  {{- if .Values.rasax.extraEnvs -}}
{{ toYaml .Values.rasax.extraEnvs }}
  {{- end -}}
{{- end -}}

{{/*
Include additional rabbit queues
*/}}
{{- define "rasa.additionalRabbitQueues" -}}
  {{- if .Values.rasa.additionalRabbitQueues -}}
{{ toYaml .Values.rasa.additionalRabbitQueues }}
  {{- end -}}
{{- end -}}

{{/*
Include extra env vars for the EventService.
*/}}
{{- define "rasax.event-service.extra.envs" -}}
  {{- if .Values.eventService.extraEnvs -}}
{{ toYaml .Values.eventService.extraEnvs }}
  {{- end -}}
{{- end -}}

{{/*
Include extra env vars for the database migration service.
*/}}
{{- define "rasax.db-migration-service.extra.envs" -}}
  {{- if .Values.dbMigrationService.extraEnvs -}}
{{ toYaml .Values.dbMigrationService.extraEnvs }}
  {{- end -}}
{{- end -}}

{{/*
Return the storage class name which should be used.
*/}}
{{- define "rasa-x.persistence.storageClass" -}}
{{- if .Values.global.storageClass }}
  {{- if (eq "-" .Values.global.storageClass) }}
  storageClassName: ""
  {{- else }}
  storageClassName: "{{ .Values.global.storageClass }}"
  {{- end -}}
{{- end -}}
{{- end }}

{{/*
Return the checksum of Rasa X values.
*/}}
{{- define "rasa-x.checksum" -}}
{{ toYaml .Values.rasax | sha256sum }}
{{- end -}}

{{/*
Return the AppVersion value as a default if the rasax.tag variable is not defined.
*/}}
{{- define "rasa-x.version" -}}
{{ .Values.rasax.tag | default .Chart.AppVersion }}
{{- end -}}

{{/*
Return the AppVersion value as a default if the app.tag variable is not defined.
*/}}
{{- define "app.version" -}}
{{ .Values.app.tag | default .Chart.AppVersion }}
{{- end -}}

{{/*
Return the Rasa image tag. Use `.Values.rasa.version` if `Values.rasa.tag` is not defined.
*/}}
{{- define "rasa.tag" -}}
{{ .Values.rasa.tag | default (printf "%s-full" .Values.rasa.version) }}
{{- end -}}

{{/*
Return 'true' if an enterprise version is run.
*/}}
{{- define "is_enterprise" -}}
{{- if or (contains "rasa-x-ee" .Values.rasa.name) (contains "rasa-x-ee" .Values.rasax.name) (contains "rasa-x-ee" .Values.eventService.name) -}}
{{- print "true" -}}
{{- else -}}
{{- print "false" -}}
{{- end -}}
{{- end -}}

{{/*
Return the rasa-x.version value as a default if the dbMigrationService.tag variable is not defined.
*/}}
{{- define "db-migration-service.version" -}}
{{ .Values.dbMigrationService.tag | default (include "rasa-x.version" .) }}
{{- end -}}

{{/*
Return 'true' if required version to run the database migration service is correct.
If version is not valid semantic version then not use the DB migration service.
*/}}
{{- define "db-migration-service.requiredVersion" -}}
{{- if .Values.dbMigrationService.ignoreVersionCheck  -}}
{{- print "true" -}}
{{/*
Return 'true' if the version is master or latest, or contains a or rc.
*/}}
{{- else if regexMatch "master|latest|.*(a|rc)[0-9]+" (include "db-migration-service.version" .) -}}
{{- print "true" -}}
{{- else -}}
{{- if semverCompare ">= 0.33.0" (include "db-migration-service.version" .) -}}
{{- print "true" -}}
{{- else -}}
{{- print "false" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Returns the database migration service address
*/}}
{{- define "db-migration-service.address" -}}
{{ include "rasa-x.fullname" . }}{{ print "-db-migration-service-headless" }}
{{- end -}}
{{/*
Return an init container for database migration.
*/}}
{{- define "initContainer.dbMigration" -}}
{{ if and (eq "true" (include "db-migration-service.requiredVersion" .context )) .context.Values.separateDBMigrationService }}
initContainers:
- name: init-db
  image: {{ .image }}
  {{- if .context.Values.dbMigrationService.initContainer.resources }}
  resources:
  {{- toYaml .context.Values.dbMigrationService.initContainer.resources | nindent 4 }}
  {{- end }}
  command:
  {{- if .context.Values.dbMigrationService.initContainer.command }}
  {{- toYaml .context.Values.dbMigrationService.initContainer.command | nindent 2 }}
  {{ else }}
  - '/bin/bash'
  - '-c'
  - 'until [[ "$(curl -s http://{{ (include "db-migration-service.address" .context) }}:{{ .context.Values.dbMigrationService.port }} | grep -c completed)" == "1" ]]; do
    STATUS=$(curl -s http://{{ (include "db-migration-service.address" .context) }}:{{ .context.Values.dbMigrationService.port }});
    if [[ -n "$STATUS" ]];then echo $STATUS; fi;
    sleep 5;
    done;'
{{- end }}
{{- end -}}
{{- end -}}

{{/*
Return the rasa x image name value as a default if the dbMigrationService.name variable is not defined.
*/}}
{{- define "dbMigrationService-name" -}}
{{ .Values.dbMigrationService.name | default .Values.rasax.name }}
{{- end -}}

{{/*
Return the appropriate apiVersion for networkpolicy.
*/}}
{{- define "networkPolicy.apiVersion" -}}
{{- if semverCompare ">=1.4-0, <1.7-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "extensions/v1beta1" -}}
{{- else -}}
{{- print "networking.k8s.io/v1" -}}
{{- end -}}
{{- end -}}

{{/*
Return DNS policy depends on host network configuration
*/}}
{{- define "rasa-x.dnsPolicy" -}}
{{- if and .Values.rasax.hostNetwork (empty .Values.rasax.dnsPolicy) -}}
{{- print "ClusterFirstWithHostNet" -}}
{{- else if and (not .Values.rasax.hostNetwork) (empty .Values.rasax.dnsPolicy) -}}
{{- print "ClusterFirst" -}}
{{- else if .Values.rasax.dnsPolicy -}}
{{- .Values.rasax.dnsPolicy -}}
{{- end -}}
{{- end -}}


{{/*
Return 'true' if the production environment is used.
*/}}
{{- define "rasa-x.production.env.used" -}}
{{- if or .Values.rasa.versions.rasaProduction.enabled .Values.rasa.versions.rasaProduction.external.enabled  -}}
{{- print "true" -}}
{{- else -}}
{{- print "false" -}}
{{- end -}}
{{- end -}}

{{/*
Return 'true' if the worker environment is used.
*/}}
{{- define "rasa-x.worker.env.used" -}}
{{- if or .Values.rasa.versions.rasaWorker.enabled .Values.rasa.versions.rasaWorker.external.enabled  -}}
{{- print "true" -}}
{{- else -}}
{{- print "false" -}}
{{- end -}}
{{- end -}}
