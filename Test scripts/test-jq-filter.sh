#!/bin/bash
. "../MariaDB build/Scripts/Discovery.sh"

a=$(curl -s "http://localhost:8500/v1/catalog/service/mariadb?pretty" | jq '.[].Address')

ips=$(sed "s/\"//g"<<<$a | tr '\n' ',')
ips=${ips::-1}

echo $ips