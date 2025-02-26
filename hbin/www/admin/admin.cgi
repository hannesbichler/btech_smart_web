#!/bin/bash
####################################################################################################
# source vars+func
####################################################################################################
source "/hbin/def-vars.txt.sh"
source "admin.sh"
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
		# admin menu
		if test "${name}" = "admin" && test "${wert}" = "show"; then
			echo '<ul>'
			echo '<li>change web ("web") password<input type="button" name="" value="Admin" onclick="javascript:show_login('"'admin_web',event"');" class="admin_web_buttons"/></li>'
			echo '<li>change sys ("root") password<input type="button" name="" value="Admin" onclick="javascript:show_login('"'admin_sys',event"');" class="admin_sys_buttons"/></li>'
			echo '<li>change date<input type="button" name="" value="Admin" onclick="javascript:show_login('"'sysdate',event"');" class="admin_web_buttons"/></li>'
			echo '</ul>'
            exit 0
		fi
		
####################################################################################################
		# Change dataHUB Date+Time
		if test "${name}" = "change_sysdate" && test -n "${wert}"; then
            date -s "${wert}" >/dev/null
            exit 0
		fi

####################################################################################################
		# pawo_web (change web password) (wert: web:SHA3_password)
		if test "${name}" = "pawo_web" && test -n "${wert}"; then
			W_admin_web "${wert}"
            exit 0
		fi
		
####################################################################################################
		# Confirm System Login
#		if test "${name}" = "user_sys" && test -n "${wert}"; then
		if test "${name}" = "user_sys"; then
			#pawo0=$(cat /etc/shadow | grep root | cut -d ':' -f 2 | cut -d '$' -f 4)
			salt0=$(cat /etc/shadow | grep root | cut -d ':' -f 2 | cut -d '$' -f 3)
			sapa0=$(cat /etc/shadow | grep root | cut -d ':' -f 2)
			wert0=$(/hbin/passwd-sha512 "${wert}" "${salt0}")
			test "${sapa0}" = "${wert0}" && echo -n "OK" || echo -n "NO"
            exit 0
		fi
		
####################################################################################################
		# pawo_sys (change sys password) (${wert}: clear_sys_password)
#		if test "${name}" = "pawo_sys" && test -n "${wert}"; then
		if test "${name}" = "pawo_sys"; then
			W_admin_sys "${wert}"
			W_admin_sys_props_txt "${wert}"
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
