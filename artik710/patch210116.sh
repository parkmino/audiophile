#!/bin/sh

#bash <(curl -s  https://raw.githubusercontent.com/parkmino/audiophile/master/artik710/patch210116.sh)
#bash <(curl -sL https://bit.ly/35NVGwq)

### Update Upmpdcli 1.5.10

[ ! -d /root/copy ] && mkdir /root/copy
wget -P /root/copy/ https://github.com/parkmino/audiophile/raw/master/artik710/libnpupnp1_4.0.14-1~ppa1~xenial1_arm64.deb https://github.com/parkmino/audiophile/raw/master/artik710/libupnpp6_0.20.2-1~ppa2~xenial1_arm64.deb https://github.com/parkmino/audiophile/raw/master/artik710/upmpdcli_1.5.10-1~ppa2~xenial1_arm64.deb
dpkg -i /root/copy/libnpupnp1_4.0.14-1~ppa1~xenial1_arm64.deb /root/copy/libupnpp6_0.20.2-1~ppa2~xenial1_arm64.deb
dpkg -i --force-confold /root/copy/upmpdcli_1.5.10-1~ppa2~xenial1_arm64.deb
systemctl disable upmpdcli

printf "\n* Finished and reboot to take effect. \n* 완료되어 시스템을 다시 시작하면 적용됩니다. (^_^)\n"
