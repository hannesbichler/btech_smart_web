####################################################################################################
####################################################################################################
####################################################################################################
####################################################################################################
# D_ (delete) , C_ (check) , G_ (get) , L_ (list) , R_ (read) , S_ (set) , W_ (write)
####################################################################################################
R_config_txt () {
if [ -f "${config_txt}" ]; then
	while read line; do
	# eth0 IP Address
        test "${ipflag}" = "0" && pat="${patip}" || pat="${patna}"
        [[ "${line}" =~ '#ethIP0 '    ]] && read line && [[ "${line}" =~ ${pat} ]] && i0="${line//[^0-9.]/}"
	# eth0 Netmask
        test "${nmflag}" = "0" && pat="${patnm}" || pat="${patna}"
        [[ "${line}" =~ '#ethIP0sub ' ]] && read line && [[ "${line}" =~ ${pat} ]] && n0="${line//[^0-9.]/}"
	# eth0 Gateway
        test "${ipflag}" = "0" && pat="${patip}" || pat="${patna}"
        [[ "${line}" =~ '#ethIP0gw '  ]] && read line && [[ "${line}" =~ ${pat} ]] && g0="${line//[^0-9.]/}"
	# eth1 IP Address
        test "${ipflag}" = "0" && pat="${patip}" || pat="${patna}"
        [[ "${line}" =~ '#ethIP1 '    ]] && read line && [[ "${line}" =~ ${pat} ]] && i1="${line//[^0-9.]/}"
	# eth1 Netmask
        test "${nmflag}" = "0" && pat="${patnm}" || pat="${patna}"
        [[ "${line}" =~ '#ethIP1sub ' ]] && read line && [[ "${line}" =~ ${pat} ]] && n1="${line//[^0-9.]/}"
	# eth1 Gateway
        test "${ipflag}" = "0" && pat="${patip}" || pat="${patna}"
        [[ "${line}" =~ '#ethIP1gw '  ]] && read line && [[ "${line}" =~ ${pat} ]] && g1="${line//[^0-9.]/}"
	# Timeserver IP Address
        test "${ipflag}" = "0" && pat="${patip}" || pat="${patna}"
        [[ "${line}" =~ '#timeserver' ]] && read line && [[ "${line}" =~ ${pat} ]] && ts="${line//[^0-9.]/}"
        #[[ "${line}" =~ '#timeserver' ]] && read line && ts="${line}"
	# Share Time
        test "${blflag}" = "0" && pat="${patbl}" || pat='.*'
        [[ "${line}" =~ '#sharetime'  ]] && read line && [[ "${line}" =~ ${pat} ]] && st="${line}"
	# Hostname
        test "${wdflag}" = "0" && pat="${patwd}" || pat='.*'
        [[ "${line}" =~ '#hostname'   ]] && read line && [[ "${line}" =~ ${pat} ]] && hn="${line//[^a-zA-Z0-9_-]/}"
	# DNS
        test "${blflag}" = "0" && pat="${patbl}" || pat='.*'
        [[ "${line}" =~ '#dns'        ]] && read line && [[ "${line}" =~ ${pat} ]] && dy="${line}"
	# Driver Name
        test "${wsflag}" = "0" && pat="${patws}" || pat='.*'
        [[ "${line}" =~ '#drvname'    ]] && read line && [[ "${line}" =~ ${pat} ]] && dn="${line}"
    # OPC Server Port
        test "${nbflag}" = "0" && pat="${patnb}" || pat='.*'
        [[ "${line}" =~ '#ethPortOPC' ]] && read line && [[ "${line}" =~ ${pat} ]] && op="${line//[^0-9]/}"
	done <<< "$(cat ${config_txt})"
else
	return 1
fi
return 0
}
####################################################################################################
W_server_config_xml () {
if [ -f "${servcfgtmp}" ]; then
    #servcfgtmp='/hbs/comet/opc_ua_server/servers/HBSServer/serverconfig/server.config.tmp'
####
#
#### VERSION 1 ####
	#addr0="opc.tcp:\/\/${i0}:${op}"
	#addr1="opc.tcp:\/\/${i1}:${op}"
	#cat "${servcfgtmp}" | sed -ne "s/%serveraddr_eth0%/${addr0}/;s/%serveraddr_eth1%/${addr1}/;p;" > "${servcfgxml}"
####
#	NEU: die ersten drei zeilen deaktivieren
#		 test ... + cat ... auskommentieren
####
#	eth0:  100Mbit: PLC (Steuerung)
#	eth1: 1000Mbit: OPC (Server)
#	${dy} : bleibt in /hbs/conf/config.txt als tag #dns stehen
#   Zeile mit %serveraddr_eth0% entfernt aus server.config.xml.tmp
####
#
#### VERSION 2 ####
	#test "${dy}" = "true" && addr1="opc.tcp:\/\/${hn}:${op}" || addr1="opc.tcp:\/\/${i1}:${op}"
	#cat "${servcfgtmp}" | sed -ne "s/%serveraddr_eth1%/${addr1}/;p;" > "${servcfgxml}"
####
#
#### VERSION 3 ####
# <BaseAddresses>
# <ua:String>%serveraddr_host%</ua:String>
# <ua:String>%serveraddr_eth0%</ua:String>
# <ua:String>%serveraddr_eth1%</ua:String>
# </BaseAddresses>
# DNS true  : (%serveraddr_host% -> $hostn   ,) %serveraddr_eth0% -> $addr0 , %serveraddr_eth1% -> $addr1
# DNS false : (%serveraddr_host% -> loeschen ,) %serveraddr_eth0% -> $addr0 , %serveraddr_eth1% -> $addr1
# wird "%serveraddr_....%" nicht gefunden, wird auch nichts ersetzt
    addr0="opc.tcp:\/\/${i0}:${op}"
    addr1="opc.tcp:\/\/${i1}:${op}"
    hostn="opc.tcp:\/\/${hn}:${op}"
	SED=
    if test "${dy}" = "true"; then
		SED="s/%serveraddr_host%/${hostn}/;s/%serveraddr_eth0%/${addr0}/;s/%serveraddr_eth1%/${addr1}/;p;"
    else
		SED="/%serveraddr_host%/d;s/%serveraddr_eth0%/${addr0}/;s/%serveraddr_eth1%/${addr1}/;p;"
    fi
	cat "${servcfgtmp}" | sed -ne "${SED}" > "${servcfgxml}"
####
	openssl sha1 "${servcfgxml}" | awk '{print $2}' | tr -d '\n' > "${servcfgsha}"
else
	return 1
fi
return 0
}
####################################################################################################
W_interfaces () {
echo "auto lo"                    >  "${interfaces_file}"
echo "  iface lo inet loopback"   >> "${interfaces_file}"
echo "auto eth0"                  >> "${interfaces_file}"
echo "  iface eth0 inet static"   >> "${interfaces_file}"
echo "    address ${i0}"        >> "${interfaces_file}"
echo "    netmask ${n0}"        >> "${interfaces_file}"
### gateway eth0
#echo "    gateway ${g0}"        >> "${interfaces_file}"
#test "${g0}" <> "" && echo "    gateway ${g0}"        >> "${interfaces_file}"
### gateway eth0
echo "auto eth1"                  >> "${interfaces_file}"
echo "  iface eth1 inet static"   >> "${interfaces_file}"
echo "    address ${i1}"        >> "${interfaces_file}"
echo "    netmask ${n1}"        >> "${interfaces_file}"
### gateway eth1
#echo "    gateway ${g1}"        >> "${interfaces_file}"
#test "${g1}" <> "" && echo "    gateway ${g1}"        >> "${interfaces_file}"
### gateway eth1
}
####################################################################################################
W_ntpdate () {
echo "NTPSERVERS=\"${ts}\""	  >  "${timeserver_ntpdate}"
echo "UPDATE_HWCLOCK=\"yes\"" >> "${timeserver_ntpdate}"
}
####################################################################################################
# (no descriptions on google drive)
W_ntp_conf () {
    echo -n >"${timeserver_ntp_conf}"
    echo "server ${ts}" >>"${timeserver_ntp_conf}"
    if test "${st}" = "true"; then
        echo "restrict default nomodify notrap nopeer" >>"${timeserver_ntp_conf}"
        echo "server 127.127.1.0" >>"${timeserver_ntp_conf}"
        echo "fudge 127.127.1.0 stratum 7" >>"${timeserver_ntp_conf}"
    fi
    echo -n >>"${timeserver_ntp_conf}"
}
# (no descriptions on google drive)
####################################################################################################
W_hostname () {
echo "${hn}" > "${hostname_file}"
}
####################################################################################################
L_drivers () {
if [ -d "${driversdir}" ]; then
	drvr_names=$(ls -1 "${driversdir}")
	[ -z "${drvr_names}" ] && return 1
else
	return 1
fi
return 0
}
####################################################################################################
R_driver_com () {
# ${1} : ${drivername}
driver_com="${driversdir}/${1}/driver.com"
if [ -f "${driver_com}" ]; then
	while read line; do
		# Driver Type
	    if [[ "${line}" =~ 'drivertype' ]]; then
            read line && drvt="${line}"
        fi
	done <<< "$(cat ${driver_com})"
	drivertype=$(echo "${drvt}" | tr -d '\015')
else
	return 1
fi
return 0
}
####################################################################################################
R_drv_info () {
# ${1} : ${drivertype}
driverinfo="${drvinfodir}/${1}/drv.info"
if [ -f "${driverinfo}" ]; then
	while read line; do
		# Driver Description
		[[ "${line}" =~ '#drvdescription' ]] && read line && drvd="${line}"
		# Driver Web
		[[ "${line}" =~ '#drvweb'         ]] && read line && drvw="${line}"
		# Driver Version
		[[ "${line}" =~ '#drvversion'     ]] && read line && drvv="${line}"
		# Driver Builddate
		[[ "${line}" =~ '#drvbuilddate'   ]] && read line && drvb="${line}"
		# Driver Revision
		[[ "${line}" =~ '#drvrevision'    ]] && read line && drvr="${line}"
	done <<< "$(cat ${driverinfo})"
else
	return 1
fi
return 0
}
####################################################################################################
R_server_info () {
if [ -f "${serverinfo}" ]; then
	while read line; do
		# Server Description
		[[ "${line}" =~ '#srvdescription' ]] && read line && srvd="${line}"
		# Server Web
		[[ "${line}" =~ '#srvweb'         ]] && read line && srvw="${line}"
		# Server Version
		[[ "${line}" =~ '#srvversion'     ]] && read line && srvv="${line}"
		# Server Builddate
		[[ "${line}" =~ '#srvbuilddate'   ]] && read line && srvb="${line}"
		# Server Revision
		[[ "${line}" =~ '#srvrevision'    ]] && read line && srvr="${line}"
	done <<< "$(cat ${serverinfo})"
else
	return 1
fi
return 0
}
####################################################################################################
R_debug_conf () {
if [ -f "${debug_conf}" ]; then
	debug_nodes=''
	while read line; do
		#test "${blflag}" = "0" && pat="${patbl}" || pat=".*"
		[[ "${line}" =~ ${patbl} ]] && debug_state="${line}"
		#test "${nbflag}" = "0" && pat="${patnb}" || pat=".*"
		[[ "${line}" =~ ${patnb} ]] && debug_level="${line}"
		#test "${ndflag}" = "0" && pat="${patnd}" || pat=".*"
		[[ "${line}" =~ ${patnd} ]] && debug_nodes="${line}"
	done <<< "$(cat ${debug_conf})"
	# Levels 1 (1), 2 (2), 3 (4), 4 (8), 5 (16)
	if [[ "${debug_level}" -lt 32 ]]; then
		DEC="${debug_level}"; BIN=; NUM="${DEC}"
		while [[ "${NUM}" -ne 0 ]];do BIT=$((${NUM} % 2));BIN="${BIT}${BIN}";NUM=$((${NUM} / 2));done
		BIT=$(echo "${BIN}" | rev | cut -c1)
		if [[ "${BIT}" != '' && "${BIT}" -eq 1 ]];then dl1check="checked"; fi
		BIT=$(echo "${BIN}" | rev | cut -c2)
		if [[ "${BIT}" != '' && "${BIT}" -eq 1 ]];then dl2check="checked"; fi
		BIT=$(echo "${BIN}" | rev | cut -c3)
		if [[ "${BIT}" != '' && "${BIT}" -eq 1 ]];then dl3check="checked"; fi
		BIT=$(echo "${BIN}" | rev | cut -c4)
		if [[ "${BIT}" != '' && "${BIT}" -eq 1 ]];then dl4check="checked"; fi
		BIT=$(echo "${BIN}" | rev | cut -c5)
		if [[ "${BIT}" != '' && "${BIT}" -eq 1 ]];then dl5check="checked"; fi
	else
		dl1check="checked"; dl2check="checked"; dl3check="checked"; dl4check="checked"; dl5check="checked"
	fi
else
	return 1
fi
return 0
}
####################################################################################################
# LEDs (von oben nach unten)
# ( 62 - Error      - red )     (ERROR  - 62 - RED)
# (  3 - Running    - green )   (OK     -  3 - GREEN)
# ( 63 - SD Warning - yellow )  (MAINT  - 63 - YELLOW)
# (      Power      - green )   (POWER  -    - GREEN)
S_led_62 () { if [ "${#}" -eq 1 ]; then [ "${1}" = "0" ] && led62=0 || led62=1; echo "${led62}" >/sys/class/gpio/gpio62/value; fi }
S_led_03 () { if [ "${#}" -eq 1 ]; then [ "${1}" = "0" ] && led03=0 || led03=1; echo "${led03}" >/sys/class/gpio/gpio3/value; fi }
S_led_63 () { if [ "${#}" -eq 1 ]; then [ "${1}" = "0" ] && led63=0 || led63=1; echo "${led63}" >/sys/class/gpio/gpio63/value; fi }
S_leds () {
	if [ "${#}" -eq 3 ]; then
		[ "${1}" = "0" ] && led62=0 || led62=1
		[ "${2}" = "0" ] && led03=0 || led03=1
		[ "${3}" = "0" ] && led63=0 || led63=1
		echo "${led62}" >/sys/class/gpio/gpio62/value
		echo "${led03}" >/sys/class/gpio/gpio3/value
		echo "${led63}" >/sys/class/gpio/gpio63/value
	fi
}
S_leds_on () {
	echo 1 >/sys/class/gpio/gpio3/value
	echo 1 >/sys/class/gpio/gpio62/value
	echo 1 >/sys/class/gpio/gpio63/value
}
S_leds_off () {
	echo 0 >/sys/class/gpio/gpio3/value
	echo 0 >/sys/class/gpio/gpio62/value
	echo 0 >/sys/class/gpio/gpio63/value
}
S_leds_onboot () {
# [3] running
echo 3 >   /sys/class/gpio/export
echo out > /sys/class/gpio/gpio3/direction
echo 0 >   /sys/class/gpio/gpio3/value
# [62] error
echo 7 >   /sys/kernel/debug/omap_mux/gpmc_csn1
echo 62 >  /sys/class/gpio/export
echo out > /sys/class/gpio/gpio62/direction
echo 0 >   /sys/class/gpio/gpio62/value
# [63] sd warning
echo 7 >   /sys/kernel/debug/omap_mux/gpmc_csn2
echo 63 >  /sys/class/gpio/export
echo out > /sys/class/gpio/gpio63/direction
echo 0 >   /sys/class/gpio/gpio63/value
}
####################################################################################################
L_logfiles () {
if [ -d "${comet_log_dir}" ]; then
	comet_log_files=$(ls -1 "${comet_log_dir}")
	[ -z "${comet_log_files}" ] && return 1
else
	return 1
fi
return 0
}
####################################################################################################
R_logfile () {
# ${1} : ${comet_log}
if [ -f "${comet_log_dir}/${1}" ]; then
	cat "${comet_log_dir}/${1}"
else
	return 1
fi
return 0
}
####################################################################################################
R_comet_log () {
# ${1} : ${comet_log}
if [ -f "${comet_log_dir}/${1}" ]; then
	cat "${comet_log_dir}/${1}"
else
	return 1
fi
return 0
}
####################################################################################################
R_comet_log_archiv () {
if [ -d "${comet_log_dir}" ]; then
	comet_log_files=$(ls -1 "${comet_log_dir}")
	[ -z "${comet_log_files}" ] && return 1
	for log_file in ${comet_log_files}; do
		#echo "${log_file}"
		echo "<a href='fr_comet__log.cgi?$(basename ${log_file})'>$(basename ${log_file})</a><br/>"
	done
else
	return 1
fi
return 0
}
####################################################################################################
W_config_txt () {
echo '' > "${config_txt}"
echo '#ethIP0 IP Address' >> "${config_txt}"
echo "${i0}" >> "${config_txt}"
echo '' >> "${config_txt}"
echo '#ethIP0sub Subnetmask' >> "${config_txt}"
echo "${n0}" >> "${config_txt}"
echo '' >> "${config_txt}"
#echo '#ethIP0gw' >> "${config_txt}"
#echo "${g0}" >> "${config_txt}"
#echo '' >> "${config_txt}"
echo '#ethIP1 IP Address' >> "${config_txt}"
echo "${i1}" >> "${config_txt}"
echo '' >> "${config_txt}"
echo '#ethIP1sub Subnetmask' >> "${config_txt}"
echo "${n1}" >> "${config_txt}"
echo '' >> "${config_txt}"
#echo '#ethIP1gw' >> "${config_txt}"
#echo "${g1}" >> "${config_txt}"
#echo '' >> "${config_txt}"
echo '#timeserver' >> "${config_txt}"
echo "${ts}" >> "${config_txt}"
echo '' >> "${config_txt}"
echo '#sharetime' >> "${config_txt}"
echo "${st}" >> "${config_txt}"
echo '' >> "${config_txt}"
echo '#hostname' >> "${config_txt}"
echo "${hn}" >> "${config_txt}"
echo '' >> "${config_txt}"
echo '#dns' >> "${config_txt}"
echo "${dy}" >> "${config_txt}"
echo '' >> "${config_txt}"
echo '#drvname' >> "${config_txt}"
echo "${dn}" >> "${config_txt}"
echo '' >> "${config_txt}"
echo '#ethPortOPC' >> "${config_txt}"
echo "${op}" >> "${config_txt}"
echo '' >> "${config_txt}"
echo '' >> "${config_txt}"
}
####################################################################################################
W_debug_conf () {
#cp "${debug_conf}" "${debug_conf}.$(date +%s)"
debug_level=$((${l1} + ${l2} + ${l3} + ${l4} + ${l5}))
echo "${debug_state}" >  "${debug_conf}"
echo "${debug_level}" >> "${debug_conf}"
echo "${debug_nodes}" >> "${debug_conf}"
}
####################################################################################################
S_config_txt_values () {
#test ! -d /hbs/conf && mkdir /hbs/conf
i0=$(ifconfig eth0 | grep inet | awk '{print $2":"$4}' | cut -d ':' -f 2)
n0=$(ifconfig eth0 | grep inet | awk '{print $2":"$4}' | cut -d ':' -f 4)
#g0=
i1=$(ifconfig eth1 | grep inet | awk '{print $2":"$4}' | cut -d ':' -f 2)
n1=$(ifconfig eth1 | grep inet | awk '{print $2":"$4}' | cut -d ':' -f 4)
#g1=
ts=$(cat /etc/default/ntpdate | grep NTPSERVERS | cut -d '"' -f 2)
#st=
hn=$(hostname)
#dy=
#dn=
op=$(cat "${servcfgxml}" | grep '<ua:String>opc.tcp:' | cut -d ':' -f 4 | cut -d '<' -f 1)
op1=$(echo "${op}" | cut -d ' ' -f 1)
op2=$(echo "${op}" | cut -d ' ' -f 2)
test "${op1}" -eq "${op2}" && op="${op1}" || op=$((${op1} / 2 + ${op2} / 2))
}
####################################################################################################
W_dmesg () {
echo "${1}" >/dev/kmsg
}
####################################################################################################
C_file () {
#echo -n "${1}: " && test -f "${1}" && echo 'OK.' || echo 'NiX.'
test -f "${1}" || test -d "${1}" || test -L "${1}" && echo "O.K: ${1}" || echo "NiX: ${1}"
}
####################################################################################################
# (no descriptions on google drive)
C_files () {
test -n "${1}" && echo "${1}" || echo "NiX."
LS=$(ls -1 ${1} 2>/dev/null)
test "${#LS}" = 0 && echo "NiX."
for F in ${LS}; do
	C_file "${F}"
done
}
# (no descriptions on google drive)
####################################################################################################
C_known_files () {
echo '============================================================================================='
C_file "/cometintern"
C_file "/ejre1.7.0_45"
C_file "/hbin"
echo '============================================================================================='
C_file "/ejre1.7.0_45/bin/java"
C_file "/ejre1.7.0_45/lib/ext/sqlite-jdbc-3.7.2.jar"
C_file "/hbs/comet/opc_ua_server/servers/startup.sh"
C_file "/hbs/comet/opc_ua_server/runtime/OPC_Server.jar"
echo '============================================================================================='
C_file "/hbin/java"
C_file "/hbin/javaHMI"
C_file "/hbin/javaOPC"
echo '============================================================================================='
C_file "${config_txt}"
echo '---------------------------------------------------------------------------------------------'
C_file "${servcfgtmp}"
C_file "${servcfgxml}"
echo '---------------------------------------------------------------------------------------------'
L_drivers
test "${?}" -eq 1 && echo "no drivers"
for drivername in ${drvr_names}; do
	C_file "${driversdir}/${drivername}/driver.com"
	R_driver_com "${drivername}"
	C_file "${drvinfodir}/${drivertype}/drv.info"
	C_file "${drvinfodir}/${drivertype}/drv.sh"
	echo '---------------------------------------------------------------------------------------------'
done
C_file "${serverinfo}"
echo '---------------------------------------------------------------------------------------------'
C_file "${debug_conf}"
echo '============================================================================================='
C_files "${pn_csvdir}/*.csv"
echo '============================================================================================='
C_files "/hbin/www/tmp/*"
echo '============================================================================================='
C_files "${os_certs_dir}/trusted/*.der"
C_files "${os_certs_dir}/rejected/*.der"
echo '============================================================================================='
}
####################################################################################################
R_qstr () {
if test -n "${QUERY_STRING}"; then
    #echo "GET: QUERY_STRING: ${QUERY_STRING}"
    qstr="${QUERY_STRING}"
elif test -n "${CONTENT_LENGTH}"; then
    #echo "POST: CONTENT_LENGTH: ${CONTENT_LENGTH}"
    qstr=$(dd count=${CONTENT_LENGTH} bs=1 2>/dev/null)
else
	#echo "No query string"
    qstr=
fi
}
####################################################################################################
W_admin_sys () {
# ${1} : ${new_pawo_clear}
echo -n "root:${1}" | /usr/sbin/chpasswd
#echo ''
}
####################################################################################################
W_admin_web () {
# ${1} : "web:new_pawo_sha3"
echo -n "${1}" >/hbin/www/cb/userpawo
}
####################################################################################################
####################################################################################################
####################################################################################################
# NEW FUNCTIONS (no descriptions on google drive)
####################################################################################################
####################################################################################################
####################################################################################################
# (no descriptions on google drive)
# OK from Thomas
W_admin_sys_props_txt () {
# ${1} : "clear_sys_password"
sed -r 's/^passWD: [a-zA-Z0-9_-]{0,};$/passWD: '${1}';/1' -i "/cometintern/properties/props.txt"
}
# OK from Thomas
# (no descriptions on google drive)
####################################################################################################
# (no descriptions on google drive)
D_certs_before_reboot () {
rm -f ${os_certs_dir}/certs/privatekey/*
rm -f ${os_certs_dir}/certs/publiccert/*
}
# (no descriptions on google drive)
####################################################################################################
# (no descriptions on google drive)
G_month_num () {
# ${1} : month abbreviation english
N=
case "${1}" in
	Jan)N=1;;Feb)N=2;;Mar)N=3;;Apr)N=4;;May)N=5;;Jun)N=6;;Jul)N=7;;Aug)N=8;;Sep)N=9;;Oct)N=10;;Nov)N=11;;Dec)N=12;;*);;
esac
echo "${N}"
return 0
}
# (no descriptions on google drive)
####################################################################################################
# (no descriptions on google drive)
G_date_from_cert () {
# ${1} : certificate date string
M=$(G_month_num $(echo $(echo "${1}" | cut -d '=' -f 2) | cut -d ' ' -f 1))
D=$(echo $(echo "${1}" | cut -d '=' -f 2) | cut -d ' ' -f 2)
T=$(echo $(echo "${1}" | cut -d '=' -f 2) | cut -d ' ' -f 3)
Y=$(echo $(echo "${1}" | cut -d '=' -f 2) | cut -d ' ' -f 4)
Z=$(echo $(echo "${1}" | cut -d '=' -f 2) | cut -d ' ' -f 5)
DATE=$(date -u -d "${Y}-${M}-${D} ${T}" '+%s')
echo "${DATE}"
return 0
}
# (no descriptions on google drive)
####################################################################################################
# (no descriptions on google drive)
C_host_is_alive () {
test -z "${1}" && echo no && return 1
PING=$(ping -c 2 -w 4 ${1} 2>/dev/null | tail -n 2 | head -n 1)
if [[ "${PING}" = '2 packets transmitted, 2 packets received, 0% packet loss' ]]; then
    echo yes
else
    echo no
fi
return 0
}
# (no descriptions on google drive)
####################################################################################################
# (no descriptions on google drive)
W_driver_com () {
# ${1} : ${drivername}
driver_com="${driversdir}/${1}/driver.com"
if [ -f "${driver_com}" ]; then
    reconto="${dc_time}"
    devaddr="${dc_addn};${dc_addr};${dc_port};${dc_rack};${dc_slot}"
    scancyc="${dc_scan};${dc_cycl}"
    sed -r "/reconnecttimeout/{n;s/.*/"${reconto}"/};/deviceaddress/{n;s/.*/"${devaddr}"/};/scancyclic/{n;s/.*/"${scancyc}"/}" -i "${driver_com}"
