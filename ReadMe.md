Server Requirements:
# Required to run steamCMD
```
sudo apt install -y vim screen wget lib32gcc-s1
```

# Required to Run 7d2d (C++ redist)
```
sudo apt update
sudo apt install build-essential
```

# install steamCMD
`wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz`

`tar -xvf steamcmd_linux.tar.gz`

`chmod +x steamcmd.sh`

`./steamcmd.sh`

`force_install_dir ./7days`
`login anonymous`
`app_update 294420`
`quit`

# Open Firewall
`sudo ufw allow 26900:26905/tcp && sudo ufw allow 26900:26905/udp`

# 7d2d Config
It is important to enable telnet (only from local host by not setting a password).

# xmlstarlet for parsing xml in bash
`sudo apt-get install xmlstarlet`

# AzCopy for Backups to Azure Blob Storage
`sudo bash -c 'cd /usr/local/bin; curl -L https://aka.ms/downloadazcopy-v10-linux | tar --strip-components=1 --exclude=*.txt -xzvf -; chmod +x azcopy'`

#Az CLI
`curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash`

Server Scripts:
Auto-Start-Server.sh
Auto-Backup.sh
Auto-Monitor-Server.sh

# Environment Var Setup (In backups script)
STORAGE_ACCOUNT_NAME="Your Blob Storage Account Name"
GAME_SAVE_CONTAINER="Your Blob Storage Container Name for Game Saves"
GAME_WORLD_CONTAINER="Your Blob Storage Container Name for World Saves"

#Service Settings
Place service files here:
/etc/systemd/system

`sudo systemctl enable 7d2d.service`

`sudo systemctl enable 7d2d-Monitor.service`

# helpful commands
`journalctl -u 7d2d.service -b -f`

`journalctl -u 7d2d-Monitor.service -b -f`

`tail -f ~/7days/7DaysToDieServer_Data/` output_log__2023-08-07__04-08-27.txt

To create the tar file
`tar -cvzf filename.tar .`

To transfer to the server
`scp -i ...key.pem "local.tar" azureuser@x.xxx.xxx.xxx:/home/azureuser/7days/Data/Worlds`


# Minecraft
sudo apt update

## Install Java
- sudo add-apt-repository ppa:openjdk-r/ppa
- sudo apt update
- sudo apt install openjdk-21-jre-headless (NO GUI, SMALLER)

## Version Check
- java -version

## Install Minecraft (For non-Modded)
- wget https://piston-data.mojang.com/v1/objects/84194a2f286ef7c14ed7ce0090dba59902951553/server.jar
- java -Xms1024M -Xmx7517M -jar server.jar nogui
- accept eula
- java -Xms1024M -Xmx7517M -jar server.jar nogui


## Install neoForge (For Modded)
- wget https://maven.neoforged.net/releases/net/neoforged/neoforge/21.1.137/neoforge-21.1.137-installer.jar
- java -jar forge-1.20.1-47.1.3-installer.jar --installServer

## Install RCON (Minecrafts Telnet for scripts)
Set up GCC:
- sudo apt update
- sudo apt install git build-essential
- git clone https://github.com/Tiiffi/mcrcon.git ~/tools/mcrcon
- cd ~/tools/mcrcon
- gcc -std=gnu11 -pedantic -Wall -Wextra -O2 -s -o mcrcon mcrcon.c

## Version Check
- ./mcrcon -v

Set up ENV:
- MCRCON_HOST=127.0.0.1
- MCRCON_PORT=55565
- MCRCON_PASS=

    created in ./scripts/env/env_file and referenced in service

## Enable Service
sudo systemctl enable minecraft.service
sudo systemctl enable minecraft-monitor.service

# Open Firewall
`sudo ufw allow 25565:26905/tcp && sudo ufw allow 25565:26905/udp`

## copy mods to server
scp -i ...key.pem "local.tar" azureuser@x.xxx.xxx.xxx:/home/azureuser/minecraft/mods/servermods.tar

tar -xvf ./servermods.tar

journalctl -u minecraft.service -b -f
journalctl -u minecraft-monitor.service -b -f
