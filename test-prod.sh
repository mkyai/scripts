#!/bin/bash

sleep 15
if curl --output /dev/null --silent --head --fail http://localhost:3000; then
    msg="[PROD] Deployment successful :white_check_mark:\n- $(git log -1 --pretty=%B)"
else
    msg="[PROD] Deployment failed :x:"
fi

[ -f ./slack.sh ] && ./slack.sh "$msg" || 
(curl https://raw.githubusercontent.com/mkyai/scripts/master/slack.sh -o slack.sh && 
chmod +x ./slack.sh && 
./slack.sh "$msg")
