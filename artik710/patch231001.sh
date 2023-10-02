#!/bin/sh

#bash <(curl -sL https://github.com/parkmino/audiophile/raw/master/artik710/patch231001.sh)
#bash <(curl -sL https://bit.ly/3LKaUHN)

wget -P /etc/ https://github.com/parkmino/audiophile/raw/master/sh/kr2mpd
chmod 777 /etc/kr2mpd
mv /etc/kr2mpd /usr/bin/

printf "\n* Done. \n* 완료되었습니다. (^_^)\n"
