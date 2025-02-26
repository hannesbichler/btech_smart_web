#!/bin/bash
####################################################################################################
# source vars+func
####################################################################################################
source "/hbin/def-vars.txt.sh"
source "/hbin/def-func.txt.sh"
####################################################################################################

mp1=$(mount | grep '^/dev/mmcblk0p1 on /media/mmcblk0p1')
test -n "${mp1}" && test -f /media/mmcblk0p1/hbs/conf/config.txt && cp /media/mmcblk0p1/hbs/conf/config.txt /hbin/config.txt_tmp
test -n "${mp1}" && umount /dev/mmcblk0p1; echo 'umount p1' || exit 1

mp2=$(mount | grep '^/dev/mmcblk0p2 on /media/mmcblk0p2')
test -n "${mp2}" && umount /dev/mmcblk0p2; echo 'umount p2' || exit 1

mp3=$(mount | grep '^/dev/mmcblk0p3 on /media/mmcblk0p3')
test -n "${mp3}" && umount /dev/mmcblk0p3; echo 'umount p3' || exit 1

echo "___sleep";sleep 1

dd if=/dev/zero of=/dev/mmcblk0 bs=2048 count=1 > /dev/null || exit 1

(echo 'c'; echo 'n'; echo 'p'; echo '1'; echo ''; echo ''; echo 't'; echo '0C'; echo 'w') | fdisk /dev/mmcblk0 > /dev/null || exit 1

echo "___sleep";sleep 1

mp1=$(mount | grep '^/dev/mmcblk0p1 on /media/mmcblk0p1')
test -n "${mp1}" && umount /dev/mmcblk0p1; echo 'umount p1' || exit 1

mkfs.vfat -F 32 /dev/mmcblk0p1 || exit 1

echo "___sleep";sleep 1

mp1=$(mount | grep '^/dev/mmcblk0p1 on /media/mmcblk0p1')
test -z "${mp1}" && test -d /media/mmcblk0p1 && mount -t vfat /dev/mmcblk0p1 /media/mmcblk0p1; echo 'mount p1' || exit 1

mkdir -p /media/mmcblk0p1/hbs/conf

test -f /hbin/config.txt_tmp && cp /hbin/config.txt_tmp /media/mmcblk0p1/hbs/conf/config.txt && rm /hbin/config.txt_tmp

#test ! -f /hbin/config.txt_tmp && S_config_txt_values && W_config_txt

echo '1' > /media/mmcblk0p1/$(date +%s).txt
ls -l /media/mmcblk0p1/
ls -l /media/mmcblk0p1/hbs/conf/
date +%s

exit 0