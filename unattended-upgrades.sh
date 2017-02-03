#!/bin/bash
SCRIPTS="/var/scripts"
STATIC="https://raw.githubusercontent.com/ezraholm50/NextBerry/master/static"

# Check if root
if [ "$(whoami)" != "root" ]
then
    echo
    echo -e "\e[31mSorry, you are not root.\n\e[0mYou must type: \e[36msudo \e[0mbash $SCRIPTS/nextberry-upgrade.sh"
    echo
    exit 1
fi

  apt update
  DEBIAN_FRONTEND=noninteractive apt install -y unattended-upgrades \
                                                update-notifier-common

  # Set apt config
  echo "APT::Periodic::Update-Package-Lists "1";" > /etc/apt/apt.conf.d/20auto-upgrades
  echo "APT::Periodic::Unattended-Upgrade "1";" >> /etc/apt/apt.conf.d/20auto-upgrades
  echo "APT::Periodic::Enable "1";" > /etc/apt/apt.conf.d/10periodic
  echo "APT::Periodic::AutocleanInterval "1";" >> /etc/apt/apt.conf.d/10periodic

if [ -f /etc/apt/apt.conf.d/50unattended-upgrades ]
then
  rm /etc/apt/apt.conf.d/50unattended-upgrades
  wget -q $STATIC/50unattended-upgrades -P /etc/apt/apt.conf.d/
else
  wget -q $STATIC/50unattended-upgrades -P /etc/apt/apt.conf.d/
fi
if [ -f /etc/apt/apt.conf.d/50unattended-upgrades ]
then
  chmod 644 /etc/apt/apt.conf.d/50unattended-upgrades
else
  exit 1
fi
