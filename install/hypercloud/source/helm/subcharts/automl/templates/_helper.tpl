{{- define "frontendAddr" -}}
{{- if .Values.https.enabled -}}
https://{{ .Values.webserver.ip }}:{{ .Values.webserver.port }}{{ .Values.frontendSubDir }}
{{- else -}}
http://{{ .Values.webserver.ip }}:{{ .Values.webserver.port }}{{ .Values.frontendSubDir }}
{{- end -}}
{{- end -}}

{{- define "backendAddr" -}}
{{- if .Values.https.enabled -}}
https://{{ .Values.webserver.ip }}:{{ .Values.webserver.port }}{{ .Values.backendSubDir }}
{{- else -}}
http://{{ .Values.webserver.ip }}:{{ .Values.webserver.port }}{{ .Values.backendSubDir }}
{{- end -}}
{{- end -}}

{{- define "hyperdataAddr" -}}
{{- if .Values.https.enabled -}}
https://{{ .Values.webserver.ip }}:{{ .Values.webserver.port }}
{{- else -}}
http://{{ .Values.webserver.ip }}:{{ .Values.webserver.port }}
{{- end -}}
{{- end -}}

{{- define "kfservingAddr" -}}
http://{{ .Values.kubeflow.ip }}:{{ .Values.kubeflow.ports.kfserving }}
{{- end -}}