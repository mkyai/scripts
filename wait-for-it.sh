#!/bin/bash

until curl $1 2> /dev/null; do
  echo "Waiting for service..."
  sleep 2; 
done
