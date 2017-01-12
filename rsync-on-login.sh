#!/bin/bash
# This scripts checks if your are connected to your predifened static LAN IP, if so then rsync to remote server
#
# Only tested on Ubuntu 16.04
# IMPORTANT FIRST DO THIS!!
# First type: sudo visudo
# then add this line to the bottom of the file (except if you're running it as root): username-to-run-script ALL = (root) NOPASSWD: /etc/init.d/rsync

# Variables
USER="" # Run script as
IPLAN="" # Static LAN IP
ADDRESS=$(/sbin/ip route get 1 | awk '{print $NF;exit}') # IP script checks
REMOTEHOST="" # Requires ssh keys to be setup
REMOTEDIR="" # Remote Directory to store backup in, be sure that you have permission
DIR="" # Directory be backed up
PORT="" # SSH port
EXCLUDE="" # Directorys to exclude
EXCLUDESYS="--exclude=/proc/* --exclude=/lost+found/* --exclude=/sys/*"

# Run this script on login
cat <<-LOGIN > "/home/$USER/.profile"

################# Rsync script ##################
adddate() {
    while IFS= read -r line; do
        echo "$(date) $line"
    done
}

touch /var/log/rsync-login.log

echo "##############################################################################################################" >> /var/log/rsync-login.log
bash /var/scripts/rsync-on-login.sh | adddate >> /var/log/rsync-login.log 2>&1
################# Rsync script ##################
LOGIN

# Remove line 19 to 36, only need it once
 sed -e '19,36d' /var/scripts/rsync-on-login

# Check if rsync is installed
if [ $(dpkg-query -W -f='${Status}' rsync 2>/dev/null | grep -c "ok installed") -eq 1 ]; then
      echo "Rsync is installed..."
      clear
else
    echo
    echo "You don't have rsync installed. Please, first run: sudo apt update; apt install rsync -y"
    echo
    echo "Then run the script again... We will exit the script in 10 seconds..."
    echo
    sleep 10
    exit
fi

# Check if we're the right user
  if [ "$(whoami)" != "$USER" ]; then
    echo
    echo "Not the right user for rsync backup..."
    echo
    exit
  fi

# Rsync
  if [ "$ADDRESS" == "$IPLAN" ]; then
    rsync -aAXv "$EXCLUDE" "$EXCLUDESYS" -e "ssh -p $PORT" "$DIR" "$REMOTEHOST":"$REMOTEDIR"
  else
    echo
    echo "Not on right network to perform rsync backup..."
    echo
    exit
  fi

exit
