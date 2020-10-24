#!/bin/sh

#bash <(curl -s  https://raw.githubusercontent.com/parkmino/audiophile/master/artik710/spotifyon.sh)
#bash <(curl -sL https://bit.ly/2HmuJXX)

dot () {
 while true; do
 printf .
 sleep 0.476
 done
}

#dot &

sudo wget https://raw.githubusercontent.com/parkmino/audiophile/master/artik710/librespot -P /root/copy/
sudo chmod 755 /root/copy/librespot
consf spotify on

#kill $!
#echo

printf "* Finished and reboot to take effect. \n* 완료되어 시스템을 다시 시작하면 적용됩니다. (^_^)\n"
