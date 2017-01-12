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

# Ubuntu check
DISTRO=$(lsb_release -sd | cut -d ' ' -f 2)
version(){
    local h t v

    [[ $2 = "$1" || $2 = "$3" ]] && return 0

    v=$(printf '%s\n' "$@" | sort -V)
    h=$(head -n1 <<<"$v")
    t=$(tail -n1 <<<"$v")

    [[ $2 != "$h" && $2 != "$t" ]]
}

if ! version 16.04 "$DISTRO" 16.04.10; then
    echo
    echo "Ubuntu version $DISTRO is tested on 16.04 - 16.04.10 no support is given for other releases or distro's." 20 60
    echo
    exit
fi

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
    rsync -aAXv "$EXCLUDE" -e "ssh -p $PORT" "$DIR" "$REMOTEHOST":"$REMOTEDIR"
  else
    echo
    echo "Not on right network to perform rsync backup..."
    echo
    exit
  fi

exit
