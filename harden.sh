#!/bin/bash
apt -y remove --purge cron logrotate dbus dphys-swapfile fake-hwclock
apt -y autoremove --purge
apt -y install busybox-syslogd; dpkg --purge rsyslog

#Disable swap and boot in readonly mode
mv /boot/cmdline.txt /boot/cmdline.txt.bak
echo $(cat /boot/cmdline.txt.bak)" fastboot noswap ro" > /boot/cmdline.txt

#Relocate spool to out tempfs.
rm -rf /var/spool
ln -s /tmp /var/spool

# Change the way the filesystems are mounted on boot.
# This is dangerous and needs improvement.
# If this fails, the backup can be restored.
mv /etc/fstab /etc/fstab.bak
# Match a pattern starting with /dev/[not whitespace][whitespace][/boot][whitespace][vfat][whitespace][not whitespace] then add ,ro after it.
# Then do it again with / and ext4. Then put it in fstab.
sed -e 's/\/dev\/\S*\s*\/boot\s*vfat\s*\S*/&,ro/' /etc/fstab.bak | sed -e 's/\/dev\/\S*\s*\/\s*ext4\s*\S*/&,ro/' > /etc/fstab
echo "tmpfs	/var/log	tmpfs   nodev,nosuid	0	0
tmpfs	/var/tmp	tmpfs	nodev,nosuid	0	0
tmpfs	/mnt	tmpfs	nodev,nosuid	0	0
tmpfs   /tmp        tmpfs   nodev,nosuid    0   0" >> /etc/fstab

# This makes SSH usable on a read only fs.
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
sed 's/UsePrivilegeSeparation yes/UsePrivilegeSeparation no/' /etc/ssh/sshd_config.bak > /etc/ssh/sshd_config


#mount rw when the user logs in to ssh for simplicity
#echo 'mount -o remount,rw /' >> ~/.ssh/rc
#echo 'mount -o remount,rw /boot' >> ~/.ssh/rc
#echo '/bin/bash' >> ~/.ssh/rc
#echo 'mount -o remount,ro /' >> ~/.ssh/rc
#echo 'mount -o remount,ro /boot' >> ~/.ssh/rc
#chmod +x ~/.ssh/rc

touch /tmp/dhcpcd.resolv.conf
rm /etc/resolv.conf
ln -s /tmp/dhcpcd.resolv.conf /etc/resolv.conf

