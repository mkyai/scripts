#!/bin/bash

sleep 15
if curl --output /dev/null --silent --head --fail http://localhost:3000; then
    msg="<!channel>\nDeployment successful :white_check_mark:"
else
    msg="<!channel>\nDeployment failed :x:"
fi

[ -f ./slack.sh ] && ./slack.sh "$msg" || 
(curl https://raw.githubusercontent.com/mkyai/scripts/master/slack.sh -o slack.sh && 
chmod +x ./slack.sh && 
./slack.sh "$msg")

