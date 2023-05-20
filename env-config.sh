#!/bin/bash

json=$(cat env.config)
arr=$(echo $json | jq -r '.[] | @base64')

for obj in $arr; do
    _jq() {
     echo ${obj} | base64 --decode | jq -r ${1}
    }

    name=$(_jq '.name')
    env=$(_jq '.env')

    for key in $(echo $env | jq -r 'keys[]'); do
        value=$(echo $env | jq -r ".[\"${key}\"]")
        echo "${key}=\"${value}\"" > "microservices/${name}/.env"
    done
    echo -e "\nMS=\"${name}\"" >> "microservices/${name}/.env"
done
