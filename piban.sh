#!/bin/bash
echo "Detected new device: $1" >>/var/log/PiBAN.log

logname=/tmp/$1.log

/opt/PiBAN/nuke.sh /dev/$1 >$logname
