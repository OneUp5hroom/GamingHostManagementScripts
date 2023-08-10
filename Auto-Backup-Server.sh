#!/bin/sh

#Blob Storage Coinfiguration
STORAGE_ACCOUNT_NAME=""
GAME_WORLD_CONTAINER=""
GAME_SAVE_CONTAINER=""

#Az Copy Creds
export AZCOPY_AUTO_LOGIN_TYPE=MSI

# Get Current World Name
worldName=$(xmlstarlet sel -T -t -m '//property[@name="GameWorld"]/@value' -v . -n /home/azureuser/7days/serverconfig.xml)

# Validate World is backed up
az login --identity
blobs=$(az storage blob list --account-name ${STORAGE_ACCOUNT_NAME} --container-name ${GAME_WORLD_CONTAINER} --auth-mode login --query "[].name")

worldSaveName="${worldName}.tar.gz" 
if [[ ! " ${blobs[*]} " =~ "$worldSaveName" ]]; then
    tar --force-local -zcvf $worldSaveName /home/azureuser/7days/Data/Worlds/${worldName}
    azcopy copy ./${worldSaveName} "https://${STORAGE_ACCOUNT_NAME}.blob.core.windows.net/${GAME_WORLD_CONTAINER}/${worldSaveName}"
    rm ./${worldSaveName}
else
    echo "World Already Backed Up"
fi

#Server Data Backup
currentTime=$(date --utc +%FT%TZ)
saveName="${currentTime}-${worldName}.tar.gz"
tar --force-local -zcvf $saveName /home/azureuser/.local/share/7DaysToDie/Saves/${worldName}
azcopy copy ./${saveName} "https://${STORAGE_ACCOUNT_NAME}.blob.core.windows.net/${GAME_SAVE_CONTAINER}/${saveName}"
rm ./${saveName}