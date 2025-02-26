#!/bin/bash
####################################################################################################
# source vars+func
####################################################################################################
source "/hbin/def-vars.txt.sh"
source "certs.sh"
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
    #dn=''
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
		# Move Certs
		if test "${name}" = "movecerts"; then
		
			/hbin/ciwd.sh stop &>/dev/null
			while test "$(/hbin/ciwd.sh pid)" -gt 0; do sleep 1; done
			
			LS=$(ls -1 ${os_certs_dir}/trusted/*.der ${os_certs_dir}/rejected/*.der 2>/dev/null)
			
			echo "name=${name}"
			echo "wert=${wert}"
			echo "LS=${LS}"
			
			if test -n "${wert}"; then
				patCertsTrusted=$(echo '/.*/('$(echo ${wert} | tr ';' '|')')')
				if test "${#LS}" -gt 0; then
					for F in ${LS}; do
						if [[ "${F}" =~ ${patCertsTrusted} ]]; then
							[[ "${F}" =~ /rejected/ ]] && mv "${F}" "${os_certs_dir}/trusted/$(basename ${F})"
						else
							[[ "${F}" =~ /trusted/ ]] && mv "${F}" "${os_certs_dir}/rejected/$(basename ${F})"
						fi
					done
				fi
			fi
			if test -z "${wert}"; then
				if test "${#LS}" -gt 0; then
					for F in ${LS}; do
						[[ "${F}" =~ /trusted/ ]] && mv "${F}" "${os_certs_dir}/rejected/$(basename ${F})"
					done
				fi
			fi
			
			#S/hbin/ciwd.sh start &>/dev/null
			
            exit 0
		fi

####################################################################################################
		# List Certs
		if test "${name}" = "certs" && test "${wert}" = "show"; then
			
			LSserver=$(ls -1 ${os_certs_dir}/certs/publiccert/*.der 2>/dev/null)
            if test "${#LSserver}" -gt 0; then
				echo '<ul>'
				for F in ${LSserver}; do
					echo '<li>'
                    echo "$(basename ${F})"
					echo '</li>'
                done
				echo '</ul>'
            fi
            
            echo '<hr>'
            
			LS=$(ls -1 ${os_certs_dir}/trusted/*.der ${os_certs_dir}/rejected/*.der 2>/dev/null)
			
			if test "${#LS}" -gt 0; then
				echo '<ul>'
				for F in ${LS}; do
					Isubject=$(openssl x509 -inform DER -in ${F} -noout -subject)
					L=$(ls -e "${F}" | awk '{print $5,$6,$7,$8,$9,$10,$11}')
					S=$(echo "${L}" | cut -d ' ' -f 1)
					D=$(echo "${L}" | cut -d ' ' -f 2-5)
					Y=$(echo "${L}" | cut -d ' ' -f 6)
					N=$(echo "${L}" | cut -d ' ' -f 7)
					N=$(basename ${N})
					echo '<li>'
					
					echo '<input type="checkbox" '
					echo 'id="cb_certs_checkbox_id" name="cb_certs_checkbox_name[]" class="cb_certs_checkboxes_class" '
					echo 'value="'${N}'" '
					[[ "${F}" =~ /trusted/ ]] && echo 'checked="checked" '
					echo 'disabled/>'
					
					echo '<div style="display:inline;border-radius:6px;padding:1px;'
					echo 'background-color:';[[ "${F}" =~ /trusted/ ]] && echo 'darkgreen;' || echo 'darkred;'
					echo '">'
					echo "&nbsp;${N}"
					echo '</div>'
					
					echo '&nbsp;<div style="font-size:14px;display:inline;">'${Isubject}'</div>'
					
					echo '<ul>'
						#[[ "${F}" =~ /trusted/ ]] && echo '<li>TRUSTED</li>' || echo '<li>REJECTED</li>'
						#echo "<li>${D} $(date +%Z) ${Y}, ${S} bytes</li>"
						
						curDate=$(date -u '+%s')
						
						InotBefore=$(openssl x509 -inform DER -in ${F} -noout -startdate)
						secNotBefore=$(( $(G_date_from_cert "${InotBefore}") - ${curDate} ))
						echo '<li>'${InotBefore}' <div style="display:inline;'
						if test "${secNotBefore}" -lt 0; then
							echo 'color:green;">(valid since '$((${secNotBefore} / 86400 * -1))' days)'
						else
							echo 'color:red;">(not valid for '$((${secNotBefore} / 86400))' days)'
						fi
						echo '</div></li>'
						
						InotAfter=$(openssl x509 -inform DER -in ${F} -noout -enddate)
						secNotAfter=$(( $(G_date_from_cert "${InotAfter}") - ${curDate} ))
						echo '<li>'${InotAfter}' <div style="display:inline;'
						if test "${secNotAfter}" -gt 0; then
							echo 'color:green;">(valid for '$((${secNotAfter} / 86400))' days)'
						else
							echo 'color:red;">(not valid since '$((${secNotAfter} / 86400 * -1))' days)'
						fi
						echo '</div></li>'
					echo '</ul>'
					
					echo '</li>'
				done
				echo '</ul>'
			else
				echo '<ul><li>no files</li></ul>'
			fi
			
			#echo '<input type="button" name="" value="Save" onclick="move_certs();">'
			echo '<input type="button" name="" value="Admin" class="cb_certs_buttons_class" onclick="show_login('"'certs_move',event"');">'
			
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
