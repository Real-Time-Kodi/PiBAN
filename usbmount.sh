#!/usr/bin/env bash
echo "Detected new device: $1" >>/var/log/PiBAN.log
devname=$(basename $1)
logname=/tmp/$devname.log
if [ "${ACTION}" = "add" ]
then
    /usr/local/bin/hack.sh $1 $logname & disown
fi

