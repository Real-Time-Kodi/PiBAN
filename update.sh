rm /usr/local/bin/nuke.sh &>/dev/null
rm /usr/local/bin/secure_erase.sh &>/dev/null
rm /usr/local/bin/usbmount.sh &>/dev/null
rm /usr/local/bin/hack.sh &>/dev/null
rm /etc/udev/rules.d/usbmount.rules &>/dev/null
rm /boot/PiBAN.txt

cp nuke.sh /usr/local/bin/nuke.sh
cp hack.sh /usr/local/bin/hack.sh
cp secure_erase.sh /usr/local/bin/secure_erase.sh
cp usbmount.sh /usr/local/bin/usbmount.sh
cp usbmount.rules /etc/udev/rules.d/usbmount.rules
cp PiBAN.txt /boot

udevadm control --reload-rules

chmod +x /usr/local/bin/nuke.sh /usr/local/bin/usbmount.sh /usr/local/bin/secure_erase.sh /usr/local/bin/hack.sh
