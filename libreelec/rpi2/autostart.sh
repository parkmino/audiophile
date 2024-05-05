#!/bin/sh

[ -d /storage/.kodi/userdata/playlists/music/ ] && ! ls /storage/.kodi/userdata/playlists/music/*.pls>/dev/null 2>&1 && cp /etc/*.pls /storage/.kodi/userdata/playlists/music/ && cp /etc/playlist.m3u /storage/.kodi/userdata/playlists/mixed/

[ -r /storage/.config/audio.conf ] && . /storage/.config/audio.conf

rm /dev/snd/hw* /dev/snd/seq /dev/snd/timer || true

echo 55696 > /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate || true
#echo 1 > /sys/devices/system/cpu/cpufreq/ondemand/ignore_nice_load || true
#echo 100 > /sys/devices/system/cpu/cpufreq/ondemand/sampling_down_factor || true

for i in $(ls /sys/block/*/queue/scheduler); do
 if   echo $(cat $i) | grep -q none; then
  echo none > $i
 elif echo $(cat $i) | grep -q noop; then
  echo noop > $i
 fi
done

for i in $(ps -eo pid,class,ni,comm | grep -i TS | awk '$3 < -2 {print $1}'); do
 renice -2 $i || true
done

#for i in $(ps -eo pid,class,comm | grep -E '(FF|RR)' | awk '$3 !~ /migration|mpd/ {print $1}'); do
# chrt -op 0 $i || true
# renice  -3 $i || true
#done

#m_task=2; s_task=0; h_task=3; o_task=1,3 # grep -m1 siblings /proc/cpuinfo | grep -o [0-9*] # getconf _NPROCESSORS_ONLN # echo $(($(cat /sys/devices/system/cpu/present | sed 's/0-//')+1)) # grep -c ^processor /proc/cpuinfo
#
#if [ "$m_task" -ge 1 ]; then
# for pid in $(ps -eo pid,comm | awk '$2 !~ /mpd|systemd$|kodi|kodi.bin/ {print $1}'); do
#  taskset -acp $o_task $pid 2>/dev/null || true
# done
#fi
#
#avail_gov=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors)
#$(echo $avail_gov | grep -q ondemand)     && gov=ondemand
#$(echo $avail_gov | grep -q conservative) && gov=conservative
#$(echo $avail_gov | grep -q powersave)    && gov=powersave
#[ "$gov" != "" ] && echo $gov | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
#
### Turn off USBs
case $usb in
 PWR_OFF)		uhubctl -a 0 -l 1-1 -p 2     ;;
 USB45_SIG_OFF)		uhubctl -a 0 -l 1-1 -p 4,5   ;;
 USB45_SIG_PWR_OFF)	uhubctl -a 0 -l 1-1 -p 2,4,5 ;;
 3B+_PWR_OFF)		uhubctl -a 0 -l 1-1 -p 2     ;;
 3B+_USB45_SIG_OFF)	uhubctl -a 0 -l 1-1.1 -p 2,3 ;;
 3B+_USB45_SIG_PWR_OFF)	uhubctl -a 0 -l 1-1 -p 2,4   ; uhubctl -a 0 -l 1-1.1 -p 2,3 ;;
 4B_USB2_PWR_OFF)	uhubctl -a 0 -l 2   ;;
 4B_USB3_PWR_OFF)	uhubctl -a 0 -l 1-1 ;;
 4B_USB23_PWR_OFF)	uhubctl -a 0 -l 1-1 ; uhubctl -a 0 -l 2 ;;
esac

### Remove modules
 modprobe -r 8021q || true
#modprobe -r bcm2835_gpiomem || true
#modprobe -r fixed || true

swapoff -a

#echo 4 > /proc/irq/default_smp_affinity || true

[ "$alsa_conf" = min ] && rm -rf /dev/snd/*c /dev/snd/by* || true
[ "$lirc"  = off ] && systemctl stop eventlircd
[ "$nfs"   = off ] && systemctl stop rpcbind
[ "$pulse" = off ] && systemctl stop pulseaudio
[ "$vpn"   = off ] && systemctl stop connman-vpn
[ "$wpa"   = off ] && systemctl stop wpa_supplicant  || true

(
 until [ $(pgrep kodi.bin) -gt 0 ] 2>/dev/null && $(pstree -p | grep -q ActiveAE); do
  sleep 1
 done
 sleep 1

 #pgr_kodi=$(pgrep kodi.bin)
 #ppid=$pgr_kodi
 #
 #until [ $ppid -eq 1 ]; do
 # ppid=$(ps -o ppid= -p $ppid)
 # taskset -cp 0,1,3 $ppid
 #done

 #taskset -acp 0,1,3 $pgr_kodi
 #for i in $(pstree -p $pgr_kodi | grep ActiveAE | cut -d "}" -f2 | cut -d "(" -f2 | cut -d ")" -f1); do
 # taskset -cp $m_task $i
 #done

 if [ "$tweak" = on ]; then
  systemctl stop systemd-journald systemd-logind || true
  pkill hciattach || true
 #sysctl -w net.ipv4.conf.all.promote_secondaries=0
  for i in $(ls /proc/sys/net/ipv4/conf/*/promote_secondaries); do
   echo 0 > $i || true
  done
 fi

 llctl f0 l0 d0 || true
 echo none > /sys/class/leds/PWR/trigger    || true
 echo 0    > /sys/class/leds/PWR/brightness || true
 echo none > /sys/class/leds/ACT/trigger    || true
 echo 0    > /sys/class/leds/ACT/brightness || true
) &
