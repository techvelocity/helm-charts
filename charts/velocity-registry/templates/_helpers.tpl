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

{{- define "utils.urlAuthBuilder" -}}
{{- printf "%s.%s" .Values.url.prefix (required "Default domain must be set" .Values.url.domain) }}
{{- end -}}

{{- define "utils.credendtialsAuthBuild" -}}
{{- printf "%s:%s" .Values.secrets.defaultUsername .Values.secrets.defaultPassword | b64enc }}
{{- end -}}
