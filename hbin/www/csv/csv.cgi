#!/bin/bash
####################################################################################################
# source vars+func
####################################################################################################
source "/hbin/def-vars.txt.sh"
source "csv.sh"
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
		# Zum Testen, ob die Dateien passen
		# TEST PLC CSV Files in /hbs/comet/opc_ua_server/servers/HBSServer/drivers/ < DRVNAME > /csv/
		if test "${name}" = "csv_files_TEST" && test -n "${wert}"; then
            
            pn_info_model="/hbs/comet/opc_ua_server/servers/HBSServer/informationmodel"
            pn_driversdir="/hbs/comet/opc_ua_server/servers/HBSServer/drivers"
			
			pn_drvrname="${DN}"
			pn_drvrname="${wert}"
			
            pn_csv_upld="${pn_driversdir}/${pn_drvrname}/csv"
			
            pn_xml_file="${pn_info_model}/custom.xml"
            pn_com_file="${pn_driversdir}/${pn_drvrname}/datapoints.com"
            pn_sha_file="${pn_driversdir}/${pn_drvrname}/datapoints.com.sha1"
			
			if "${wert}" = "afterLIST"; then
				# Zum Testen, ob die Dateien passen (LIST)
				LS="${pn_xml_file} ${pn_com_file} ${pn_sha_file}"
				if test "${#LS}" -gt 0; then
					echo '<fieldset>'
					echo '<div># Zum Testen, ob die Dateien passen</div>'
					echo '<div># csv/csv.cgi?csv_files_list=XYZ : Listing</div>'
					echo '<div># csv/csv.cgi?csv_files_convert=XYZ : cp (/hbin/www/tmp) + chmod 644 (show in browser)</div>'
					echo '<ul>'
					for F in ${LS}; do
						if test -f "${F}"; then
							L=$(ls -e "${F}" | awk '{print $5,$6,$7,$8,$9,$10,$11}')
							S=$(echo "${L}" | cut -d ' ' -f 1)
							D=$(echo "${L}" | cut -d ' ' -f 2-5)
							Y=$(echo "${L}" | cut -d ' ' -f 6)
							N=$(echo "${L}" | cut -d ' ' -f 7)
							N=$(basename ${N})
							echo '<li>'
							
							bn=$(basename ${F})
							bnpat="^(datapoints\.com)$"
							[[ "$(basename ${F})" =~ ${bnpat} ]] && link="/tmp/${bn}.xml" || link="/tmp/${bn}"
							echo '<a href="'${link}'" target="_blank">'${F}'</a>'
							
							#echo "${F}"
							
							echo " ( ${D} $(date +%Z) ${Y}, ${S} bytes )"
							echo '</li>'
						else
							#echo '<li>no file '${F}'</li>'
							echo '<li style="color:red;">'${F}'</li>'
						fi
					done
					echo '</ul>'
					echo '</fieldset>'
				else
					echo 'no files<br/>'
				fi
				# Zum Testen, ob die Dateien passen (LIST)
			fi
			
			if "${wert}" = "afterCONVERT"; then
				# Zum Testen, ob die Dateien passen (CONVERT)
				cp "${pn_xml_file}" "/hbin/www/tmp/custom.xml"
				cp "${pn_com_file}" "/hbin/www/tmp/datapoints.com.xml"
				cp "${pn_sha_file}" "/hbin/www/tmp/datapoints.com.sha1"
				chmod 644 "/hbin/www/tmp/custom.xml"
				chmod 644 "/hbin/www/tmp/datapoints.com.xml"
				chmod 644 "/hbin/www/tmp/datapoints.com.sha1"
				# Zum Testen, ob die Dateien passen (CONVERT)
            fi
			
            exit 0
		fi
		# Zum Testen, ob die Dateien passen

