#!/bin/bash

cd microservices

for dir in */; 
do
    cd "$dir"

    echo "Installing dependency in $dir"
    npm i

    cd ..
done