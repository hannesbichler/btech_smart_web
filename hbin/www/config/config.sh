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
# (no descriptions on google drive)
D_certs_before_reboot () {
rm -f ${os_certs_dir}/certs/privatekey/*
rm -f ${os_certs_dir}/certs/publiccert/*
}
# (no descriptions on google drive)
####################################################################################################
