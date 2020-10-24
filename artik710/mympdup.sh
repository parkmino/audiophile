#!/bin/sh

#bash <(curl -s  https://raw.githubusercontent.com/parkmino/audiophile/master/artik710/mympdup.sh)
#bash <(curl -sL https://bit.ly/2Tj4TGF)

dot () {
 while true; do
 printf .
 sleep 0.476
 done
}

#dot &

ver=6.8.0
sudo wget https://raw.githubusercontent.com/parkmino/audiophile/master/artik710/mympd_${ver}-1ppa1~sylphid_arm64.deb -P /root/copy/
sudo dpkg -i /root/copy/mympd_${ver}-1ppa1~sylphid_arm64.deb

#kill $!
#echo

printf "* Finished and reboot to take effect. \n* 완료되어 시스템을 다시 시작하면 적용됩니다. (^_^)\n"
