sudo apt -y remove secure-delete wiringpi

sudo rm -rf /opt/PiBAN
sudo rm /etc/systemd/system/piban@.service

sudo rm /etc/udev/rules.d/usbmount.rules
sudo rm /boot/PiBAN/PiBAN.conf
sudo udevadm control --reload-rules
