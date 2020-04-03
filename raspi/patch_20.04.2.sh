#!/bin/sh

#bash <(curl -s  https://raw.githubusercontent.com/parkmino/audiophile/master/raspi/patch_20.04.2.sh)
#bash <(curl -sL https://bit.ly/2UXFaUn)

dot () {
 while true; do
 printf .
 sleep 0.476
 done
}

#dot &

alsa_conf=/usr/share/alsa/alsa.conf
mpd_conf=/etc/mpd.conf.sav
rc_local=/etc/rc.local

sudo sed -i '/defaults.pcm { min/d; s/.*pcm.0.*/pcm.!0{type hw card 0 device 0 subdevice 0}defaults.pcm{minperiodtime 2774}/' $alsa_conf.{min,mix,plug}
sudo sed -i 's/.*pcm.!0.*/pcm.hw{type hw card 0 device 0 subdevice 0}/' $alsa_conf.{min,mix,plug}
sudo sed -i '/pcm.hw{type hw card 0/d' $alsa_conf.{mix,plug}
[ $(grep mixer_type $mpd_conf | wc -l) -eq 1 ] && sudo sed -i '/buffer_before_play/amixer_type "none"' $mpd_conf
sudo sed -i 's/pcm.0/pcm.hw/; s/ctl.9/ctl.hw/' $mpd_conf $rc_local
sudo sed -i '/mpd)/s/._task/h_task/; /io)\|decoder)\|player)/s/._task/s_task/' $rc_local

#kill $!
#echo

printf "* Finished and reboot to take effect. \n* 완료되어 시스템을 다시 시작하면 적용됩니다. (^_^)\n"
