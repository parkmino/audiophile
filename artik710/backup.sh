#!/usr/bin/env bash
#
#    Copyright 2017 David G. Simmons
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0

#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.


# The name of the tar file
TARFILE=/mnt/SD3/rootfs.tar

# Expand partition 3 of the SD Card to make it as large as possible
# First calculate the right size for it
DEV="/dev/mmcblk1"

# Where does partition 3 start now?
start_sector=`fdisk -l $DEV | grep ${DEV}p3 | awk '{print $2}'`
# What's the max number of sectors?
end_sector=`fdisk -l DEV="/dev/mmcblk1" | awk 'NR==1 {print $7}'`
# one less ... 
end_sector=$((end_sector - 1))
# Make sure it's not mounted...
for disk in ${DEV}*
do
	umount $disk
done
# Now resize it accordingly
echo "Resizing partition map for $DEV"
fdisk $DEV <<EOF
p
d

n
p

$start_sector
$end_sector
w
EOF

sync; sync
e2fsck -f -y ${DEV}p3
# Now mount the filesystem
echo "Mounting new Filesystem..."
if [ ! -d /mnt/SD3 ]; then
    mkdir /mnt/SD3
fi
mount ${DEV}p3 /mnt/SD3
resize2fs ${DEV}p3
sync; sync
echo "Resize complete"


# Look for pv. If it's not installed, ask if they want to install it.
pv=`which pv 2>&1`
if [[ $pv == which* ]]; then
    echo "pv is not installed. This limits feedback."
    read -p 'Install pv now? [Y|n]: ' yn
    if [ ! -z $yn ]; then
        dnf install -y pv
        pv=`which pv`
    elif [ $yn == 'y' -o $yn == 'Y' ]; then
        dnf install -y pv
        pv=`which pv`
    else
        echo "User feedback will be minimal."
    fi
fi

# Move the old rootfs.tar.gz in case we need it again
# If it doesn't exist, this is some other media, so abort.
echo "moving old rootfs for safety"
if [ -f /mnt/SD3/rootfs.tar.gz ]; then
    mv /mnt/SD3/rootfs.tar.gz /mnt/SD3/oldroot.tgz
else
    echo "There is no rootfs.tar.gz in /mnt/SD3"
    echo "This may not be the right thing for you to do."
    exit 1
fi

# These are all added to the tarfile with --no-recursion
ADD_DIRS="bin dev/pts lib lost+found media mnt proc run/systemd run/systemd/shutdown run/systemd/netif run/systemd/netif/links run/systemd/netif/leases run/systemd/machines run/systemd/sessions run/systemd/ask-password run/systemd/users run/systemd/seats run/mariadb run/log run/wpa_supplicant run/lock run/lock/subsys run/lock/lockdev run/user run/faillock run/setrans run/lirc run/console run/netreport run/blkid run/sepermit sbin srv sys var/log var/lock var/run var/cache/yum var/cache/dnf var/yp var/games var/empty var/empty/sshd var/tmp var/spool var/spool/mail var/spool/mail/rpc var/spool/lpd var/spool/anacron var/spool/cron"

# See if the user wants to add more
user_add_dir=''
read -p 'Enter additonal (non-recursive) Directory: ' newdir
while [ ! -z $newdir ]; do
    user_add_dir+=" $newdir"
    read -p 'Enter additonal (non-recursive) Directory: ' newdir
    if [ -z $newdir ]; then
        break
    fi
done

if [ ! -z user_add_dir ]; then
    ADD_DIRS+=" $user_add_dir"
fi

# These are added recursively. 
ADD_FILES="etc dev/stdin dev/stderr dev/tty dev/random dev/fd dev/zero dev/full dev/ptmx dev/shm/ dev/urandom dev/null dev/stdout home opt root tmp/.font-unix/ tmp/.Test-unix/ tmp/.XIM-unix/ tmp/.X11-unix/ tmp/.ICE-unix/ usr var/local/ var/nis/ var/log/lastlog var/log/mariadb/ var/log/wtmp var/log/btmp var/log/tallylog var/log/README var/log/journal/ var/lib/ var/mail var/preserve/ var/opt/ var/gopher/ var/kerberos/ var/db/ var/adm/ var/cache/ var/cache/ldconfig/ var/cache/ldconfig/aux-cache var/cache/man/ var/cache/fontconfig/ var/spool/anacron/cron.weekly var/spool/anacron/cron.daily var/spool/anacron/cron.monthly"

# See if the user wants to add more
user_add_file=''
read -p 'Enter additonal (recursive) Directory or File: ' newfile
while [ ! -z newfile ]; do
    user_add_file+=" $newfile"
    read -p 'Enter additonal (recursive) Directory or File: ' newfile
    if [ -z $newfile ]; then
        break
    fi
done

if [ ! -z user_add_file ]; then
    ADD_FILES+=" $user_add_file"
fi


cd /
echo "Backing up root file system. This will take some time."
touch $TARFILE
# Add all the non-recursive stuff ... 
for f in $ADD_DIRS ; do
    if [ $pv ]; then 
        if [ -d $f -o -f $f ]; then
            echo -ne  "`tar rf $TARFILE --no-recursion $f | pv -N \"Adding $f \"   ` \r"
        fi
    else
        echo "Adding $f to tarfile ..."
        if [ -d $f -o -f $f ]; then
            tar rf $TARFILE --no-recursion $f  
        fi
    fi
done 
echo  "Done with directories                                     "

# Now for all the recursive stuff. This takes forever
for f in $ADD_FILES ; do
    if [ $pv ]; then
        if [ -d $f -o -f $f ]; then
            echo -ne "`tar cf - $f -P | pv -N \"Adding $f \" -s  $(du -sb $f | awk '{print $1}') >> $TARFILE`                    \r"  
        fi             
    else
        if [ -d $f -o -f $f ]; then
            printf "Adding %s \n" "$f"
            tar rf $TARFILE --checkpoint=.1000 $f 
            printf "\n"
        fi
    fi
done 
echo  "Done with files                                          "

# Now compress the whole mess. Also takes forever.
if [ -f $pv ]; then 
    gzip /mnt/SD3/rootfs.tar | pv -N "Compressing the rootfs"
else
    echo "Sorry, no progress indication, be patient ..."
    gzip /mnt/SD3/rootfs.tar
fi
echo "Done!"
echo ""
