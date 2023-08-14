#!/bin/bash
#Auto-Shutdown-Server.sh
let "needsBackup=0"
let "noPlayersCheckLimit=5"
let "playerCheckCount=0"


sleep 300

while [ $playerCheckCount -lt $noPlayersCheckLimit ]
do
    checkUsers=$( mcrcon "list" -r | tr -d ': \n' )
    echo "checkUsers: ${checkUsers}"
    if [ "$checkUsers" == "Thereare0ofamaxof20playersonline" ]; then 
        let "playerCheckCount+=1"
        echo "Increase PlayerCheckCount to: ${playerCheckCount}"
    else
        echo "Reset PlayerCheckCount"
        let "playerCheckCount=0"
        # at least one person played so we will backup
        let "needsBackup=1"
    fi
    $(sleep 60);
done

echo "No Longer in Monitor Loop"
echo ""
echo "playerCheckCount: ${playerCheckCount}"
echo "noPlayersCheckLimit: ${noPlayersCheckLimit}"
echo "needsBackup: ${needsBackup}"
echo ""

echo "Shutting Down Server"
echo $( mcrcon -w 5 "say Server is Shutting Down!" save-all stop )
sleep 30

if [ $needsBackup == 1 ]; then
    echo "Starting Backup"
    $(bash /home/azureuser/minecraft/scripts/auto-backup-server.sh)
    echo "Backup Complete"
fi

echo "Deallocating Server"
az login --identity
az vm deallocate --name $(hostname) --resource-group Game_Hosts