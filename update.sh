#!/bin/bash

# assumes you are running your game server as a service
SERVICE=palworld
# Folder location of steamcmd
STEAMCMDFOLDER=/home/janthony/steamcmd
# name of the folder you used when installing the game via steamcmd
STEAMGAMEFOLDER=${STEAMCMDFOLDER}/Palworld-server
# Steam App ID of the game
STEAMAPPID=2394010

# Check if palworld is running
STATUS="$(systemctl is-active ${SERVICE}.service)"
if [ "${STATUS}" = "active" ]; then
    echo "${SERVICE} is running. Can not update the service." 
else
    echo "${SERVICE} is stopped. Running update command."

    # assumes you have steamcmd installed
    if [[ ! -f "${STEAMCMDFOLDER}/steamcmd.sh" ]]; then
        echo "Failure fetching steamcmd to update ${SERVICE}."
        exit 1
    fi  

    # Perform update
    "${STEAMCMDFOLDER}/steamcmd.sh" +login anonymous +force_install_dir /${STEAMGAMEFOLDER}/Game +app_update ${STEAMAPPID} validate +exit | grep 'Success!'
    result=$?

    if [ $result -ne 0 ]; then
        echo "Failure when running updates for ${SERVICE}."
        exit 1
    fi
fi

