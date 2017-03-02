#!/usr/bin/env bash
echo "Detected new device: $1" >/var/log/PiBAN.log
if [ "${ACTION}" = "add" ]
then
    /usr/local/bin/nuke.sh $1 & disown
fi

