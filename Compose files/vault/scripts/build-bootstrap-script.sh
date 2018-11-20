#!/bin/sh

token=$(docker logs `docker ps -q --filter "name=vault-server-0"` 2>&1 | awk 'BEGIN {FS=":"} /Root Token/ {print $2}')
token=$(echo "$token" | xargs)
echo "found token: $token"
awk -v token="$token" '{ gsub("{{root_token}}",token); print $0}' bootstrap-dev.template.sh > bootstrap-dev.final.sh
echo "built bootstrap script"