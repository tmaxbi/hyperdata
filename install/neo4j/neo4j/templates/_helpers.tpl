{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "neo4j.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- /*
fullname defines a suitably unique name for a resource by combining
the release name and the chartmuseum chart name.
The prevailing wisdom is that names should only contain a-z, 0-9 plus dot (.) and dash (-), and should
not exceed 63 characters.
Parameters:
- .Values.fullnameOverride: Replaces the computed name with this given name
- .Values.fullnamePrefix: Prefix
- .Values.fullnameSuffix: Suffix
The applied order is: "prefix + name + suffix"
Usage: 'name: "{{- template "neo4j.fullname" . -}}"'
*/ -}}
{{- define "neo4j.fullname" -}}
{{- $base := default (printf "%s-%s" .Release.Name .Chart.Name) .Values.fullnameOverride -}}
{{- $pre := default "" .Values.fullnamePrefix -}}
{{- $suf := default "" .Values.fullnameSuffix -}}
{{- printf "%s%s%s" $pre $base $suf | lower | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name for secrets.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "neo4j.secrets.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{ template "neo4j.fullname" . }}-secrets
{{- end -}}

{{- define "neo4j.secrets.key" -}}
{{- if and .Values.existingPasswordSecret .Values.existingPasswordSecretKey -}}
{{- .Values.existingPasswordSecretKey -}}
{{- else -}}
neo4j-password
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "neo4j.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "neo4j.labels" -}}
helm.sh/chart: {{ include "neo4j.chart" . }}
{{ include "neo4j.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "neo4j.selectorLabels" -}}
app.kubernetes.io/name: {{ include "neo4j.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
