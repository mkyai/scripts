#!/bin/bash

for dir in microservices/*/

do
  
  dir=${dir%*/}
  cp .env "$dir"/.env
  echo -e "\nMS=\"${dir#microservices/}\"" >> "${dir}/.env"

done
