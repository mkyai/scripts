#!/bin/bash

env_file=".env"
echo "Enter the path to your .env file (e.g: stage.env):"
read env_file_name

if [ -f "$env_file_name" ]; then
    env_file=$env_file_name
fi

if ! [ -x "$(command -v gh)" ]; then
    echo "GitHub CLI is not installed. Please install it and try again."
    exit 1
fi

echo "Where do you want to set the environment variables? [secret | variable]"
read env_type

if [ -z "$env_type" ]; then
    echo "Environment type is required"
    exit 1
fi

if [ "$env_type" != "secret" ] && [ "$env_type" != "variable" ]; then
    echo "Invalid environment type provided. Please provide either 'secret' or 'variable' as the environment type"
    exit 1
fi

echo "Enter the name of the repository (e.g: username/repo):"
read repo

if [ -z "$repo" ]; then
    echo "Repository name is required"
    exit 1
fi

if [ -f "$env_file" ]; then

    while IFS='=' read -r key value || [ -n "$key" ];
    do
        if [ -z "$key" ]; then
            continue
        fi

        if [[ $key == \#* ]]; then
            continue
        fi

        echo "Setting $key=$value"
        gh $env_type set $key -b $value --repo $repo

    done < "$env_file"

    echo "Environment variables set successfully"
   
else
    echo "File not found"
fi
