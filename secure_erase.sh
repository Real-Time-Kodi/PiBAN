#!/bin/bash
# This file will use hdparm to determine if a drive can be secure-erased and 
# run the secure-erase. It takes the drive's device node as an argument and
# returns:
# 0: OK
# 1: Drive should be erased manually
# 2: ERROR(Drive is locked)
erase_mode="--security-erase"

sec=$(hdparm -I $1 | pcregrep -M "^Security:.*(\n\t.*)*")

if [ $? -eq 0 ]
then
	echo "Security Supported"
else
	echo "Security not supported."
	exit 1
fi
echo "$sec"

echo "$sec" | grep -q -P "^\tnot\tlocked"
if [ $? -eq 0 ]
then
	echo "Not Locked"
else
	echo "$sec" | grep -q -P "^\t\tlocked"
	if [ $? -eq 0 ]
	then
		echo "Actually Locked"
		#Todo Check if we're unlocked and try again
		sudo hdparm --security-disable "password" $1
		exit 2
	else
		echo "Weird Drive"
		exit 1
	fi
fi

echo "$sec" | grep -q "enhanced erase"
if [ $? -eq 0 ]
then
	echo "Enhanced Security Erase Supported"
	erase_mode="--security-erase-enhanced"
fi

#Lock the drive(To enable security)
hdparm --user-master u --security-set-pass "password" "$1"
#Run our secure-erase
hdparm --user-master u $erase_mode "password" "$1"

exit $?
