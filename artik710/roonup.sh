#!/bin/sh

# bash <(curl -s  https://raw.githubusercontent.com/parkmino/audiophile/master/artik710/roonup.sh)
# bash <(curl -sL https://bit.ly/34RPSl0)

mv /opt/RoonBridge/Bridge/RoonBridge /opt/RoonBridge/Bridge/RoonBridge.tweak
[ ! -d /root/copy ] && mkdir /root/copy
wget --no-check-certificate -O /root/copy/RoonBridge_linuxarmv8.tar.bz2 https://download.roonlabs.com/builds/RoonBridge_linuxarmv8.tar.bz2

sync

systemctl stop roonbridgetoram
tar -xvf /root/copy/RoonBridge_linuxarmv8.tar.bz2 -C /opt/

sync

strip --strip-debug /opt/RoonBridge/Bridge/processreaper
find /opt/RoonBridge/ -name *.so -exec chmod -x {} \; -exec strip --strip-debug {} 2>/dev/null \;

mv /opt/RoonBridge/Bridge/RoonBridge       /opt/RoonBridge/Bridge/RoonBridge.orig
mv /opt/RoonBridge/Bridge/RoonBridge.tweak /opt/RoonBridge/Bridge/RoonBridge

sync

cat /opt/RoonBridge/VERSION

printf "\n* Finished and reboot to take effect. \n* 완료되어 시스템을 다시 시작하면 적용됩니다. (^_^)\n"
