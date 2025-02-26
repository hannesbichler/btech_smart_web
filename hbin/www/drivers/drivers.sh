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
