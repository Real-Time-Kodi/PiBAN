# PiBAN
Automatic Raspberry-pi based secure hard drive eraser. This will erase any 
block device plugged into the USB bus using the shred command. It will then 
create a partition table and a single FAT32 partition to make the drive 
immediately usable. This is somewhat similar to creating a boot disk that runs 
DBaN with the /autonuke option enabled.

The name is based on Derik's Boot and Nuke(DBaN). The software itself is a 
series of scripts that turn a standard Raspberry Pi into a standalone hard 
drive eraser. The erasing itself is handled by nwipe which is a fork of dwipe 
that is included in the debian repository.

# Secure Erase Warning
Since the raspberry pi is USB only, it is 
necessary to use a USB to SATA adapter to run an ATA secure erase. This configuration
is not supported by the kernel developers and has the possibility of **bricking
your hard drive permenantly** if your usb>sata adapter doesn't properly support
this. It should be noted that of all of the adapters and hard drives tested, not
a single one has been bricked.

# WARNING:
 * This will wipe any block device hooked to the Pi's USB without asking confirmation. Use with extreme caution.
 * This software could potentially leave data in reallocated blocks. This is especially a problem on flash media.


### Scripts
This software consists of several scripts to detect and erase drives:

**/etc/udev/rules.d/usbmount.rules** - This file is a UDEV rule that should be run last by UDEV. It invokes a script when a new
block device is enumerated and passes it on to the next script.

**/usr/local/bin/usbmount.sh** - This script is called by the UDEV rule and is used to launch the next script via batch
to prevent UDEV from killing it.

**/usr/local/bin/hack.sh** - This is an ugly hack to make logging work because of the way the at command works.

**/usr/local/bin/nuke.sh** -This script will enable the STATUS LED(if connected) and run shred to erase the disk.
This script takes the device path as an argument.

**install.sh** - First time install script. Sets up the dependencies.

**update.sh** - Deletes scripts from system folders and copies them from the git directory.

**uninstall.sh** - Removes scripts to disable functionality.

**harden.sh** - Puts the raspberry pi operating system into a read-only mode to prevent it from getting corrupted by improper shutdowns
or 


### Installation

#### The Easy Way
Grab an image from the [releases](https://github.com/Real-Time-Kodi/PiBAN/releases) page and use your favorite sd card writing software to burn it to an sd card.

This image will be hardened for read only use and has ssh enabled. *Do not hook this to the internet without changing the default ssh password.*

```
sudo mount -o remount,rw /
passwd
```

#### Through Github
Start with a clean Raspbian lite install, clone into the repository and run the install script.

```
sudo apt update
sudo apt install git
git clone https://github.com/Real-Time-Kodi/PiBAN
cd PiBAN
chmod +x *.sh
./install.sh
```

##### Hardening the Pi for Reliability.

In the ideal use-case, this software is installed on a Raspberry Pi with no power button/keyboard/monitor.
This makes it impossible to properly shut down the pi. Pulling the power, especially during filesystem-writes, can corrupt the Pi's filesystem.
Beyond that, Raspbian uses a swap file by default, which can wear out the card prematurely.

To midigate these problems, we can set up Raspbian to use a read only filesystem.
This project provides a script to do this. This script is likely to break with newer versions of Raspbian so use it with caution.
It was devoped for Raspbian Jessie lite.

To harden the Pi against SD card failure, you can run the following command from within the git directory. ```sudo ./harden.sh```
Keep in mind that this process is somewhat **irreversible** and that there is no script provided to undo it.

### Use
Booot your pi with any USB storage plugged in. The STATUS LED will light to indicate that the process is running. When the light is out,
a pass has been completed and the drive can be unplugged. If more than one pass is required, you may edit the file nuke.sh and mess with
the parameters passed to the shred command. When done, run ```sudo ./update.sh```

#### Customization
By default, PiBAN will install a configuration file onto the boot partition of your sd card. This file is located at PiBAN/PiBAN.conf
There are several options available in that file for changing the behaviour of piban. It also allows for running scripts, creating
filesystems, and copying files after the erasure is completed. It also allows the commands used for erasure to be tweaked.

#### ATA Secure Erase
ATA secure erase is disabled by default. It can be turned on by editing /boot/PiBAN/PiBAN.conf.
 
### Uninstallation
Run the uninstallation script.

```
cd PiBAN
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
 * By default, only one pass is made by the shred command for the sake of speed. This can be changed by editing nuke.sh
 
### Todo
 * Add support to a single-board computer with a SATA port like orange-pi.
