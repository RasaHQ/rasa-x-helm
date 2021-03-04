#!/bin/bash

if [[ ! -f /etc/nginx/terms/agree.txt ]]
then
  echo "you have not agreed to the terms and conditions, Rasa X cannot start. To accept the terms and conditions run echo \"\$\{USER\} \$\(date\)\" > /etc/nginx/terms/agree.txt on the host machine. You can find the terms at https://storage.googleapis.com/rasa-x-releases/rasa_x_ce_license_agreement.pdf"
  exit 1
fi

if [[ ! -e "/etc/nginx/certs/fullchain.pem" ]] || [[ ! -e "/etc/nginx/certs/privkey.pem" ]]
then
  echo "SSL encryption is not used since no certificates were provided."
  # comment out ssl since the user did not provide certificates
  sed -i '\,include[[:blank:]]*/etc/nginx/conf.d/ssl.conf;,s,^,#,g' /etc/nginx/conf.d/rasax.nginx
fi

# exec CMD
echo ">> exec docker CMD"
echo "$@"
exec "$@"
