#!/bin/bash

cd microservices

for dir in */; 
do
  dir=${dir%*/}

  cp .env "$dir"/.env
  echo -e "\nMS=\"${dir#microservices/}\"" >> "${dir}/.env"

done