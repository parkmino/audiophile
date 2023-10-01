#!/bin/sh

#bash <(curl -sL https://github.com/parkmino/audiophile/raw/master/sh/kr2mpd)
#bash <(curl -sL https://bit.ly/3roM7lW)

wget -P /etc/ https://github.com/parkmino/audiophile/raw/master/sh/kr2mpd
chmod +x /etc/kr2mpd
mv /etc/kr2mpd /usr/bin/

printf "\n* Done. \n* 완료되었습니다. (^_^)\n"
