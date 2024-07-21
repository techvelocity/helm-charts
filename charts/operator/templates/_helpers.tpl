{{/*
Return the proper operator image name
*/}}
{{- define "operator.image" -}}
{{- $image := .Values.operator.image -}}

{{- if not $image.tag -}}
{{- $_ := set $image "tag" .Chart.AppVersion -}}
{{- end -}}

{{- if not $image.registry -}}
{{- $_ := set $image "registry" "ghcr.io" -}}
{{- end -}}

{{- if not $image.repository -}}
{{- $_ := set $image "repository" "techvelocity/operator" -}}
{{- end -}}

{{ include "common.images.image" (dict "imageRoot" $image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "operator.volumePermissions.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.volumePermissions.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "operator.imagePullSecrets" -}}
{{- include "common.images.renderPullSecrets" (dict "images" (list .Values.operator.image) "context" $) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "operator.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return true if cert-manager required annotations for TLS signed certificates are set in the Ingress annotations
Ref: https://cert-manager.io/docs/usage/ingress/#supported-annotations
*/}}
{{- define "operator.ingress.certManagerRequest" -}}
{{ if or (hasKey . "cert-manager.io/cluster-issuer") (hasKey . "cert-manager.io/issuer") }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message.
*/}}
{{- define "operator.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "operator.validateValues.replicasCount" .) -}}
{{- $messages := append $messages (include "operator.validateValues.certificate" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

{{- define "operator.validateValues.replicasCount" -}}
{{- if and (ne "1" (toString .Values.operator.replicaCount)) (ne "3" (toString .Values.operator.replicaCount)) -}}
{{- fail (cat "currently only one or three replicaCount is supported"  (toString .Values.operator.replicaCount)) -}}
{{- end -}}
{{- end -}}


{{- define "operator.validateValues.certificate" -}}
{{- if and .Values.operator.admissionWebhook.autoSelfSignedCertificate (not (empty .Values.operator.admissionWebhook.existingCertificateSecretName)) -}}
{{- fail "admissionWebhook.autoSelfSignedCertificate is enabled, but so does admissionWebhook.existingCertificateSecretName. Only one of them is allowed at a time" -}}
{{- end -}}
{{- end -}}