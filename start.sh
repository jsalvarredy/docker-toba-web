#!/bin/bash
set -e


if [ ! -z "$RECONFIGURE" ]; then
	cd /ansible/
	ansible-playbook toba-web.yml -c local
fi

source /etc/apache2/envvars

# Map www-data uid to specified USER_ID. If no specified, uid 1000 will be used
if [ ! -z "$USER_ID" ]; then
  usermod -u $USER_ID $APACHE_RUN_USER
else
  usermod -u 1000 $APACHE_RUN_USER
fi

apache2 -DFOREGROUND

