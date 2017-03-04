#!/bin/bash
erase_mode="--security-erase"

hdparm -I $1 | pcregrep -M "^Security:.*(\n\t.*)*" > tmp.txt
if [ $? -eq 0 ]
then
	echo "Security Supported"
else
	echo "Security not supported."
	exit 1
fi

grep -q -P "^\tnot\tlocked" tmp.txt
if [ $? -eq 0 ]
then
	echo "Not Locked"
else
	grep -q -P "^\t\tlocked" tmp.txt
	echo "LOCKED!! $?"
# TODO: attempt to unlock with password "password"
fi

grep -q "enhanced erase" tmp.txt
if [ $? -eq 0 ]
then
	echo "Enhanced Security Erase Supported"
	erase_mode="--security-erase-enhanced"
fi

rm tmp.txt

echo "HDPARM COMMANDS COMMENTED OUT"
#hdparm --user-master u --security-set-pass "password" "$1"
#hdparm --user-master u $erase_mode "password" "$1"

exit 0
