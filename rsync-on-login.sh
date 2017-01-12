#!/bin/bash
# This scripts checks if your are connected to your predifened static LAN IP, if so then rsync to remote server

# Variables
IPLAN="" # Static LAN IP
ADDRESS=$(/sbin/ip route get 1 | awk '{print $NF;exit}') # IP script checks
REMOTE="" # Requires ssh keys to be setup
FOLDERS="" # To be backed up
PORT="" # SSH port

# Excludes
EXCLUDE=""

  if [ "$ADDRESS" == "$IPLAN" ]; then
    rsync -aAXv "$EXCLUDE" -e 'ssh -p $PORT' "$REMOTE":"$FOLDERS"
  else
    echo
    echo "Not on right network to perform rsync backup..."
    echo
  fi
  
exit
