#!/bin/sh

#bash <(curl -s  https://raw.githubusercontent.com/parkmino/audiophile/master/artik710/airplayon.sh)
#bash <(curl -sL https://bit.ly/2J39eMc)

dot () {
 while true; do
 printf .
 sleep 0.476
 done
}

#dot &

sudo wget http://download.roonlabs.com/builds/roonbridge-installer-linuxarmv8.sh -O /root/copy/roonbridge-installer-linuxarmv8.sh
sudo chmod 755 /root/copy/roonbridge-installer-linuxarmv8.sh
sudo /root/copy/roonbridge-installer-linuxarmv8.sh
sudo systemctl disable roonbridge

#kill $!
#echo

printf "* Finished and reboot to take effect. \n* 완료되어 시스템을 다시 시작하면 적용됩니다. (^_^)\n"
