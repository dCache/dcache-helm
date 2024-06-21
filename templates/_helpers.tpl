
{{/*
Add CA certs and generate host certificate
*/}}
{{- define "dcache.certs.init" }}

        - securityContext:
            runAsUser: 0
            runAsGroup: 0
          name: init-host-certs
          image: "dcache/ci-init-cert:1.0"
          env:
            - name: AUTOCA_URL
              value: https://ci.dcache.org/ca
          command:
            - sh
            - -c
          args:
            - /run.sh  ${AUTOCA_URL} {{ . }}

{{- end }}

{{/*
dCache config volume mounts
*/}}
{{- define "dcache.conf.mounts" }}
- name: dcache-config
  mountPath: /opt/dcache/etc/dcache.conf
  subPath: dcache.conf
  readOnly: true
- name: dcache-layout
  mountPath: /opt/dcache/etc/layouts/dcache-k8s.conf
  subPath: dcache-k8s.conf
  readOnly: true
{{- end }}

{{/*
dCache conf and layout config map
*/}}
{{- define "dcache.conf.volume" }}
- name: dcache-config
  configMap:
    name: {{ .Release.Name }}-configmap
    items:
    - key: "dcache.conf"
      path: "dcache.conf"
- name: dcache-layout
  configMap:
    name: {{  .Release.Name }}-configmap
    items:
    - key: "dcache-k8s-door"
      path: "dcache-k8s.conf"
{{- end }}

{{/*
Readiness probe
*/}}
{{- define "dcache.readiness.probe" }}
readinessProbe:
  initialDelaySeconds: {{.Values.readinessProbe.initialDelaySeconds }}
  timeoutSeconds:      {{.Values.readinessProbe.timeoutSeconds }}
  failureThreshold:    {{ .Values.readinessProbe.failureThreshold }}
  successThreshold:    {{ .Values.readinessProbe.successThreshold }}
{{- end }}

{{/*
Liveness probe
*/}}
{{- define "dcache.liveness.probe" }}
livenessProbe:
  initialDelaySeconds: {{.Values.livenessProbe.initialDelaySeconds }}
  timeoutSeconds:      {{.Values.livenessProbe.timeoutSeconds }}
  failureThreshold:    {{ .Values.livenessProbe.failureThreshold }}
  successThreshold:    {{ .Values.livenessProbe.successThreshold }}
{{- end }}


{{/*
Startup probe
*/}}
{{- define "dcache.startup.probe" }}
startupProbe:
  initialDelaySeconds: {{.Values.startupProbe.initialDelaySeconds }}
  timeoutSeconds:      {{.Values.startupProbe.timeoutSeconds }}
  failureThreshold:    {{ .Values.startupProbe.failureThreshold }}
  successThreshold:    {{ .Values.startupProbe.successThreshold }}
{{- end }}
