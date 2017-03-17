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

if (echo "$sec" | grep -q -P "^\t\tenabled")
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


if (echo "$sec" | grep -q -P "^\tnot\tlocked")
then
	echo "Drive is Not Locked"
else
	if(echo "$sec" | grep -q -P "^\t\tlocked")
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

if (echo "$sec" | grep -q "enhanced erase")
then
	echo "Enhanced Security Erase Supported"
	if (( $USE_ENHANCED_ERASE ))
	then
		erase_mode="--security-erase-enhanced"
		echo "Enhanced Security Erase will be used. See PiBAN.conf"
	else
		echo "Enhanced Erased supported but not enabled. See PiBAN.conf"
	fi
fi


if (( $DRY_RUN ))
then
	ret=0
	echo "DRY RUN OF SECURE_ERASE COMPLETED"
else
# Enable security
	hdparm --user-master u --security-set-pass "password" $drive
# Run our secure-erase
	sleep 1
	hdparm --user-master u $erase_mode "password" $drive
	ret=$?
# Disable security Just-in-case.
# We really don't care what happens here as long as the command runs. No need
# for logging
	hdparm --user-master u --security-disable "password" $drive &> /dev/null
fi

exit $ret
