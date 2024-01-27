#!/bin/sh

## bash <(curl -sL https://github.com/parkmino/audiophile/raw/master/raspi/patch241027.sh)
## bash <(curl -sL https://bit.ly/3HAP0Es)
#$ curl -sL https://bit.ly/3HAP0Es | sudo bash

wget https://github.com/parkmino/audiophile/raw/master/raspi/kr2mpd
chmod a+rx kr2mpd
sudo mv kr2mpd /usr/bin/

printf "\n* Done. \n* 완료되었습니다. (^_^)\n"
