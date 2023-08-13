#!/bin/bash

#Blob Storage Coinfiguration
STORAGE_ACCOUNT_NAME=""
GAME_SAVE_CONTAINER=""
WORLD_NAME=""

#Az Copy Creds
export AZCOPY_AUTO_LOGIN_TYPE=MSI

#Server Data Backup
currentTime=$(date --utc +%FT%TZ)
saveName="${currentTime}-${WORLD_NAME}.tar.gz"
tar --force-local -zcvf $saveName /home/azureuser/minecraft/${WORLD_NAME}
azcopy copy ./${saveName} "https://${STORAGE_ACCOUNT_NAME}.blob.core.windows.net/${GAME_SAVE_CONTAINER}/${saveName}"
rm ./${saveName}

# How to disable saving / save a live running Minecraft Server
#/save-all - forces the server to save.
#/save-off - disables saving. You should definitely execute this before making a backup of a running server to ensure that the server doesn't save while you're copying, which could result in a corrupt backup.
#/save-on - re-enables saving.