else
	return 1
fi
return 0

}
# (no descriptions on google drive)
####################################################################################################
# (no descriptions on google drive)
R_config_txt_i01_old () {
if [ -f "${config_txt}" ]; then
	while read line; do
	# eth0 IP Address
        test "${ipflag}" = "0" && pat="${patip}" || pat="${patna}"
        [[ "${line}" =~ '#ethIP0 '    ]] && read line && [[ "${line}" =~ ${pat} ]] && i0_old="${line//[^0-9.]/}"
	# eth1 IP Address
        test "${ipflag}" = "0" && pat="${patip}" || pat="${patna}"
        [[ "${line}" =~ '#ethIP1 '    ]] && read line && [[ "${line}" =~ ${pat} ]] && i1_old="${line//[^0-9.]/}"
	done <<< "$(cat ${config_txt})"
else
	return 1
fi
return 0
}
# (no descriptions on google drive)
####################################################################################################
# (no descriptions on google drive)
C_network () {
	# check network
	S0='<BROADCAST,MULTICAST,UP,LOWER_UP>'
	S1='<NO-CARRIER,BROADCAST,MULTICAST,UP>'
	S2='<BROADCAST,MULTICAST>'
	I=0
	while(test "${I}" -lt 10);do
		#STAT0=$(ip addr show eth0 | head -n 1 | cut -d' ' -f3)
		#STAT1=$(ip addr show eth1 | head -n 1 | cut -d' ' -f3)
		STAT=$(ip addr show eth0 | head -n 1 | cut -d' ' -f3)
		case "${STAT}" in
			${S0}) break ;;
			${S1}|${S2}|*) ;;
		esac
		I=$((I+1))
		sleep 2
	done
	sleep 5
	# check network
}
S_datetime_once () {
    test -n "${1}" && ts="${1}" || ts=$(cat /etc/default/ntpdate | head -n 1 | cut -d '"' -f 2)
    
    echo "+++ Starting NTPDATE Once ..."
    ntpdate -b -u "${ts}"
    
    if test "${?}" = '0'; then
        echo -n "+++ Setting HardwareClock"
        hwclock --systohc
        echo "."
		echo "+++ Get time from timeserver" >/dev/kmsg
	else
		echo "+++ Get NO time from timeserver" >/dev/kmsg
    fi
    
    return 0
}
S_datetime () {
    test -n "${1}" && ts="${1}" || ts=$(cat /etc/default/ntpdate | head -n 1 | cut -d '"' -f 2)
	sleep 20
	#C_network
	S_datetime_once "${ts}"
    return 0
}
# (no descriptions on google drive)
####################################################################################################
####################################################################################################
####################################################################################################
# NEW FUNCTIONS (no descriptions on google drive)
####################################################################################################
####################################################################################################
####################################################################################################
####################################################################################################
####################################################################################################
####################################################################################################
####################################################################################################
####################################################################################################
####################################################################################################
####################################################################################################
####################################################################################################
####################################################################################################
####################################################################################################
####################################################################################################
####################################################################################################
####################################################################################################
hbstyle () { echo '
<head><style type="text/css">
@font-face {font-family:UbuMonoReg; src:url("/cb/UbuntuMono-R.ttf") format("TrueType");}
body {font-family:UbuMonoReg;font-size:18px;font-weight:800;background-color:#363636;color:#228c8b;}
a {text-decoration: none;color:#228c8b;}
</style></head>'
return 0
}
####################################################################################################
showProgress () {
	cDB="${1}"
	cur="${2}"
	end="${3}"
	div="${4}"
	out=
	case "$((${cur}%4))" in
		0) out='|'  ;;
		1) out='/'  ;;
		2) out='-'  ;;
		3) out='\\' ;;
		*) ;;
	esac
	echo -n '<script type="text/javascript">'
	echo -n 'document.getElementById("'${div}'").innerHTML="'
	test "${cur}" -lt "${end}" && echo -n "${out}" || echo -n '*'
	echo -n " ${cDB}: ${cur} of ${end} rows done."
	echo -n '"'
	echo -n '</script>'
	return 0
}
####################################################################################################

