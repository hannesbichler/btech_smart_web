#!/bin/bash
####################################################################################################
# source vars+func+plcn
####################################################################################################
#source "/hbin/def-vars.txt.sh"
source "csv.sh"
####################################################################################################
# HTTP Response Header (Antwort-Header-Felder)
####################################################################################################
echo "Content-Type: text/plain; charset=UTF-8"
#echo "Content-Type: text/html; charset=UTF-8"
echo "Access-Control-Allow-Origin: *"
#echo "Access-Control-Allow-Credentials: false"
#echo "Access-Control-Expose-Headers: X-Custom-Header"
#echo "Access-Control-Max-Age: 86400"
#echo "Access-Control-Allow-Methods: POST"
#echo "Access-Control-Allow-Headers: true"
echo ""
####################################################################################################
R_qstr
####################################################################################################
DN=''
DNpat='name="([a-zA-Z][a-zA-Z0-9_-]{0,})"'
[[ "${qstr}" =~ ${DNpat} ]] && DN="${BASH_REMATCH[1]}"
####################################################################################################
DBs=''
pat='filename="([a-zA-Z0-9][a-zA-Z0-9_-]{0,})\.csv"'
for db in ${qstr}; do [[ "${db}" =~ ${pat} ]] && DBs="${DBs} ${BASH_REMATCH[1]}"; done
DBs=$(echo "${DBs}" | cut -c 2-)
qstr=$(echo "${qstr}" | sed -e '/name=".*"/d/DRIVERNAME/d/^\s*$/d/^Content-/d/^-----/d' | tr -d '\r')
####################################################################################################
pn_driversdir="/hbs/comet/opc_ua_server/servers/HBSServer/drivers"
pn_drvrname="${DN}"
pn_csv_upld="${pn_driversdir}/${pn_drvrname}/csv"
####################################################################################################
makecsv () {
	echo "${qstr}" >"${pn_csv_upld}/temp"
	pat="([1-9][0-9]{0,})([\;]{1,})"
	while read line; do
		if [[ "${line}" =~ ^${pat}$ ]]; then
			DB="${1}" ; shift
			echo "${line}" >"${pn_csv_upld}/${DB}.csv"
		else
			echo "${line}" >>"${pn_csv_upld}/${DB}.csv"
		fi
	done <<< "$(cat ${pn_csv_upld}/temp)"
	rm "${pn_csv_upld}/temp"
}
makecsv ${DBs}
####################################################################################################
showcsv () {
	echo '==========================================================================<br/>'
	for DB in ${DBs}; do
		echo "${DB}.csv<br/>"
		echo '--------------------------------------------------------------------------<br/>'
		cat "${pn_csv_upld}/${DB}.csv"
		echo '==========================================================================<br/>'
	done
}
#showcsv ${DBs}
####################################################################################################
exit 0
####################################################################################################
