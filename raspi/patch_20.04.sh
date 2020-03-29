#!/bin/sh

#bash <(curl -s https://raw.githubusercontent.com/parkmino/audiophile/master/raspi/patch_20.04.sh)

alsa_conf=/usr/share/alsa/alsa.conf
mpd_conf=/etc/mpd.conf.sav
rc_local=/etc/rc.local

sudo sed -i '/defaults.pcm { min/d; s/.*pcm.0.*/pcm.!0{type hw card 0 device 0 subdevice 0}/' $alsa_conf.{min,mix,plug}
[ $(grep mixer_type $mpd_conf | wc -l) -eq 1 ] && sudo sed -i '/buffer_before_play/amixer_type "none"' $mpd_conf
sudo sed -i 's/ctl.9/ctl.hw/' $mpd_conf $rc_local
sudo sed -i '/mpd)\|io)\|decoder)/s/._task/s_task/; /decoder)/s/._task/m_task/' $rc_local

printf "* Finished and reboot to take effect. \n* 완료되어 시스템을 다시 시작하면 적용됩니다. (^_^)\n"
