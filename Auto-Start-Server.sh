#!/bin/bash
#Auto-Start-Server.sh

checkConn=$(echo "" | ncat -i 2 localhost 8081)
if [[ $checkConn == *"TelnetClient_127.0.0.1"* ]]; then
    echo "Server Already Running"
else
    echo "Starting Server"
    /home/azureuser/7days/startserver.sh -configfile=serverconfig.xml
fi