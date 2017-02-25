#!/usr/bin/env bash
echo touched >> /var/log/PiEraser.log
echo "${ACTION}" >> /var/log/PiEraser.log

if [ "${ACTION}" = "add" ]
then
    echo "$1" >> /var/log/PiEraser.log
    echo "${DEVPATH}" >> /var/log/PiEraser.log
    echo "${SUBSYSTEM}" >> /var/log/PiEraser.log
    echo "${SYMLINK}" >> /var/log/PiEraser.log
    echo "/usr/local/bin/nuke.sh $1" | batch
fi

