#!/bin/bash
# This file will use hdparm to determine if a drive can be secure-erased and 
# run the secure-erase. It takes the drive's device node as an argument and
# returns:
# 0: OK
# 1: Drive should be erased manually
# 2: ERROR(Drive is locked)
# Note that we aren't checking for freezing because it shouldn't happen on a
# raspi.
erase_mode="--security-erase"
drive=$1

# Determine if our drive supports security using HDPARM. If it does, 
# Store it and return 0 else return 1
readSecurity() {
	sec=$(hdparm -I $drive | pcregrep -M "^Security:.*(\n\t.*)*")
	return $?
}

if readSecurity
then
	echo "Security Supported"
else
	echo "Security not supported."
	exit 1
fi
echo "$sec"

echo "$sec" | grep -q -P "^\t\tenabled"
if [ $? -eq 0 ]
then
	echo "Security enabled. Attempting to disable."
	if hdparm --user-master u --security-disable "password" $drive
	then
		echo "Disabled Successfully"
		#Update $sec for the next group of ifs.
		readSecurity
	else
		echo "Disable failed."
		exit 1
	fi
fi


echo "$sec" | grep -q -P "^\tnot\tlocked"
if [ $? -eq 0 ]
then
	echo "Not Locked"
else
	echo "$sec" | grep -q -P "^\t\tlocked"
	if [ $? -eq 0 ]
	then
		echo "Weird drive(locked but security disabled)"
		#Half-assed attempt to unlock the drive. If we're at this line
		#and the drive is locked, there's something wrong.
		if hdparm --user-master u --security-unlock "password" $drive
		then
		#once again, if we're here, we've failed to disable security, so we'll use fallback
			exit 1
		else
			exit 2
		fi
	else
		#This is here because I have a weird drive that reports that it
		#Supports secure erase, but not security. Just use a fallback in
		#that case.
		echo "Weird Drive(not locked or unlocked)"
		exit 1
	fi
fi

echo "$sec" | grep -q "enhanced erase"
if [ $? -eq 0 ]
then
	echo "Enhanced Security Erase Supported"
	erase_mode="--security-erase-enhanced"
fi


#Enable security
hdparm --user-master u --security-set-pass "password" $drive
#Run our secure-erase
hdparm --user-master u $erase_mode "password" $drive

exit $?
