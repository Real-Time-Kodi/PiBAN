sudo apt -y remove at secure-delete wiringpi
sudo rm /usr/local/bin/nuke.sh
sudo rm /usr/local/bin/usbmount.sh
sudo rm /etc/udev/rules.d/usbmount.rules
sudo udevadm control --reload-rules
