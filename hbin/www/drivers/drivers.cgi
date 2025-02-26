#!/bin/bash
####################################################################################################
# source vars+func
####################################################################################################
source "/hbin/def-vars.txt.sh"
source "drivers.sh"
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
		# Driver Names for Menu
		# Driver Names + Types
        # driversdir="/hbs/comet/opc_ua_server/servers/HBSServer/drivers"
		if test "${name}" = "drivers" && [[ "${wert}" =~ ^(menu|show)$ ]]; then
			L_drivers
			test "${wert}" = "show" && echo '<ul>'
			for DN in ${drvr_names}; do
				echo '<li><a href="javascript:menu_show_driver('"'"${DN}"'"');">'${DN}'</a></li>'
			done
			test "${wert}" = "show" && echo '<ul>'
            exit 0
		fi
		
####################################################################################################
		# driver.info von drivername
		if test "${name}" = "driver" && test -n "${wert}"; then
			drivername="${wert}"
			R_driver_com "${drivername}"
			R_drv_info "${drivertype}"
			echo '<table>'
			echo '<tr><td>Drivertype</td><td><b>'${drivertype}'</b></td></tr>'
			echo '<tr><td>Drivername</td><td><b>'${drivername}'</b></td></tr>'
			echo '<tr><td>Version   </td><td><b>'${drvv}'</b></td></tr>'
			echo '<tr><td>Builddate </td><td><b>'${drvb}'</b></td></tr>'
			echo '<tr><td>Revision  </td><td><b>'${drvr}'</b></td></tr>'
			echo '<tr><td>Web       </td><td><a href="'${drvw}'" target="_blank"><b>Driver</b></a></td></tr>'
			echo '<tr><td colspan="2">'${drvd}'</td></tr>'
			echo '<tr><td colspan="2"><div id="div_driver_info_plc_ip" class="div_driver_info_plc_ip">'
			echo '<form id="driver_form">'
			echo $(${drvinfodir}/${drivertype}/drv.sh ${drivername})
            # flag for W_driver_com
			echo '<input type="hidden" name="zzzwdc" value="0"/>'
            echo '</form>'
            echo '</div></td></tr>'
            
            echo '<tr><td>'
            
            
            
            echo '</td></tr>'
            
			echo '</table>'
            exit 0
		fi
		
####################################################################################################
		# /.../runtime/drivers/ < DRVTYPE > /drv.js von drivername
		if test "${name}" = "driverscript" && test -n "${wert}"; then
			drivername="${wert}"
			R_driver_com "${drivername}"
			R_drv_info "${drivertype}"
			echo $(cat ${drvinfodir}/${drivertype}/drv.js)
            exit 0
		fi
        
####################################################################################################
####################################################################################################
####################################################################################################
		# vars for W_driver_com
		zzzwdc="1"
		case "${name}" in
            # flag for W_driver_com
			zzzwdc) zzzwdc="${wert}" ;;
            # drivername
            dc_drivername) drivername="${wert}" ;;
            # deviceaddress
			dc_addn) dc_addn="${wert}" ;;
			dc_addr) dc_addr="${wert}" ;;
			dc_port) dc_port="${wert}" ;;
			dc_rack) dc_rack="${wert}" ;;
			dc_slot) dc_slot="${wert}" ;;
            # reconnecttimeout
			dc_time) dc_time="${wert}" ;;
            # scancyclic
			dc_scan) dc_scan="true" ;;
			dc_cycl) dc_cycl="${wert}" ;;
            #
			*) ;;
        esac
		if test "${zzzwdc}" = "0"; then
			/hbin/ciwd.sh stop &>/dev/null
			W_driver_com "${drivername}" >/dev/null
			/hbin/ciwd.sh start &>/dev/null
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
