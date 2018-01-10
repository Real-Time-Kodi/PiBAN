rm -r /opt/PiBAN &>/dev/null
rm /opt/PiBAN/nuke.sh &>/dev/null
rm /opt/PiBAN/piban.sh &>/dev/null
rm /etc/udev/rules.d/usbmount.rules &>/dev/null
rm /etc/systemd/system/piban@.service &>/dev/null

mkdir /opt/PiBAN &>/dev/null

cp piban@.service /etc/systemd/system/
cp nuke.sh /opt/PiBAN/nuke.sh
cp piban.sh /opt/PiBAN/piban.sh
cp usbmount.rules /etc/udev/rules.d/usbmount.rules

chmod +x /opt/PiBAN/nuke.sh /opt/PiBAN/piban.sh

udevadm control --reload-rules
udevadm control --reload-rules
