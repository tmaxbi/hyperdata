{{- define "frontendAddr" -}}
{{- if .Values.enableHttps -}}
https://{{ .Values.loadbalancerAddr }}{{ .Values.frontendSubDir }}
{{- else -}}
http://{{ .Values.loadbalancerAddr }}{{ .Values.frontendSubDir }}
{{- end -}}
{{- end -}}

{{- define "backendAddr" -}}
{{- if .Values.enableHttps -}}
https://{{ .Values.loadbalancerAddr }}{{ .Values.backendSubDir }}
{{- else -}}
http://{{ .Values.loadbalancerAddr }}{{ .Values.backendSubDir }}
{{- end -}}
{{- end -}}

{{- define "hyperdataAddr" -}}
{{- if .Values.enableHttps -}}
https://{{ .Values.loadbalancerAddr }}
{{- else -}}
http://{{ .Values.loadbalancerAddr }}
{{- end -}}
{{- end -}}
