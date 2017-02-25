echo "NUKING $1" >> /var/log/PiEraser.log
#TURN ON LED
gpio -g mode 18 out
gpio -g write 18 1
shred --iterations=1 "$1" >> /var/log/PiEraser.log
sync #SYNC because I don't trust the kernel to do it for me.
#TURN OFF LED
gpio -g write 18 0
echo "Done" >> /var/log/PiEraser.log

