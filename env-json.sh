#!/bin/bash
default="common"
json_file="env.json"
awk -F ':' 'NR>1 && NR!=total_lines+1{key=$1; sub(/^[ \t]+/, "", key); value=substr($0, index($0,$2)); gsub(/^[ \t:"]+|[ \t",]+$/, "", value); print key"=\""value"\""}' total_lines=$(wc -l < "$json_file") "$json_file" > .env
echo -e "\n$(cat env.${1:-$default})" >> .env 
