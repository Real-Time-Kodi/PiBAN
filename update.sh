sudo -i
rm /usr/local/bin/nuke.sh
rm /usr/local/bin/usbmount.sh
rm /etc/udev/rules.d/usbmount.rules

cp nuke.sh /usr/local/bin/nuke.sh
cp usbmount.sh /usr/local/bin/usbmount.sh
cp usbmount.rules /etc/udev/rules.d/usbmount.rules

chmod +x /usr/local/bin/nuke.sh /usr/local/bin/usbmount.sh
exit
