#!/bin/sh

#bash <(curl -s  https://raw.githubusercontent.com/parkmino/audiophile/master/artik710/patch210116.sh)
#bash <(curl -sL https://bit.ly/35NVGwq)

### Update Upmpdcli 1.4.14

[ ! -d /root/copy ] && mkdir /root/copy
wget -O -P /root/copy/ https://github.com/parkmino/audiophile/raw/master/artik710/libnpupnp1_4.0.14-1~ppa1~xenial1_arm64.deb https://github.com/parkmino/audiophile/raw/master/artik710/libupnpp6_0.20.1-1~ppa1~xenial1_arm64.deb https://github.com/parkmino/audiophile/raw/master/artik710/upmpdcli_1.4.14-1~ppa6~xenial1_arm64.deb
dpkg -i /root/copy/libnpupnp1_4.0.14-1~ppa1~xenial1_arm64.deb /root/copy/libupnpp6_0.20.1-1~ppa1~xenial1_arm64.deb
dpkg -i --force-confold /root/copy/upmpdcli_1.4.14-1~ppa6~xenial1_arm64.deb
systemctl disable upmpdcli

### Tune MPD buffer_before_play

#sed -i 's/0.*%/03975%/' /etc/mpd.conf.sav

### Tune RoonBridge Shell Redirection

#sed -i 's/>\/dev\/null<\/dev\/null 2>\/dev\/null/1<\/dev\/null 2<\/dev\/null 0<\/dev\/null/g' /opt/RoonBridge/Bridge/RoonBridge

### Update Release

#sed -i 's/[0-9]*$/210116/' /etc/release

printf "\n* Finished and reboot to take effect. \n* 완료되어 시스템을 다시 시작하면 적용됩니다. (^_^)\n"
