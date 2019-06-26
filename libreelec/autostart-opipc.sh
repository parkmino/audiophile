#!/bin/sh

[ -d /storage/.kodi/userdata/playlists/music/ ] && ! ls /storage/.kodi/userdata/playlists/music/*.pls>/dev/null 2>&1 && cp /etc/*.pls /storage/.kodi/userdata/playlists/music/

[ -r /storage/.config/audio.conf ] && . /storage/.config/audio.conf

cp /usr/lib/libasound.so.2.0.0.min /dev/shm/libasound.so.2.0.0
cp /usr/bin/nohup /dev/shm/

if [ "$alsa_conf" = min ]; then
 cp /usr/share/alsa/alsa.conf.min /dev/shm/alsa.conf
else
 cp /usr/share/alsa/alsa.conf.mix /dev/shm/alsa.conf
fi
rm /dev/snd/hw* /dev/snd/seq /dev/snd/timer || true

#echo 1000000 > /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate || true
#echo 1 > /sys/devices/system/cpu/cpufreq/ondemand/ignore_nice_load || true
#echo 100 > /sys/devices/system/cpu/cpufreq/ondemand/sampling_down_factor || true

for i in $(ps -eo pid,class,ni,comm | grep -i TS | awk '$3 < 0 {print $1}'); do
 renice -2 $i || true
done

for i in $(ps -eo pid,class,comm | grep -E '(FF|RR)' | awk '$3 !~ /migration|mpd/ {print $1}'); do
 chrt -op 0 $i || true
 renice  -3 $i || true
done

m_task=3 # grep -m1 siblings /proc/cpuinfo | grep -o [0-9*] # getconf _NPROCESSORS_ONLN # echo $(($(cat /sys/devices/system/cpu/present | sed 's/0-//')+1)) # grep -c ^processor /proc/cpuinfo
[ "$m_task" -ge 3 ] && s_task=$((m_task-2)) || s_task=0

if [ "$m_task" -ge 1 ]; then
 for pid in $(ps -eo pid,comm | awk '$2 !~ /mpd|systemd$|kodi|kodi.bin/ {print $1}'); do
  taskset -acp 0 $pid 2>/dev/null || true
 done
fi

#avail_gov=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors)
#$(echo $avail_gov | grep -q ondemand)     && gov=ondemand
#$(echo $avail_gov | grep -q conservative) && gov=conservative
#$(echo $avail_gov | grep -q powersave)    && gov=powersave
#[ "$gov" != "" ] && echo $gov | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
#
### Turn off USBs
#for i in $(seq 2 5); do
# [ usb$i = off ] && hub-ctrl -h 0 -P $i -p 0
#done
#[ -n "$usb" ] && uhubctl -a 0 -p "$usb"

### Remove modules
#modprobe -r 8021q || true
#modprobe -r bcm2835_gpiomem || true
#modprobe -r fixed || true

swapoff -a

echo 4 > /proc/irq/default_smp_affinity || true

(
#until [ $(pgrep kodi.bin) -gt 0 ] 2>/dev/null && $(pstree -p | grep -q complet); do
 until [ $(pgrep kodi.bin) -gt 0 ] 2>/dev/null; do
  sleep 1
 done
 sleep 3

 pgr_kodi=$(pgrep kodi.bin)
 ppid=$pgr_kodi

 until [ $ppid -eq 1 ]; do
  ppid=$(ps -o ppid= -p $ppid)
  taskset -cp $m_task $ppid
 done

 taskset -cp $m_task $pgr_kodi

 [ "$alsa_conf" = min ] && rm -rf /dev/snd/*c /dev/snd/by* /dev/snd/*C0* /dev/snd/*C1* || true
 [ "$lirc"  = off ] && systemctl stop eventlircd
 [ "$nfs"   = off ] && systemctl stop rpcbind
 [ "$pulse" = off ] && systemctl stop pulseaudio
 [ "$wpa"   = off ] && systemctl stop wpa_supplicant

#llctl f0 l0 d0
 echo none > /sys/class/leds/orangepi\:green\:pwr/trigger
 echo 0    > /sys/class/leds/orangepi\:green\:pwr/brightness
) &