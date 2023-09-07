
{{/*
Add CA certs and generate host certificate
*/}}
{{- define "dcache.certs.init" }}

        - securityContext:
            runAsUser: 0
            runAsGroup: 0
          name: init-host-certs
          image: "centos:7"
          env:
            - name: AUTOCA_URL
              value: https://ci.dcache.org/ca
          command:
            - sh
            - -c
          args:
            - |
              yum -q install -y openssl libtool-ltdl glibmm24 epel-release;
              yum -q install -y fetch-crl;
              rpm -i https://www.desy.de/~tigran/ca_dCacheORG-3.0-6.noarch.rpm;
              rpm -i https://linuxsoft.cern.ch/wlcg/centos7/x86_64/desy-voms-all-1.0.0-1.noarch.rpm;

              curl https://repository.egi.eu/sw/production/cas/1/current/repo-files/egi-trustanchors.repo -o /etc/yum.repos.d/egi-trustanchors.repo
              yum -y install ca_USERTrustRSACertificationAuthority \
                ca_ResearchandEducationTrustRSARootCA \
                ca_GEANTeScienceSSLCA4 \
                ca_USERTrustECCCertificationAuthority \
                ca_GEANTeScienceSSLECCCA4 \
                ca_GEANTTCSAuthenticationRSACA4B;

              curl --silent https://raw.githubusercontent.com/kofemann/autoca/v1.0-py2/pyclient/autoca-client -o /tmp/autoca-client;
              chmod a+x /tmp/autoca-client;
              cd /etc/grid-security/;
              /tmp/autoca-client -n ${AUTOCA_URL} {{ . }};
              chown 994:1000 *.pem;
              /usr/sbin/fetch-crl;

{{- end }}