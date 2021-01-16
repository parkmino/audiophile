#!/bin/sh

#bash <(curl -s  https://raw.githubusercontent.com/parkmino/audiophile/master/artik710/patch210116.sh)
#bash <(curl -sL https://bit.ly/35NVGwq)

[ ! -d /root/copy ] && mkdir /root/copy
wget https://launchpad.net/~jean-francois-dockes/+archive/ubuntu/upnpp1/+files/libnpupnp1_4.0.14-1~ppa1~xenial1_arm64.deb https://launchpad.net/~jean-francois-dockes/+archive/ubuntu/upnpp1/+files/libupnpp6_0.20.1-1~ppa1~xenial1_arm64.deb https://launchpad.net/~jean-francois-dockes/+archive/ubuntu/upnpp1/+files/upmpdcli-hra_1.5.6-1~ppa2~xenial1_all.deb https://launchpad.net/~jean-francois-dockes/+archive/ubuntu/upnpp1/+files/upmpdcli-qobuz_1.5.6-1~ppa2~xenial1_all.deb https://launchpad.net/~jean-francois-dockes/+archive/ubuntu/upnpp1/+files/upmpdcli-uprcl_1.5.6-1~ppa2~xenial1_all.deb https://launchpad.net/~jean-francois-dockes/+archive/ubuntu/upnpp1/+files/upmpdcli_1.5.6-1~ppa2~xenial1_arm64.deb -P /root/copy/
dpkg -i /root/copy/libnpupnp1_4.0.14-1~ppa1~xenial1_arm64.deb /root/copy/libupnpp6_0.20.1-1~ppa1~xenial1_arm64.deb
dpkg -i --force-confold /root/copy/upmpdcli_1.5.6-1~ppa2~xenial1_arm64.deb
systemctl disable upmpdcli

printf "* Finished and reboot to take effect. \n* 완료되어 시스템을 다시 시작하면 적용됩니다. (^_^)\n"
