Server Requirements:
# Required to run steamCMD
sudo apt install -y vim screen wget lib32gcc-s1

# install steamCMD
wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz

tar -xvf steamcmd_linux.tar.gz

./steamcmd.sh
    force_install_dir ./7days
    login anonymous
    app_update 294420
    quit

# Open Firewall
sudo ufw allow 26900:26905/tcp && sudo ufw allow 26900:26905/udp

# 7d2d Config
It is important to enable telnet (only from local host by not setting a password).

# xmlstarlet for parsing xml in bash
sudo apt-get install xmlstarlet

# AzCopy for Backups to Azure Blob Storage
sudo bash -c 'cd /usr/local/bin; curl -L https://aka.ms/downloadazcopy-v10-linux | tar --strip-components=1 --exclude=*.txt -xzvf -; chmod +x azcopy'


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

sudo systemctl enable 7d2d.service
sudo systemctl enable 7d2d-Monitor.service

# helpful commands
journalctl -u 7d2d.service -b -f
journalctl -u 7d2d-Monitor.service -b -f
tail -f ~/7days/7DaysToDieServer_Data/output_log__2023-08-07__04-08-27.txt
scp -i ...key.pem "local.tar" azureuser@x.xxx.xxx.xxx:/home/azureuser/7days/Data/Worlds
