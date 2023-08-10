#!/bin/bash
#Auto-Shutdown-Server.sh
let "needsBackup=0"
let "noPlayersCheckLimit=5"
let "playerCheckCount=0"

sleep 300

while [ $playerCheckCount -lt $noPlayersCheckLimit ]
do
    checkUsers=$( { echo "lp" && sleep 2 && echo "exit"; } | telnet localhost 8081 | grep -P "Total of \d in the game" )
    echo "checkUsers: ${checkUsers}"
    if [ "$checkUsers" == "Total of 0 in the game" ]; then 
        let "playerCheckCount+=1"
        echo "Increase PlayerCheckCount to: ${playerCheckCount}"
        # at least one person played so we will backup
        let "needsBackup=1"
    else
        echo "Reset PlayerCheckCount"
        let "playerCheckCount=0"
    fi
    $(sleep 60);
done

echo "No Longer in Monitor Loop"
echo ""
echo "playerCheckCount: ${playerCheckCount}"
echo "noPlayersCheckLimit: ${noPlayersCheckLimit}"
echo "needsBackup: ${needsBackup}"
echo ""

if [[ $playerCheckCount -ge $noPlayersCheckLimit ]] && [ $needsBackup == 1 ]; then
    echo "Shutting Down Server"
    echo $(echo "shutdown" | ncat localhost 8081)
    sleep 120
    echo "Starting Backup"
    $(bash /home/azureuser/7days/scripts/Auto-Backup-Server.sh)
    echo "Backup Complete"
    echo "Deallocating Server"
    az login --identity
    az vm deallocate --name $(hostname) --resource-group 7d2d
fi