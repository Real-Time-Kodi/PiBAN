# Pi-Eraser
Raspberry-pi based hard drive eraser.

# WARNING:
This will wipe any block device hooked to the Pi's USB without asking confirmation. Use with extreme caution.


### Scripts
This software consists of several scripts to detect and erase drives:

/etc/udev/rules.d/usbmount.rules - This file is a UDEV rule that should be run last by UDEV. It invokes a script when a new block device is enumerated and passes it on to the next script.

/usr/local/bin/usbmount.sh - This script is called by the UDEV rule and is used to launch the next script via batch to prevent UDEV from killing it.

/usr/local/bin/nuke.sh -This script will enable the STATUS LED(if connected) and run shred to erase the disk. This script takes the device path as an argument.

install.sh - First time install script. Sets up the dependencies.

update.sh - Deletes scripts from system folders and copies them from the git directory.

uninstall.sh - removes scripts to disable functionality.


### Installation
Start with a clean debian install, clone into the repository and run the install script.

```
sudo apt update
sudo apt install git
git clone https://github.com/Real-Time-Kodi/Pi-Eraser
cd Pi-Eraser
chmod +x *.sh
./install.sh
```

### Uninstallation
Run the uninstallation script.

```
cd Pi-Eraser
./uninstall.sh
```

### Hardware
This has been tested on a Raspberry Pi A and a Raspberry Pi Zero. It should work on any raspberry pi however.

There is an optional STATUS LED that can be connected to GPIO pin 18 that will turn on while the PI is erasing a drive.

### Limitations
 * The scripts are currently limited to any block device that enumerates as /dev/sd[x]
 * Multiple drives can be plugged in and erased simultaneously, however, this will cause the STATUS LED to become inaccurate.
 * The PI cannot supply much current to the attached USB devices. Higher current draw devices may reset the pi or prevent it from starting.
 * The PI is slow. Expect this to take a while.
 
### Todo
 * Supply a pre-made SD card image.
 * Lock SD card writes to prevent SD card corruption when the PI is unplugged.
