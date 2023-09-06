#!/bin/bash

file_path="prisma/schema.prisma"

names=()

while IFS= read -r line; do
    if [[ $line == model* ]]; then
        words=($line)
        if (( ${#words[@]} > 1 )); then
            name="${words[1],,}"
            names+=("$name")
        fi
    fi
done < "$file_path"

npx prisma migrate dev --name dynamic_module

[ -f ./module-setup.sh ] && echo "script exists" || 
(curl https://raw.githubusercontent.com/mkyai/scripts/master/module-setup.sh -o module-setup.sh && 
chmod +x ./module-setup.sh

for name in "${names[@]}"; do
 ./module-setup.sh $name
done

rm -rf src/generated
