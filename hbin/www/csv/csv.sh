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
