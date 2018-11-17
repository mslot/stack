#!/bin/bash

function discovery_subscribe()
{
    tags=""
    url="http://$1/v1/agent/service/register"
    name=$2;
    if [ -n "$5" ]; then
        IFS=',' list=($5)
        for item in "${list[@]}"; do tags+="\"$item\","; done
        tags=${tags::-1};
    fi

    payload=$(</usr/local/bin/payload.json); # move payload.json file out to other folder!!
    payload=$(sed "s/{{id}}/$name/g" <<< $payload);
    payload=$(sed "s/{{name}}/$3/g" <<< $payload);
    payload=$(sed "s/{{tags}}/$tags/g" <<< $payload);
    payload=$(sed "s/{{port}}/$4/g" <<< $payload);
    payload=$(sed "s/{{address}}/$name/g" <<< $payload);

    echo "this was sent to discovery service: $1"
    echo "$payload";
    echo $url

    curl --request PUT --data "$payload" "$url"
}

function discovery_count_registered_services_of_type()
{
    url="http://$1/v1/catalog/service/$2?pretty"
    curl -s "$url" | jq length
}

function discovery_write_server_config()
{
    echo "begin to write server config"
    url="http://$1/v1/catalog/service/$2?pretty"

    a=$(curl -s "$url" | jq '.[].ServiceAddress')

    echo "got address: $a"

    ips=$(sed "s/\"//g"<<<$a | tr '\n' ',')
    ips=${ips::-1}

    echo "writing server config"
    mkdir -p /etc/mysql/conf.d
    sed "s/{{ip}}/$ips/g" /usr/local/bin/server.template.cnf > /etc/mysql/conf.d/server.cnf #move template.cnf to other folder!!
    echo "server config written"
}

function discovery_unsubscribe()
{
    #node - string - can only be retrieved by calling http://127.0.0.1:8500/v1/catalog/service/SERVICE_TYPE 
    #and find the entry with the correct ServiceID (this is calculated by calling discovery_make_service_name)
    #ServiceID - streng - this is located by calling discovery_make_service_name
    #curl --request PUT http://127.0.0.1:8500/v1/agent/service/deregister/my-service-id
    echo "not implemented yet"
    exit 1;
}