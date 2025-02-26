#!/bin/bash
####################################################################################################
# source vars+func
####################################################################################################
source "/hbin/def-vars.txt.sh"
source "config.sh"
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
		# config.txt + drivers
		if test "${name}" = "config" && test "${wert}" = "show"; then
			# Form config begin
			echo '<form id="config_form">'
			# config.txt
			R_config_txt
			echo '<table>'
			
			echo '<tr><td>Hostname  </td><td><input type="text" name="ct_hn" value="'${hn}'" class="config_inputs" readonly/>'
			echo '<input type="checkbox" name="ct_dy" value="" class="config_checks" disabled'
			test "${dy}" = "true" && echo ' checked'
			echo '/>Your DNS server can resolve this hostname: '${hn}
			echo '</td></tr>'
			
            ### eth0 100Mbit PLC
			echo '<tr><td>PLC net IP</td><td><input type="text" name="ct_i0" value="'${i0}'" class="config_inputs" readonly/></td></tr>'
			echo '<tr><td>PLC net NM</td><td><input type="text" name="ct_n0" value="'${n0}'" class="config_inputs" readonly/></td></tr>'
			#echo '<tr><td>PLC net GW</td><td><input type="text" name="ct_g0" value="'${g0}'" class="config_inputs" readonly/></td></tr>'
            
            ### eth1 1Gbit OPC
			echo '<tr><td>OPC net IP</td><td><input type="text" name="ct_i1" value="'${i1}'" class="config_inputs" readonly/></td></tr>'
			echo '<tr><td>OPC net NM</td><td><input type="text" name="ct_n1" value="'${n1}'" class="config_inputs" readonly/></td></tr>'
			#echo '<tr><td>OPC net GW</td><td><input type="text" name="ct_g1" value="'${g1}'" class="config_inputs" readonly/></td></tr>'
            
			echo '<tr><td>OPC Port</td><td><input type="text" name="ct_op" value="'${op}'" class="config_inputs" readonly/></td></tr>'
            
			echo '<tr><td>Timeserver</td><td><input type="text" name="ct_ts" value="'${ts}'" class="config_inputs" readonly/>'
			echo '<input type="checkbox" name="ct_st" value="" class="config_checks" disabled'
			test "${st}" = "true" && echo ' checked'
			echo '/>Act as Timeserver for the dataHUBs'
            echo '</td></tr>'
            
			echo '</table>'
				# PLC IP wird in Drivers eingetragen
				#<tr><td>PLC IP    </td><td><input type="text" name="ct_pi" value="'${pi}'" class="config_inputs" readonly/></td></tr>
			# drivernames
			L_drivers
			for DN in ${drvr_names}; do
				echo '<input type="checkbox" name="'${DN}'" value="'${DN}'" title="'${DN}'" class="config_checks" disabled'
				if [[ "${dn}" =~ ${DN} ]]; then echo ' checked'; fi
				echo '/><label onclick="javascript:menu_show_driver('"'"${DN}"'"');" class="config_labels">'${DN}'</label>'
			done
			# flag for W_config_txt
			echo '<input type="hidden" name="zzzwct" value="0"/>'
			# Form config end
			echo '</form>'
			# Admin
			echo '<input type="button" name="" value="Admin" onclick="javascript:show_login('"'config',event"');" class="config_buttons"/>'
            exit 0
		fi
		        
####################################################################################################
####################################################################################################
####################################################################################################
		# vars for W_config_txt
		zzzwct="1"
		case "${name}" in
			zzzwct)
				zzzwct="${wert}" ;;
			ct_hn)
				test "${wdflag}" = "0" && pat="${patwd}" || pat=".*"
				[[ "${wert}" =~ ${pat} ]] && hn="${wert}" ;;
			ct_dy)
				dy="true" ;;
			ct_i0)
				test "${ipflag}" = "0" && pat="${patip}" || pat="${patna}"
				[[ "${wert}" =~ ${pat} ]] && i0="${wert}" ;;
			ct_n0)
				test "${nmflag}" = "0" && pat="${patnm}" || pat="${patna}"
				[[ "${wert}" =~ ${pat} ]] && n0="${wert}" ;;
#			ct_g0)
#				test "${ipflag}" = "0" && pat="${patip}" || pat="${patna}"
#				[[ "${wert}" =~ ${pat} ]] && g0="${wert}" ;;
			ct_i1)
				test "${ipflag}" = "0" && pat="${patip}" || pat="${patna}"
				[[ "${wert}" =~ ${pat} ]] && i1="${wert}" ;;
			ct_n1)
				test "${nmflag}" = "0" && pat="${patnm}" || pat="${patna}"
				[[ "${wert}" =~ ${pat} ]] && n1="${wert}" ;;
#			ct_g1)
#				test "${ipflag}" = "0" && pat="${patip}" || pat="${patna}"
#				[[ "${wert}" =~ ${pat} ]] && g1="${wert}" ;;
			ct_ts)
				ts="${wert}" ;;
#			ct_ts)
#				test "${ipflag}" = "0" && pat="${patip}" || pat="${patna}"
#				[[ "${wert}" =~ ${pat} ]] && ts="${wert}" ;;
			ct_st)
				st="true" ;;
#			ct_pi)
#				test "${ipflag}" = "0" && pat="${patip}" || pat="${patna}"
#				[[ "${wert}" =~ ${pat} ]] && pi="${wert}" ;;
			ct_op)
				test "${nbflag}" = "0" && pat="${patnb}" || pat='.*'
				[[ "${wert}" =~ ${pat} ]] && op="${wert}" ;;
			*)
				test "${wdflag}" = "0" && pat="${patwd}" || pat='.*'
				[[ "${wert}" =~ ${pat} ]] && dn="${wert};${dn}" ;;
        esac
		if test "${zzzwct}" = "0"; then
            R_config_txt_i01_old
            test "${i1_old}" != "${i1}" && D_certs_before_reboot >/dev/null
            
			/hbin/ciwd.sh stop &>/dev/null
			W_config_txt >/dev/null
            
			# return ip-address-1 (already the new one when changed)
			echo "${i1}"
			
			/hbin/bbox.sh &>/dev/null &
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
