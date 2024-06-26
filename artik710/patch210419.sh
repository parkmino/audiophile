#!/bin/sh

#bash <(curl -s  https://raw.githubusercontent.com/parkmino/audiophile/master/artik710/patch210419.sh)
#bash <(curl -sL https://bit.ly/3ajDNbl)

### 1. Tune ALSA Library

#wget -P /etc/ https://github.com/parkmino/audiophile/raw/master/artik710/libasound.so.2.0.0.{min,mix,plug}_1.2.3.1.dev.shm
#mv /etc/libasound.so.2.0.0.min_1.2.3.1.dev.shm  /etc/libasound.so.2.0.0.min.dev.shm
#mv /etc/libasound.so.2.0.0.mix_1.2.3.1.dev.shm  /etc/libasound.so.2.0.0.mix.dev.shm
#mv /etc/libasound.so.2.0.0.plug_1.2.3.1.dev.shm /etc/libasound.so.2.0.0.plug.dev.shm
#sed -i 's/libasound.so.2.0.0.min /libasound.so.2.0.0.min.dev.shm /; s/libasound.so.2.0.0.mix /libasound.so.2.0.0.mix.dev.shm /; s/libasound.so.2.0.0.plug /libasound.so.2.0.0.plug.dev.shm /; /^ln.*alsa.conf/s/^/#/' /etc/rc.local

### 2. Tune ALSA Configuration

#rm /usr/share/alsa/alsa.conf
sed -i 's/pcm.hw.*sub/pcm.hw {  type hw  card 0  device 0 sub/' /usr/share/alsa/alsa.conf.min
sed -i 's/pcm.hw.*args/pcm.hw {  @args/; s/^type hw.*sub/type hw  card $CARD  device $DEV sub/' /usr/share/alsa/alsa.conf.{mix,plug}

### 3. Tune Shell Redirection

#sed -i 's/ 1<\/dev\/null 2<\/dev\/null 0<\/dev\/null/\&>\/dev\/null 0<\/dev\/null/g' /etc/rc.local
#sed -i 's/>\/dev\/null<\/dev\/null 2>\/dev\/null/\&>\/dev\/null 0<\/dev\/null/g' /opt/RoonBridge/Bridge/RoonBridge
#sed -i 's/\&>\/dev\/null 0<\/dev\/null/ \&>\/dev\/null<\/dev\/null/g' /etc/rc.local /opt/RoonBridge/Bridge/RoonBridge

### 4. Tune MPD buffer_before_play

#sed -i 's/0.*%/039749999%/' /etc/mpd.conf.sav

### 5. Tune Kernel Parameters

sed -i 's/229978/230002/g; s/388287/388321/g; s/1394065/1394090/g; s/4899005/4899032/g; s/4604 88254 3345671/4613 88283 3345702/g; s/4528 89899 3455599/4547 89932 3455682/g' /etc/sysctl.conf

### 6. Update Release

cp /etc/release /etc/release.sav
sed -i 's/[0-9]*$/210419/' /etc/release

### 7. Clear History & Sync

rm -f /root/.bash_history ~/.bash_history ; history -c
sync

printf "\n* Finished and reboot to take effect. \n* 완료되어 시스템을 다시 시작하면 적용됩니다. (^_^)\n"
