# Pi-Eraser
Automatic Raspberry-pi based secure hard drive eraser. This will erase any block device plugged into the USB bus using the shred command. It will then create a partition table and a single FAT32 partition to make the drive immediately usable. This behaviour is easily changed.

# WARNING:
 * This will wipe any block device hooked to the Pi's USB without asking confirmation. Use with extreme caution.
 * This software could potentially leave data in reallocated blocks. This is especially a problem on flash media.


### Scripts
This software consists of several scripts to detect and erase drives:

/etc/udev/rules.d/usbmount.rules - This file is a UDEV rule that should be run last by UDEV. It invokes a script when a new block device is enumerated and passes it on to the next script.

/usr/local/bin/usbmount.sh - This script is called by the UDEV rule and is used to launch the next script via batch to prevent UDEV from killing it.

/usr/local/bin/nuke.sh -This script will enable the STATUS LED(if connected) and run shred to erase the disk. This script takes the device path as an argument.

install.sh - First time install script. Sets up the dependencies.

update.sh - Deletes scripts from system folders and copies them from the git directory.

uninstall.sh - removes scripts to disable functionality.


### Installation
Start with a clean Raspbian lite install, clone into the repository and run the install script.

```
sudo apt update
sudo apt install git
git clone https://github.com/Real-Time-Kodi/Pi-Eraser
cd Pi-Eraser
chmod +x *.sh
./install.sh
```

### Use
Booot your pi with any USB storage plugged in. The STATUS LED will light to indicate that the process is running. When the light is out, a pass has been completed and the drive can be unplugged. If more than one pass is required, you may edit the file nuke.sh and mess with the parameters passed to the shred command. When done, run ````sudo ./update.sh````

#### Customization
The file nuke.sh is the file that actully does all of the work on the drive itself. It has several examples of how to handle various tasks including:
 * Changing the filesystem of the newly formatted device.
 * Automatically copying files to the newly formatted device.
 * Using a disk image instead of formatting the drive.
 * Disabling the secure wipe entirely and just using this software to automatically image drives.
 
Remember to run ```sudo ./update.sh```` after editing nuke.sh
 
### Uninstallation
Run the uninstallation script.

```
cd Pi-Eraser
./uninstall.sh
```

### Hardware
This has been tested on a Raspberry Pi A and a Raspberry Pi Zero. It should work on any raspberry pi however.

There is an optional STATUS LED that can be connected to GPIO pin 17 that will turn on while the PI is erasing a drive.

### Limitations
 * The scripts are currently limited to any block device that enumerates as /dev/sd[x]
 * Multiple drives can be plugged in and erased simultaneously, however, this will cause the STATUS LED to become inaccurate.
 * The PI cannot supply much current to the attached USB devices. Higher current draw devices may reset the pi or prevent it from starting.
 * The PI is slow. Expect this to take a while.
 
### Todo
 * Add support to a single-board computer with a SATA port like orange-pi.
 * Support ATA secure erase.
 * Lock SD card writes to prevent SD card corruption when the PI is unplugged.
