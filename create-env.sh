#!/bin/bash

random() {
  cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1
}

database() {
  echo "postgres://$DATABASE_USER:$DATABASE_PASSWORD@postgres:5432/$DATABASE_NAME"
}

ENV=$1
JWT="$(random)"
DATABASE_USER="$(random)"
DATABASE_PASSWORD="$(random)"
DATABASE_NAME="$(random)"


echo "NODE_ENV=$ENV" > .env
echo "REDIS_HOST='redis'" >> .env
echo "JWT_SECRET=$JWT" >> .env
echo "DATABASE_NAME=$DATABASE_NAME" >> .env
echo "DATABASE_USER=$DATABASE_USER" >> .env
echo "DATABASE_PASSWORD=$DATABASE_PASSWORD" >> .env
echo "DATABASE_URL=$(database)" >> .env

for dir in microservices/*/

do
  
  dir=${dir%*/}
  cp .env "$dir"/.env
  echo -e "\nMS=\"${dir#microservices/}\"" >> "${dir}/.env"

done
