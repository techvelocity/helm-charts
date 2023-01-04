{{/* The name of the application this chart installs */}}
{{- define "app.name" -}}
{{- default .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "chart.name" -}}
{{- default .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "chart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "chart.labels" -}}
helm.sh/chart: {{ include "chart.chart" . }}
{{- end -}}

{{- define "chart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "chart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "utils.dockerjson" }}
{{- printf "{\"auths\": {\"%s\": {\"auth\": \"%s\"}}}"
.Values.url (printf "%s:%s" .Values.secrets.DefaultUsername
.Values.secrets.DefaultPassword | b64enc) | b64enc }}
{{- end }}
