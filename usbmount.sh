#!/usr/bin/env bash
echo "${ACTION}" >> /var/log/PiBAN.log

if [ "${ACTION}" = "add" ]
then
    echo "$1" >> /var/log/PiBAN.log
    echo "${DEVPATH}" >> /var/log/PiBAN.log
    echo "${SUBSYSTEM}" >> /var/log/PiBAN.log
    echo "${SYMLINK}" >> /var/log/PiBAN.log
    echo "/usr/local/bin/nuke.sh $1" | batch
fi

