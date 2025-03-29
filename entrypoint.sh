#!/bin/sh
HOST=$(hostname -i)
HOSTNAME=$(hostname)
export HOST HOSTNAME
envsubst < /usr/share/nginx/html/index.template.html > /usr/share/nginx/html/index.html
exec nginx -g "daemon off;"