####################################################################################################
####################################################################################################
####################################################################################################
		# List PLC CSV Files in /hbs/comet/opc_ua_server/servers/HBSServer/drivers/ < DRVNAME > /csv/
		# drivers/drivers.js
		if test "${name}" = "csv_files_list" && test -n "${wert}"; then
            
            pn_info_model="/hbs/comet/opc_ua_server/servers/HBSServer/informationmodel"
            pn_driversdir="/hbs/comet/opc_ua_server/servers/HBSServer/drivers"
			pn_drvrname="${wert}"
            pn_csv_upld="${pn_driversdir}/${pn_drvrname}/csv"
            pn_xml_file="${pn_info_model}/custom.xml"
            pn_com_file="${pn_driversdir}/${pn_drvrname}/datapoints.com"
            pn_sha_file="${pn_driversdir}/${pn_drvrname}/datapoints.com.sha1"

			LS=$(ls -1 ${pn_csv_upld}/*.csv 2>/dev/null)
			if test "${#LS}" -gt 0; then
				echo '<ul>'
				for F in ${LS}; do
					L=$(ls -e "${F}" | awk '{print $5,$6,$7,$8,$9,$10,$11}')
					S=$(echo "${L}" | cut -d ' ' -f 1)
					D=$(echo "${L}" | cut -d ' ' -f 2-5)
					Y=$(echo "${L}" | cut -d ' ' -f 6)
					N=$(echo "${L}" | cut -d ' ' -f 7)
					N=$(basename ${N})
					echo '<li>'
					echo '<input type="checkbox" id="cb_files_checkbox_id" name="cb_files_checkbox_name[]" value="'${F}'" class="csv_files_options" disabled>'
					echo '<a href="javascript:csv_file_show('"'"${F}"'"')">'${N}'</a>'
					echo "<label>( ${D} $(date +%Z) ${Y}, ${S} bytes )</label>"
					echo '</li>'
				done
				echo '</ul>'
			else
				echo '<ul><li>no files in '${pn_csv_upld}'</li></ul>'
			fi
			
			echo '<input type="button" name="" value="Admin" class="csv_files_buttons" onclick="javascript:show_login('"'csv_files',event"');" />'
			echo '<input type="button" name="" value="Convert" class="csv_files_buttons_hidden" hidden="hidden" onclick="csv_files_convert('"'"${pn_drvrname}"'"');">'
			echo '<input type="button" name="" value="Delete" class="csv_files_buttons_hidden" hidden="hidden" onclick="csv_files_delete('"'"${pn_drvrname}"'"');">'
			echo '<input type="file" class="csv_files_buttons_hidden" hidden="hidden" id="cb_files_upload_form_id" multiple="multiple" onchange="csv_files_upload('"'"${pn_drvrname}"'"',this.files);">'
			echo '<input type="button" name="" value="Back" class="csv_files_buttons_hidden" hidden="hidden" onclick="javascript:menu_show_driver('"'"${pn_drvrname}"'"');"/>'
            exit 0
		fi

####################################################################################################
		# Convert PLC CSV Files in /hbs/comet/opc_ua_server/servers/HBSServer/drivers/ < DRVNAME > /csv/
		if test "${name}" = "csv_files_convert" && test -n "${wert}"; then
			
			/hbin/ciwd.sh stop &>/dev/null
			
			while test "$(/hbin/ciwd.sh pid)" -gt 0; do sleep 1; done
			
            # DriverName
            DN=$(echo ${wert} | cut -d ' ' -f 1)
            # Voller Pfad zu den .csv Dateien
            fDBs=$(echo ${wert} | cut -d ' ' -f 2-)
            
            pn_info_model="/hbs/comet/opc_ua_server/servers/HBSServer/informationmodel"
            pn_driversdir="/hbs/comet/opc_ua_server/servers/HBSServer/drivers"
            pn_drvrname="${DN}"
            pn_csv_upld="${pn_driversdir}/${pn_drvrname}/csv"
            pn_xml_file="${pn_info_model}/custom.xml"
            pn_com_file="${pn_driversdir}/${pn_drvrname}/datapoints.com"
            pn_sha_file="${pn_driversdir}/${pn_drvrname}/datapoints.com.sha1"

			echo -n >"${pn_csv_upld}/csv.tmp"
            DBs=''
			for DB in ${fDBs}; do
                cat "${DB}" >>"${pn_csv_upld}/csv.tmp";
                DBs="${DBs%????} $(basename ${DB})"
            done
			
            echo "${DN} ${DBs%????}"
            
            source "/hbin/def-plcn.txt.sh"
			plc_nodes "${pn_csv_upld}/csv.tmp" "${DN}" ${DBs%????}
			
			echo "plc_nodes returns ${?}<br/>"
			
			/hbin/ciwd.sh start &>/dev/null
			
			rm "${pn_csv_upld}/csv.tmp"
			
            exit 0
		fi

####################################################################################################
		# Delete PLC CSV File(s) in /hbs/comet/opc_ua_server/servers/HBSServer/drivers/ < DRVNAME > /csv/
		if test "${name}" = "csv_files_delete" && test -n "${wert}"; then
			for csv in ${wert}; do
				rm "${csv}"
			done
            exit 0
		fi

####################################################################################################
		# Show PLC CSV File in /hbs/comet/opc_ua_server/servers/HBSServer/drivers/ < DRVNAME > /csv/
		if test "${name}" = "csv_file_show" && test -n "${wert}"; then
			while read line; do
				if [[ "${line}" =~ ^([1-9][0-9]{0,})([\;]{1,})$ ]]; then
					echo '<label>'${wert}'</label>'
					echo '<label>('$(echo "${line}" | cut -d ';' -f 1)')</label>'
					echo '<table border="1">'
					echo '<tr><th>Active</th><th>Name</th><th>Type</th><th>Index</th><th>Value</th></tr>'
				else
					### Felder: Active , Name , Type , Index , Value
					A=$(echo "${line}" | cut -d ';' -f 1)
					N=$(echo "${line}" | cut -d ';' -f 2)
					T=$(echo "${line}" | cut -d ';' -f 3)
					I=$(echo "${line}" | cut -d ';' -f 4)
					V=$(echo "${line}" | cut -d ';' -f 5)
					test "${A}" = "x" && A="true" || A="false"
					echo "<tr><td>${A}</td><td>${N}</td><td>${T}</td><td>${I}</td><td>${V}</td></tr>"
				fi
			done <<< "$(cat ${wert})"
			echo '</table>'
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
