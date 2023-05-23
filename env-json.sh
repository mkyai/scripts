#!/bin/bash
default="common"
json_file="env.json"
awk -F ':' '!/^[ \t]*[{}]/ {key=$1; gsub(/^[ \t"]+|[ \t"]+$/, "", key); value=substr($0, index($0,$2)); gsub(/^[ \t:"]+|[ \t",]+$/, "", value); print key "=" "\"" value "\""}' "$json_file" > .env
total_lines=$(wc -l < "$json_file")
echo -e "\n$(cat env.${1:-$default})" >> .env 
