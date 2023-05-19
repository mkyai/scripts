#!bin/bash

sleep 15
if curl --output /dev/null --silent --head --fail http://localhost:3000; then
    slack.sh '<!channel>\n[($date +%T)] : Server is up :arrows_counterclockwise:\nDeployment successful.'
else
    slack.sh '<!channel>\n[($date +%T)] : Server is down :x:\nPlease review code or rollback to previous stable version.'
fi