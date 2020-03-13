{{/* postgresql templates */}}

{{/*
Return the postgresql host.
*/}}
{{- define "rasa-x.psql.host" -}}
  {{- if .Values.postgresql.install -}}
    {{- template "postgresql.fullname" . -}}
  {{- else -}}
    {{- .Values.postgresql.existingHost -}}
  {{- end -}}
{{- end -}}

{{/*
Override the fullname template of the subchart.
*/}}
{{- define "postgresql.fullname" -}}
{{- printf "%s-postgresql" .Release.Name -}}
{{- end -}}

{{/*
Return the db database name.
*/}}
{{- define "rasa-x.psql.database" -}}
{{- coalesce .Values.rasax.databaseName .Values.global.postgresql.postgresqlDatabase "rasa" -}}
{{- end -}}

{{/*
Return the db username.
*/}}
{{- define "rasa-x.psql.username" -}}
{{- coalesce .Values.global.postgresql.postgresqlUsername "rasa" -}}
{{- end -}}

{{/*
Return the db port.
*/}}
{{- define "rasa-x.psql.port" -}}
{{- coalesce .Values.global.postgresql.servicePort 5432 -}}
{{- end -}}

{{/*
Return the secret name.
*/}}
{{- define "rasa-x.psql.password.secret" -}}
{{- default (include "postgresql.fullname" .) .Values.global.postgresql.existingSecret | quote -}}
{{- end -}}


{{/*
Return the name of the key in a secret that contains the postgres password.
*/}}
{{- define "rasa-x.psql.password.key" -}}
  {{- if (not .Values.postgresql.install) -}}
    {{- .Values.postgresql.existingSecretKey -}}
  {{- else if (not (eq .Values.global.postgresql.postgresqlUsername "postgres")) -}}
postgresql-postgres-password
  {{- else -}}
postgresql-password
  {{- end -}}
{{- end -}}

{{/*
Return the common database env variables.
*/}}
{{- define "rasa-x.psql.envs" -}}
- name: "DB_USER"
  value: "{{ template "rasa-x.psql.username" . }}"
- name: "DB_HOST"
  value: "{{ template "rasa-x.psql.host" . }}"
- name: "DB_PORT"
  value: "{{ template "rasa-x.psql.port" . }}"
- name: "DB_DATABASE"
  value: "{{ template "rasa-x.psql.database" . }}"
- name: "DB_PASSWORD"
  valueFrom:
    secretKeyRef:
      name: {{ template "rasa-x.psql.password.secret" . }}
      key: {{ template "rasa-x.psql.password.key" . }}
{{- end -}}
