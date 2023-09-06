#!/bin/bash

module=$1
moduleTitle=$(echo "$module" | sed 's/\b\w/\u&/g')
modulePath="src/modules/$module"

if [ -d "$modulePath" ]; then
  echo "$module module already exists."
else
    git clone --depth 1 https://github.com/mkyai/prisma-nest-basemodule.git src/modules/$module

    cd src/modules/$module

    rm -rf .git
    
    find . -type f -name "*demo*" | while read filename; do
    newFilename=$(echo $filename | sed "s/demo/$module/g")
    mv $filename $newFilename
    done

    for filename in $(find . -type f); do
    sed -i "s/demo/$module/g" $filename
    done

    find . -type f -print0 | xargs -0 sed -i "s/Demo/$(echo $module | sed 's/\b\w/\u&/')/g"

    cd ..
    importStatement="import { ${moduleTitle}Module } from './$module/$module.module';"
    sed -i "s|// IMPORT_DYNAMIC_MODULE|&\n${importStatement}|" services.module.ts
    sed -i "s|// DYNAMIC_MODULE|&\n${moduleTitle}Module,|" services.module.ts

    cd ..
    cp ./generated/nestjs-dto/create-${module}.dto.ts ./modules/$module/dto/create-${module}.dto.ts
    
    moduleConstants="${module}:{
      create: 'create a new ${module}',
      findAll: 'get all ${module}',
      findOne: 'get one ${module} by id',
      paginate: 'get paginated result of ${module}',
      update: 'update existing ${module}',
      set: 'set ${module}',
      remove: 'delete a ${module}', 
    }"

    awk -v modConst="$moduleConstants" '
    /\/\/ DYNAMIC_MODULE/ {
        print modConst ","
    }
    { print }
    ' ./common/constants/app.constants.ts > tmpfile && mv tmpfile ./common/constants/app.constants.ts

    echo "$module module setup complete."
 fi
