#!/bin/sh

## bash <(curl -sL https://github.com/parkmino/audiophile/raw/master/artik710/patch231001.sh)
## bash <(curl -sL https://bit.ly/3LKaUHN)
#$ curl -sL https://bit.ly/3LKaUHN | sudo bash

wget -P /etc/ https://github.com/parkmino/audiophile/raw/master/sh/kr2mpd
chmod a+rx /etc/kr2mpd
mv /etc/kr2mpd /usr/bin/

printf "\n* Done. \n* 완료되었습니다. (^_^)\n"
