#!/bin/bash
####################################################################################################
# source vars+func
####################################################################################################
source "/hbin/def-vars.txt.sh"
source "debug.sh"
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
		# debug.conf
		if test "${name}" = "debug" && test "${wert}" = "show"; then
			# Form debug begin
			echo '<form id="debug_form">'
			R_debug_conf
			# Debug State
			echo 'Debug State'
			echo '<select name="gc_ds" size="1">'
			echo -n '<option value="false" class="debug_options"'
			if test "${debug_state}" = "false"; then echo -n ' selected'; else echo -n ' disabled'; fi
			echo '>false</option>'
			echo -n '<option value="true" class="debug_options"'
			if test "${debug_state}" = "true"; then echo -n ' selected'; else echo -n ' disabled'; fi
			echo '>true</option>'
			echo '</select><br/>'
			# Debug Level
			echo '<input type="checkbox" name="gc_l1" value="1" class="debug_checks" disabled'
			if test "${dl1check}" = "checked"; then echo -n ' checked'; fi
			echo '/><label>Level 1</label><br/>'
			echo '<input type="checkbox" name="gc_l2" value="2" class="debug_checks" disabled'
			if test "${dl2check}" = "checked"; then echo -n ' checked'; fi
			echo '/><label>Level 2</label><br/>'
			echo '<input type="checkbox" name="gc_l3" value="4" class="debug_checks" disabled'
			if test "${dl3check}" = "checked"; then echo -n ' checked'; fi
			echo '/><label>Level 3</label><br/>'
			echo '<input type="checkbox" name="gc_l4" value="8" class="debug_checks" disabled'
			if test "${dl4check}" = "checked"; then echo -n ' checked'; fi
			echo '/><label>Level 4</label><br/>'
			echo '<input type="checkbox" name="gc_l5" value="16" class="debug_checks" disabled'
			if test "${dl5check}" = "checked"; then echo -n ' checked'; fi
			echo '/><label>Level 5</label><br/>'
			# Debug Nodes
			echo 'Debug Nodes:<input type="text" name="gc_dn" value="'${debug_nodes}'" class="debug_inputs" readonly size="60"/>'
			# flag for W_debug_conf
			echo '<input type="hidden" name="zzzwgc" value="0"/>'
			# Form debug end
			echo '</form>'
			# Admin
			echo '<input type="button" name="" value="Admin" onclick="javascript:show_login('"'debug',event"');" class="debug_buttons"/>'
            exit 0
		fi
		
####################################################################################################
####################################################################################################
####################################################################################################
		# vars for W_debug_conf
		zzzwgc="1"
        case "${name}" in
			zzzwgc) zzzwgc="${wert}" ;;
			gc_ds) [[ "${wert}" =~ ${patbl} ]] && debug_state="${wert}" ;;
			gc_l1) [[ "${wert}" =~ ${patnb} ]] && l1="${wert}" ;;
			gc_l2) [[ "${wert}" =~ ${patnb} ]] && l2="${wert}" ;;
			gc_l3) [[ "${wert}" =~ ${patnb} ]] && l3="${wert}" ;;
			gc_l4) [[ "${wert}" =~ ${patnb} ]] && l4="${wert}" ;;
			gc_l5) [[ "${wert}" =~ ${patnb} ]] && l5="${wert}" ;;
			gc_dn) [[ "${wert}" =~ ${patnd} ]] && debug_nodes="${wert}" ;;
			*) ;;
        esac
		test "${zzzwgc}" = "0" && W_debug_conf && exit 0
		
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
