#!/bin/bash

sleep 15
if curl --output /dev/null --silent --head --fail http://localhost:3000; then
    msg="<!channel>\n[$(date +%T)] : Server is up :white_check_mark:\nDeployment successful."
else
    msg="<!channel>\n[$(date +%T)] : Server is down :x:\nPlease review code or rollback to previous stable version."
fi

[ -f ./slack.sh ] && ./slack.sh "$msg" || 
(curl https://raw.githubusercontent.com/mkyai/scripts/master/slack.sh -o slack.sh && 
chmod +x ./slack.sh && 
./slack.sh "$msg")

