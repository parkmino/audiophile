#!/bin/sh

# bash <(curl -s  https://raw.githubusercontent.com/parkmino/audiophile/master/artik710/roonup.sh)
# bash <(curl -sL https://bit.ly/34RPSl0)

#sed -i 's/>\/dev\/null<\/dev\/null 2>\/dev\/null/1<\/dev\/null 2<\/dev\/null 0<\/dev\/null/g' /opt/RoonBridge/Bridge/RoonBridge

mv /opt/RoonBridge/Bridge/RoonBridge /opt/RoonBridge/Bridge/RoonBridge.tweak

[ ! -d /root/copy ] && mkdir /root/copy
wget -O http://download.roonlabs.com/builds/RoonBridge_linuxarmv8.tar.bz2 -P /root/copy/
systemctl stop roonbridgetoram
tar -xjfv /root/copy/RoonBridge_linuxarmv8.tar.bz2 -C /opt/RoonBridge/
strip --strip-debug /opt/RoonBridge/Bridge/processreaper
find /opt/RoonBridge/ -name *.so -exec chmod -x {} \; -exec strip --strip-debug {} 2>/dev/null \;

mv /opt/RoonBridge/Bridge/RoonBridge       /opt/RoonBridge/Bridge/RoonBridge.orig
mv /opt/RoonBridge/Bridge/RoonBridge.tweak /opt/RoonBridge/Bridge/RoonBridge

printf "* Finished and reboot to take effect. \n* 완료되어 시스템을 다시 시작하면 적용됩니다. (^_^)\n"