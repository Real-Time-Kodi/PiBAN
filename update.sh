rm -r /opt/PiBAN &>/dev/null
rm /etc/udev/rules.d/usbmount.rules &>/dev/null
rm /etc/systemd/system/piban@.service &>/dev/null
rm /boot/PiBAN/PiBAN.conf

mkdir /opt/PiBAN &>/dev/null
mkdir /boot/PiBAN &>/dev/null

cp piban@.service /etc/systemd/system/
cp nuke.sh /opt/PiBAN/nuke.sh
cp piban.sh /opt/PiBAN/piban.sh
cp secure_erase.sh /opt/PiBAN/secure_erase.sh

cp usbmount.rules /etc/udev/rules.d/usbmount.rules
cp PiBAN.conf /boot/PiBAN

chmod +x /opt/PiBAN/nuke.sh /opt/PiBAN/piban.sh /opt/PiBAN/secure_erase.sh

udevadm control --reload-rules
