#!/bin/bash
####################################################################################################
# source vars+func
####################################################################################################
source "/hbin/def-vars.txt.sh"
source "logfiles.sh"
####################################################################################################
# HTTP Response Header (Antwort-Header-Felder)
####################################################################################################
echo "Content-Type: text/html; charset=UTF-8"
#echo "Content-Type: text/plain; charset=UTF-8"
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
####################################################################################################
####################################################################################################
if test -n "${qstr}"; then
    len1=${#qstr}
    str1=${qstr//=/}
    len2=${#str1}
    anz=$((${len1}-${len2}))
####################################################################################################
    for ((i=1;i<=${anz};i++)); do
        temp=$(echo ${qstr} | cut -d "&" -f $i-)
        nawe=$(echo ${temp} | awk -F'[&]' '{ print $1 }')
        name=$(echo ${nawe} | awk -F'[=]' '{ print $1 }')
        wert=$(echo ${nawe} | awk -F'[=]' '{ print $2 }')
        
        wert=${wert//%3D/=}
        wert=${wert//%3B/;}
        wert=${wert//%7C/|}
        
        # echo "${name} ~ ${wert}"
		
####################################################################################################
####################################################################################################
####################################################################################################
        # empty Log File
		if test "${name}" = "empty_logfile" && test -n "${wert}"; then
            if [ -d "${comet_log_dir}" ] && [ -f "${comet_log_dir}/${wert}" ]; then
                echo -n >"${comet_log_dir}/${wert}"
            fi
            exit 0
        fi
        
####################################################################################################
		# list Log Files
		if test "${name}" = "logfiles" && test "${wert}" = "show"; then
            if [ -d "${comet_log_dir}" ]; then
                comet_log_files=$(ls -1 "${comet_log_dir}")
            else
                comet_log_files=
            fi
			if test "${#comet_log_files}" -gt 0; then
				echo '<ul>'
				for LF in ${comet_log_files}; do
                    SZ=$(ls -lh "${comet_log_dir}/${LF}" | awk '{print $5}')
                    NM=$(echo ${LF} | cut -d'.' -f1)
                    echo '<li>'
                    echo '<a class="a_'${NM}'" download>'${LF}' ('${SZ}')</a>'
                    echo '<input type="button" value="Prepare for Download" onclick="javascript:prepare_log_file('"'"${LF}"'"');"/>'
                    echo '<input type="button" value="Empty Logfile" onclick="javascript:empty_log_file('"'"${LF}"'"');"/>'
                    echo '</li>'
				done
				echo '</ul>'
			else
				echo '<ul><li>no files</li></ul>'
			fi
            exit 0
		fi
		
####################################################################################################
		# Prepare Log File for Download
		if test "${name}" = "logfile" && test -n "${wert}"; then
            awk 'sub("$","\r")' "${comet_log_dir}/${wert}" >"/hbin/www/log/${wert}"
            gzip -f "/hbin/www/log/${wert}"
            echo "${wert}" | cut -d'.' -f1
            exit 0
		fi
		
####################################################################################################
####################################################################################################
####################################################################################################
	# for ((i=1;i<=${anz};i++)); do
    done
####################################################################################################
# if test -n "${qstr}"; then
fi
####################################################################################################
####################################################################################################
####################################################################################################
exit 0
####################################################################################################
