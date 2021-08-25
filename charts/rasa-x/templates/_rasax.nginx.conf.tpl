{{- define "rasax.nginx.template" -}}
upstream docker-rasax-api {
  server ${RASA_X_HOST} max_fails=0;
}

server {
  listen            8080;
#  include           /etc/nginx/conf.d/ssl.conf; # uncomment if using ssl; see ssl.conf.template for example configuration

  keepalive_timeout   30;
  client_max_body_size 800M;

  location {{ trimSuffix "/" .Values.nginx.subPath }}/robots.txt {
    return 200 "User-agent: *\nDisallow: /\n";
  }

{{- if or .Values.rasa.versions.rasaProduction.enabled .Values.rasa.versions.rasaProduction.external.enabled }}
  location {{ trimSuffix "/" .Values.nginx.subPath }}/core/ {
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $remote_addr;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header Host $host;
    proxy_pass {{ include "rasa.production.url" .}};
  }

  # avoid users having to change how they configure
  # their credentials URLs between Rasa and Rasa X
  location {{ trimSuffix "/" .Values.nginx.subPath }}/webhooks/ {
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $remote_addr;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header Host $host;
    proxy_pass {{ include "rasa.production.url" .}}/webhooks/;
  }

  location {{ trimSuffix "/" .Values.nginx.subPath }}/socket.io {
    proxy_http_version 1.1;
    proxy_buffering off;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $remote_addr;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "Upgrade";
    proxy_pass {{ include "rasa.production.url" .}}/socket.io;
  }

{{- end }}

  location {{ trimSuffix "/" .Values.nginx.subPath }}/api/ws {
    # following https://www.serverlab.ca/tutorials/linux/web-servers-linux/how-to-configure-nginx-for-websockets/
    # This directive converts the incoming connection to HTTP 1.1, which is
    # required to support WebSockets. The older HTTP 1.0 spec does not provide support
    # for WebSockets, and any requests using HTTP 1.0 will fail.
    proxy_http_version 1.1;
    # Converts the proxied connection to type Upgrade. WebSockets only communicate on
    # Upgraded connections.
    proxy_set_header Upgrade $http_upgrade;
    # Ensure the Connection header value is upgrade
    proxy_set_header Connection "upgrade";

    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $remote_addr;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header Host $host;
    proxy_pass http://docker-rasax-api/api/ws;
  }

  location {{ trimSuffix "/" .Values.nginx.subPath }}/ {
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $remote_addr;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header Host $host;
    proxy_pass http://docker-rasax-api/;
  }

  # pass chat message to production service if environment query parameter
  # is set to `production`, or that parameter isn't set
  location {{ trimSuffix "/" .Values.nginx.subPath }}/api/chat$ {
    if ($arg_environment = "") {
        rewrite ^ /core/webhooks/rasa/webhook last;
    }
    if ($arg_environment = "production") {
        rewrite ^ /core/webhooks/rasa/webhook last;
    }
    proxy_pass http://docker-rasax-api/api/chat;
  }

  location {{ trimSuffix "/" .Values.nginx.subPath }}/nginx_status {
    stub_status on;

    access_log off;
    allow 127.0.0.1;
    deny all;
  }
}
{{- end -}}
