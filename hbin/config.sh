#!/bin/bash
### BEGIN INIT INFO
# Provides:          config.sh
# Required-Start:    $local_fs
# Required-Stop:     
# Default-Start:     S
# Default-Stop:      
# Short-Description: HBS Configuration
### END INIT INFO
####################################################################################################
# source vars+func
####################################################################################################
source "/hbin/def-vars.txt.sh"
source "/hbin/def-func.txt.sh"
####################################################################################################
# configure leds
S_leds_onboot
sleep 1
S_leds_on
sleep 1
S_leds_off

####################################################################################################
#first we always set server.state to 0
echo 0 >/cometintern/watchdog/server.state

####################################################################################################
W_dmesg "___Starting HBS Configuration"

####################################################################################################
# check_rwo () {}
check_rwo () {
rwo=$(mount | grep "${1}" | awk '{ print $6 }' | tr -d '()\n' | cut -d ',' -f 1)
if [ "${rwo}" = 'ro' ]; then
	W_dmesg "___${1} is read-only."
elif [ "${rwo}" = 'rw' ]; then
	W_dmesg "___${1} is read-write."
else
	W_dmesg "___${1} is not available."
fi
}

####################################################################################################
# mmc status
W_dmesg "___check_rwo 1+3"
check_rwo "/media/mmcblk0p1"
check_rwo "/media/mmcblk0p3"

####################################################################################################
# mmc fsck
d1="/dev/mmcblk0p1"; m1="/media/mmcblk0p1"
d3="/dev/mmcblk0p3"; m3="/media/mmcblk0p3"
mnt=

# m3 gibts wenn MMC-BOOT
if test -b "${d3}"; then
	mnt="${m3}"
	W_dmesg "___P-3 ext4 ${mnt}."
	if test -d "${m3}"; then
		umount "${m3}"
		fsck.ext4 -p -v "${d3}"
		mount -t ext4 "${d3}" "${m3}"
	fi
# m1 gibts wenn NAND-BOOT
elif test -b "${d1}"; then
	mnt="${m1}"
	W_dmesg "___P-1 vfat ${mnt}."
	if test -d "${m1}"; then
		umount "${m1}"
		fsck.vfat -a -v "${d1}"
		mount -t vfat "${d1}" "${m1}"
	fi
# keine sd karte
else
	mnt=''
	W_dmesg "___No sd card."
fi

####################################################################################################
# mmc status
W_dmesg "___check_rwo mnt"
check_rwo "${mnt}"

####################################################################################################
# /hbin/java{OPC,HMI}
jav="/ejre1.7.0_45/bin/java"
if test -f "${jav}"; then
	test ! -L "/hbin/java" && ln -s ${jav} /hbin/java
	test ! -L "/hbin/javaOPC" && ln -s ${jav} /hbin/javaOPC
	test ! -L "/hbin/javaHMI" && ln -s ${jav} /hbin/javaHMI
	W_dmesg "___Java OK."
else
	W_dmesg "___No Java."
fi

####################################################################################################
# /hbs
if [ -d "${mnt}" ]; then
	test ! -d "${mnt}/hbs" && mkdir "${mnt}/hbs"
	test -L "/hbs" && rm /hbs
	ln -s "${mnt}/hbs" /hbs
	W_dmesg "___/hbs OK."
else
    W_dmesg "___No /hbs."
fi

####################################################################################################
R_config_txt

####################################################################################################
C_known_files

####################################################################################################
W_hostname
W_interfaces
W_server_config_xml
W_ntpdate
W_ntp_conf

####################################################################################################
/hbin/led_statecheck.sh &

####################################################################################################
W_dmesg "___HBS Configuration ready."

####################################################################################################
exit 0
