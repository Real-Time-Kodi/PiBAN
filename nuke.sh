#!/bin/bash
# Usage: nuke.sh [device]
# where [device] is the full path to the device to erase. Ex. /dev/sda

export devname=$(basename $1)
export logprefix="[$devname]: "
#Load our settings file
source /boot/PiBAN/PiBAN.conf
ERASE_COMMAND=$(eval echo "$ERASE_COMMAND")

log()
{
  echo $logprefix$1 >> /var/log/PiBAN.log
  echo $1
}
export -f log #Make logging function available

log "NUKING $1"

#TURN ON LED
gpio -g mode 17 out
gpio -g write 17 1

if (( $ENABLE_ATA_SECURE_ERASE ))
then
	log "Attemting ATA secure erase."
	/opt/PiBAN/secure_erase.sh $1
	res=$?
else
	#This could use some work.
	res=1
fi

if [ $res -eq 0 ]
then
	log "ATA Secure erase successful."
fi
if [ $res -eq 1 ]
then
	log "ATA Secure erase not supported/enabled. Using fallback."
	if (( $DRY_RUN ))
	then
		log "DRY RUN, NO ERASE HAPPENING."
	else
		$ERASE_COMMAND
	fi
fi
if [ $res -eq 2 ]
then
	log "Drive is locked. Aborting."
	gpio -g write 17 0
	return 2
fi

if [[ $CREATE_FILESYSTEM -eq 1 ]] && [[ $DRY_RUN -eq 0 ]]
then
# The following ugly mess creates a new partition table with one partition
# that takes up the whole disk.
	log "Creating Partiton table."
	echo "o
n
p



w

" | fdisk "$1" > /dev/null
# Make our filesystem
# Check what FS we should use
	log "Creating filesystem: FAT32"
	mkfs.vfat -v -F 32 "$1"1
# Mount our new filesystem
	log "Mounting filesystem"
	mntpath=/mnt/$(basename "$1")1
	rm -r $mntpath &> /dev/null
	mkdir $mntpath
	mount -o sync "$1"1 $mntpath
	cd $mntpath

# Check if we should run a script and run it here
	if [[ -n $RUN_SCRIPT ]]
	then
		log "Running scipt: $RUN_SCRIPT"
		$RUN_SCRIPT $1
	fi

# Check if we should copy files and do that here
	if [[ -n $COPY_FILES ]]
	then
		log "Copying Files from $COPY_FILES"
		cp -r $COPY_FILES .
	fi

	if (( $COPY_LOGS ))
	then
		log "Copying LOGS"
		touch Erased_With_PiBAN.txt
		echo -e "This drive has been securely erased and repartitioned with PiBAN\n\
https://github.com/Real-Time-Kodi/PiBAN" > Erased_With_PiBAN.txt
	#Let's also copy our log file to the device.
		cp /tmp/$devname.log .
	fi

# Unmount our filesystem
	log "Unmounting filesystem"
	cd /
	umount $mntpath
	rm -r $mntpath
else
	cd /
	if [[ -n $DD ]]
	then
		log "Copying Image to $1"
		dd if=$DD of=$1 bs=1M
		log "DD Exited with status: $?"
	fi
	if [[ -n $RUN_SCRIPT ]]
        then
                log "Running scipt: $RUN_SCRIPT"
                $RUN_SCRIPT $1
        fi
fi


sync #SYNC because I don't trust the kernel to do it for me.
#TURN OFF LED
gpio -g write 17 0

log "Drive Completed $1"
