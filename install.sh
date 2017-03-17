sudo apt update
sudo apt -y install at secure-delete wiringpi nwipe hdparm ntfs-3g pcregrep
sudo touch /var/log/PiBAN.log
sudo mkdir /boot/PiBAN
sudo mkdir /boot/PiBAN/files
sudo ./update.sh
