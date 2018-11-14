#!/bin/bash

. "../MariaDB build/Scripts/Discovery.sh"

export DISCOVERY_SERVICE=localhost
export SERVICE_NAME=fallback_name
export SERVICE_TYPE=mariadb
export SERVICE_PORT=8500
export SERVICE_TAGS=database,node
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

if [ -z service_name ]; then
    echo "no service name could be resolved"
    exit 1
fi
discovery_service_url="$DISCOVERY_SERVICE:$SERVICE_PORT"
c=$(discovery_count_registered_services_of_type $discovery_service_url $SERVICE_TYPE $SERVICE_TAGS)
echo "numbers of services of type $SERVICE_TYPE: $c"

if [ $c == 0 ]; then
    echo "c is 0"
fi

if [ $c != 0 ]; then
    echo "c is not 0"
fi

discovery_subscribe $discovery_service_url $service_name $SERVICE_TYPE $SERVICE_PORT $SERVICE_TAGS