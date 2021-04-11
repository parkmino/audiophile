#!/bin/sh

#bash <(curl -s  https://raw.githubusercontent.com/parkmino/audiophile/master/artik710/patch210411_revert.sh)
#bash <(curl -sL https://bit.ly/3uFhDIg)

### 1. Tune ALSA Library

#sed -i 's/libasound.so.2.0.0.min.dev.shm/libasound.so.2.0.0.min/; s/libasound.so.2.0.0.mix.dev.shm/libasound.so.2.0.0.mix/; s/libasound.so.2.0.0.plug.dev.shm/libasound.so.2.0.0.plug/; /ln.*alsa.conf/s/^#*//' /etc/rc.local

### 2. Tune ALSA Configuration

#ln -sf /dev/shm/alsa.conf /usr/share/alsa/alsa.conf
sed -i 's/pcm.hw.*sub/pcm.hw {type hw card 0 device 0 sub/' /usr/share/alsa/alsa.conf.min
sed -i 's/pcm.hw.*args/pcm.hw {@args/; s/^type hw.*sub/type hw card $CARD device $DEV sub/' /usr/share/alsa/alsa.conf.{mix,plug}

### 3. Tune Shell Redirection

#sed -i 's/\&>\/dev\/null 0<\/dev\/null/ 1<\/dev\/null 2<\/dev\/null 0<\/dev\/null/g' /etc/rc.local
#sed -i 's/\&>\/dev\/null 0<\/dev\/null/>\/dev\/null<\/dev\/null 2>\/dev\/null/g' /opt/RoonBridge/Bridge/RoonBridge

### 4. Tune MPD buffer_before_play

#sed -i 's/0.*%/039%/' /etc/mpd.conf.sav

### 5. Tune Kernel Parameters

sed -i 's/230002/229978/g; s/388321/388287/g; s/1394090/1394065/g; s/4899032/4899005/g; s/4614 88282 3345702/4604 88254 3345671/g; s/4548 89932 3455682/4528 89899 3455599/g' /etc/sysctl.conf

### 6. Update Release

[ -f /etc/release.sav ] && mv /etc/release.sav /etc/release || sed -i 's/[0-9]*$/201225/' /etc/release

### 7. Clear History & Sync

rm -f /root/.bash_history ~/.bash_history ; history -c
sync

printf "\n* Finished and reboot to take effect. \n* 완료되어 시스템을 다시 시작하면 적용됩니다. (^_^)\n"
