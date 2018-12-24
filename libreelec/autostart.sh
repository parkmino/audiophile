#!/bin/sh

[ -r /storage/.config/audio.conf ] && . /storage/.config/audio.conf

cp /usr/lib/libasound.so.2.0.0.min /dev/shm/libasound.so.2.0.0

if [ "$alsa_conf" = min ]; then
 cp /usr/share/alsa/alsa.conf.min /dev/shm/alsa.conf
else
 cp /usr/share/alsa/alsa.conf.mix /dev/shm/alsa.conf
fi

cp /usr/bin/nohup /dev/shm/

mknod -m 000 /dev/mixer c 1 2 && chown root:kmem /dev/mixer
[ -e /dev/snd/timer ] && rm /dev/snd/timer

echo 1000000 > /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate || true
echo 1 > /sys/devices/system/cpu/cpufreq/ondemand/ignore_nice_load || true
echo 100 > /sys/devices/system/cpu/cpufreq/ondemand/sampling_down_factor || true

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
  taskset -acp 0 $pid || true
 done
fi

#avail_gov=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors)
#$(echo $avail_gov | grep -q ondemand)     && gov=ondemand
#$(echo $avail_gov | grep -q conservative) && gov=conservative
#$(echo $avail_gov | grep -q powersave)    && gov=powersave
#[ "$gov" != "" ] && echo $gov | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
#
### Turn off USBs
#if lsusb -d 0424:9514; then
#hub-ctrl -h 0 -P 5 -p 0
#hub-ctrl -h 0 -P 4 -p 0
#fi
#hub-ctrl -h 0 -P 3 -p 0
#hub-ctrl -h 0 -P 2 -p 0 # USB power  off
#hub-ctrl -h 0 -P 1 -p 0 # LAN signal off

### Remove modules
 modprobe -r 8021q || true
#modprobe -r bcm2835_gpiomem || true
#modprobe -r fixed || true

swapoff -a

echo 4 > /proc/irq/default_smp_affinity || true

(
 until [ $(pgrep kodi.bin) -gt 0 ] 2>/dev/null && $(pstree -p | grep -q complet); do
  sleep 1
 done
 sleep 1

 pgr_kodi=$(pgrep kodi.bin)
 ppid=$pgr_kodi

 until [ $ppid -eq 1 ]; do
  ppid=$(ps -o ppid= -p $ppid)
  taskset -cp $m_task $ppid
 done

 taskset -cp $m_task $pgr_kodi

 [ "$lirc"  = off ] && systemctl stop eventlircd
 [ "$nfs"   = off ] && systemctl stop rpcbind
 [ "$pulse" = off ] && systemctl stop pulseaudio
 [ "$wpa"   = off ] && systemctl stop wpa_supplicant

 llctl f0 l0 d0
 echo none > /sys/class/leds/led0/trigger
 echo 0    > /sys/class/leds/led0/brightness
 [ -f /sys/class/leds/led1/brightness ] && echo 0 > /sys/class/leds/led1/brightness
) &