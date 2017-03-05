#!/usr/bin/env bash
echo "Detected new device: $1" >>/var/log/PiBAN.log
devname=$(basename $1)
logname=/tmp/$devname.log
if [ "${ACTION}" = "add" ]
then
{
    echo "/usr/local/bin/nuke.sh $1 &> $logname" | at now
} &
fi

