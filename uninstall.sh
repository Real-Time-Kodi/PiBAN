sudo apt -y remove secure-delete wiringpi
sudo rm /usr/local/bin/nuke.sh
sudo rm /usr/local/bin/usbmount.sh
sudo rm /etc/udev/rules.d/usbmount.rules
sudp rm /usr/local/bin/secure_erase.sh
sudo udevadm control --reload-rules
