{{/*
Generate a self-signed certificate to be used for admission webhook TLS
*/}}
{{- define "operator.webhook.certificate.self-signed.generate" -}}
{{- $altNames := list (printf "%s.%s" (include "common.names.fullname" .) (include "common.names.namespace" .)) (printf "%s.%s.svc" (include "common.names.fullname" .) (include "common.names.namespace" .)) -}}
{{- $ca := genCA (include "common.names.fullname" .) 365 -}}
{{- $cert := genSignedCert (include "common.names.fullname" .) nil $altNames 365 $ca -}}
{{- $_ := set $ "certificate" (dict "ca" $ca "cert" $cert) -}}
{{-  end  -}}

{{- define "operator.webhook.certificate.self-signed.generated-cert" -}}
{{- if not (hasKey $ "certificate") -}}
{{- include "operator.webhook.certificate.self-signed.generate" . -}}
{{- end -}}
{{- $c := $.certificate.cert -}}
tls.crt: {{ $c.Cert | b64enc }}
tls.key: {{ $c.Key | b64enc }}
{{- end -}}

{{- define "operator.webhook.certificate.self-signed.generated-ca" -}}
{{- if not (hasKey $ "certificate") -}}
{{- include "operator.webhook.certificate.self-signed.generate" . -}}
{{- end -}}
{{- $c := $.certificate.ca -}}
{{- $c.Cert | b64enc -}}
{{- end -}}


{{- define "operator.webhook.certificate.secret-name" -}}
{{- if .Values.operator.admissionWebhook.autoSelfSignedCertificate -}}
{{ template "common.names.fullname" . }}-cert
{{- end -}}
{{- if .Values.operator.admissionWebhook.existingCertificateSecretName -}}
{{- .Values.operator.admissionWebhook.existingCertificateSecretName -}}
{{- end -}}
{{- end -}}


{{- define "operator.webhook.certificate.ca-bundle" -}}
{{- if .Values.operator.admissionWebhook.autoSelfSignedCertificate -}}
{{ include "operator.webhook.certificate.self-signed.generated-ca" . }}
{{- end -}}
{{- if .Values.operator.admissionWebhook.existingCABundle -}}
{{- .Values.operator.admissionWebhook.existingCABundle -}}
{{- end -}}
{{- end -}}