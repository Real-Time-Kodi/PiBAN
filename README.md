# Pi-Eraser
Raspberry-pi based hard drive eraser.

WARNING:
This will wipe any block device hooked to the Pi's USB without asking confirmation. Use with extreme caution.


This software consists of several scripts to detect and erase drives:

/etc/udev/rules.d/usbmount.rules - This file is a UDEV rule that should be run last by UDEV. It invokes a script when a new block device is enumerated and passes it on to the next script.
/usr/local/bin/usbmount.sh - This script is called by the UDEV rule and is used to launch the next script via batch to prevent UDEV from killing it.
/usr/local/bin/nuke.sh - 
This script will enable the STATUS LED(if connected) and run shred to erase the disk. This sctipt takes the device path as an argument.

install.sh - First time install script. Sets up the dependencies.
update.sh - Deletes scripts from system folders and coppies them from the git directory.
uninstall.sh - removes scripts to disable functionality.
