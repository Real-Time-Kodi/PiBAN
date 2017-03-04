#!/bin/bash
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
# TODO: attempt to unlock with password "password"
		echo "Actually Locked"
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

echo "HDPARM COMMANDS COMMENTED OUT"
#hdparm --user-master u --security-set-pass "password" "$1"
#hdparm --user-master u $erase_mode "password" "$1"

exit $?
