sudo apt update
sudo apt -y install secure-delete wiringpi nwipe hdparm ntfs-3g pcregrep
sudo touch /var/log/PiBAN.log
sudo cp PiBAN.txt /boot
sudo ./update.sh
