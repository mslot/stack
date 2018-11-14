#!/bin/bash
set -eo pipefail
. Discovery.sh

service_name=""
tags=""
discovery_service_url=""

if [ -z $SERVICE_TYPE ]; then
    echo "service type needs to be supplied"
    exit 1
fi

if [ -z $DISCOVERY_SERVICE ]; then
    echo "discovery service url not supplied"
    exit 1
fi

if [ -z $SERVICE_PORT ]; then 
    echo "discovery service port not supplied"
    exit 1
fi

if [ -z $SERVICE_TAGS ]; then
    echo "no tags supplied"
    tags=""
fi

if [ -z $SERVICE_NAME ]; then
    service_name=$(hostname)
else
    service_name=$SERVICE_NAME;
fi

echo "all environment variables set correct"

discovery_service_url="$DISCOVERY_SERVICE:$SERVICE_PORT"

echo "Discover service url generated: $discovery_service_url"

count=$(discovery_count_registered_services_of_type $discovery_service_url $SERVICE_TYPE $SERVICE_TAGS)

echo "numbers of services of type $SERVICE_TYPE: $count"

if [ $count != 0 ]; then
  echo "data dir created"
  mkdir -p /var/lib/mysql/mysql
else
  echo "No data dir created"
fi

if [ $count == 0 ]; then
  echo "setting environment variable for creating new cluster"
  export _WSREP_NEW_CLUSTER='--wsrep-new-cluster' 
fi

discovery_subscribe $discovery_service_url $service_name $SERVICE_TYPE $SERVICE_PORT $SERVICE_TAGS
discovery_write_server_config $discovery_service_url $SERVICE_TYPE 
/usr/local/bin/docker-entrypoint.sh "$@"