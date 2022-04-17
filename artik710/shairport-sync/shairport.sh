#!/bin/sh

# bash <(curl -s  https://github.com/parkmino/audiophile/raw/master/artik710/shairport-sync/shairport.sh)
# bash <(curl -sL https://bit.ly/3xD2lIC)

apt-get update
apt-get install libconfig9

wget -O /usr/local/bin/shairport-sync https://github.com/parkmino/audiophile/raw/master/artik710/shairport-sync/shairport-sync
chmod +x /usr/local/bin/shairport-sync
wget -O /etc/shairport-sync.conf https://github.com/parkmino/audiophile/raw/master/artik710/shairport-sync/shairport-sync.conf
getent group shairport-sync &>/dev/null || groupadd -r shairport-sync >/dev/null
getent passwd shairport-sync &> /dev/null || useradd -r -M -g shairport-sync -s /usr/bin/nologin -G audio shairport-sync >/dev/null
wget -O /lib/systemd/system/shairport-sync.service https://github.com/parkmino/audiophile/raw/master/artik710/shairport-sync/shairport-sync.service

sync

systemctl disable shairport-sync
systemctl daemon-reload

grep -q shairport /etc/default/audio.conf || sed -i 'ashairport=on' /etc/default/audio.conf
grep -q shairport /etc/rc.local || sed -i '/$naa/a\\n[ "$shairport" = on ] && cp /usr/local/bin/shairport-sync /dev/shm/ && systemctl start shairport-sync' /etc/rc.local

sync
