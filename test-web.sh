#!/bin/bash

sleep 10
source .env
if curl --output /dev/null --silent --head --fail "$WEB_URL" then
    msg="[FE] Deployment successful :white_check_mark:\n- $(git log -1 --pretty=%B)"
else
    msg="[FE] Deployment failed :x:"
fi

[ -f ./slack.sh ] && ./slack.sh "$msg" || 
(curl https://raw.githubusercontent.com/mkyai/scripts/master/slack.sh -o slack.sh && 
chmod +x ./slack.sh && 
./slack.sh "$msg")
