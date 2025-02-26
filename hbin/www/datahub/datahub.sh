#!/bin/bash
####################################################################################################
# D_ (delete) , C_ (check) , G_ (get) , L_ (list) , R_ (read) , S_ (set) , W_ (write)
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
