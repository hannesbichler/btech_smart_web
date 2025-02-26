#!/bin/bash
####################################################################################################
# source vars+func
####################################################################################################
source "/hbin/def-vars.txt.sh"
source "datahub.sh"
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
		# wait after reboot for startup
		# bootReady(data)
		# data: ip address to reload browser
		if test "${name}" = "bootReady" && test -n "${wert}"; then
			echo "${wert}"
            exit 0
		fi

####################################################################################################
        # REBOOT dataHUB (no changes for the ip-addresses)
		# return ip-address-1 (already the new one when changed)
		if test "${name}" = "dataHUB" && test "${wert}" = "ReBoot"; then
            R_config_txt
            echo "${i1}"
			/hbin/ciwd.sh stop &>/dev/null
			/hbin/bbox.sh &>/dev/null &
            exit 0
        fi

####################################################################################################
####################################################################################################
####################################################################################################
		# dataHUB menu
		if test "${name}" = "datahub" && test "${wert}" = "show"; then
			echo '<table>'
			#echo '<tr><td><b>Watchdog</b></td><td>'
			#test "$(/hbin/ciwd.sh pid)" -gt "0" && echo -n 'ON' || echo -n 'OFF'
			#echo '</td></tr>'
			#echo '<tr><td><b>OPC UA Server</b></td><td>'
			#test "$(/hbin/opcd.sh pid)" -gt "0" && echo -n 'ON' || echo -n 'OFF'
			#echo '</td></tr>'
			R_server_info
			echo '<tr><td>Version           </td><td><b>'${srvv}'</b></td></tr>'
			echo '<tr><td>Builddate         </td><td><b>'${srvb}'</b></td></tr>'
			echo '<tr><td>Revision          </td><td><b>'${srvr}'</b></td></tr>'
			#echo '<tr><td>Web               </td><td><a href="'${srvw}'" target="_blank"><b>Server-Info</b></a></td></tr>'
			#echo '<tr><td>Description       </td><td></td></tr>'
			echo '<tr><td colspan="2">'${srvd}'</td></tr>'
            ### System Check
            #echo "$(/hbin/syschk.sh 3)"
			### dataHUBversion
			test -f "/hbin/version.txt" && dataHUBversion=$(cat /hbin/version.txt) || dataHUBversion='not available'
			echo '<tr><td>dataHUB Version   </td><td><b>'${dataHUBversion}'</b></td></tr>'
			###
			echo '</table>'
            exit 0
		fi

####################################################################################################
####################################################################################################
####################################################################################################
        # dataHUB INFO
		if test "${name}" = "dataHUB" && test "${wert}" = "INFO"; then
            echo '<table><tr><td>'
            
            echo '<table style="border:1px white solid;">'
            # S_leds {62} {3} {63}
            # /cometintern/watchdog/server.state
            # 0) S_leds_off
            # 1) S_leds 0 X 0 # LED03 (OK) blinkt
            # 2) S_leds 0 1 0 # LED03 (OK) ON
            # 3) S_leds 1 0 0 # LED62 (ERROR) ON
            # 4) S_leds 0 0 X # LED63 (MAINT) blinkt
            # *) S_leds_off
            style_red_off="background-color:white;border-radius:50%;width:12px;height:12px;border: 4px solid red"
            style_red_on="background-color:red;border-radius:50%;width:12px;height:12px;border: 4px solid red"
            style_green_off="background-color:white;border-radius:50%;width:12px;height:12px;border: 4px solid green"
            style_green_on="background-color:green;border-radius:50%;width:12px;height:12px;border: 4px solid green"
            style_orange_off="background-color:white;border-radius:50%;width:12px;height:12px;border: 4px solid orange"
            style_orange_on="background-color:orange;border-radius:50%;width:12px;height:12px;border: 4px solid orange"
            case "$(cat /cometintern/watchdog/server.state)" in
                # ERROR (62) (RED)
                # OK (3) (GREEN)
                # MAINT (63) (ORANGE)
            0)
                echo '<tr><td><div style="'${style_red_off}'"></div></td><td>ERROR</td></tr>'
                echo '<tr><td><div style="'${style_green_off}'"></div></td><td>OK</td></tr>'
                echo '<tr><td><div style="'${style_orange_off}'"></div></td><td>MAINT</td></tr>'
                ;;
            1)
                echo '<tr><td><div style="'${style_red_off}'"></div></td><td>ERROR</td></tr>'
                echo '<tr><td><div style="'${style_green_off}'" id="blink_green"></div></td><td>OK</td></tr>'
                echo '<tr><td><div style="'${style_orange_off}'"></div></td><td>MAINT</td></tr>'
                ;;
            2)
                echo '<tr><td><div style="'${style_red_off}'"></div></td><td>ERROR</td></tr>'
                echo '<tr><td><div style="'${style_green_on}'"></div></td><td>OK</td></tr>'
                echo '<tr><td><div style="'${style_orange_off}'"></div></td><td>MAINT</td></tr>'
                ;;
            3)
                echo '<tr><td><div style="'${style_red_on}'"></div></td><td>ERROR</td></tr>'
                echo '<tr><td><div style="'${style_green_off}'"></div></td><td>OK</td></tr>'
                echo '<tr><td><div style="'${style_orange_off}'"></div></td><td>MAINT</td></tr>'
                ;;
            4)
                echo '<tr><td><div style="'${style_red_off}'"></div></td><td>ERROR</td></tr>'
                echo '<tr><td><div style="'${style_green_off}'"></div></td><td>OK</td></tr>'
                echo '<tr><td><div style="'${style_orange_off}'" id="blink_orange"></div></td><td>MAINT</td></tr>'
                ;;
            *)
                echo '<tr><td><div style="'${style_red_off}'"></div></td><td>ERROR</td></tr>'
                echo '<tr><td><div style="'${style_green_off}'"></div></td><td>OK</td></tr>'
                echo '<tr><td><div style="'${style_orange_off}'"></div></td><td>MAINT</td></tr>'
                ;;
            esac
            # POWER (GREEN)
            echo '<tr><td><div style="'${style_green_on}'"></div></td><td>POWER</td></tr>'
            echo '</table>'
            
            echo '</td><td>'
            
            echo '<table>'
            # OPCD STATUS
            echo '<tr><td><div>'$(/hbin/opcd.sh status)'</div></td></tr>'
            # SYSDATETIME
            #echo '<tr><td colspan="2"><div>'"$(date) ($(hostname))"'</div></td></tr>'
            # same as new Date() in JavaScript
            echo '<tr><td><div>'$(date +'%a %b %d %Y %H:%M:%S GMT%z (%Z)')'</div></td></tr>'
            # BrowserDateTime
            echo '<tr><td><div id="BrDtTm">''</div></td></tr>'
            echo '</table>'
            
            echo '</td></tr></table>'
            
            exit 0
        fi
        
####################################################################################################
####################################################################################################
####################################################################################################
        # dataHUB NTPD
		if test "${name}" = "dataHUB" && test "${wert}" = "NTPD"; then
        # check NTP
            R_config_txt
            
            echo '<table>'
            
            ### host is alive ?
            if test $(C_host_is_alive "${ts}" 2>/dev/null) = "yes"; then
                echo "<tr><td>Timeserver is alive.</td></tr>"
            else
                echo "<tr><td>Timeserver is not alive.</td></tr>"
            fi
            
            ### only 1 NTPD process ?
            if test $(ps | awk '/ntpd/ && !/awk/ {print $1}' OFS=' ' ORS=' ' | wc -w) -eq 1; then
                echo "<tr><td>NTPD is running.</td></tr>"
                # Peer Status Word - The Select Field displays the current selection status.
                # Code 	Message 	    T 	    Description
                # 0 	sel_reject 	    [space]	discarded as not valid (TEST10-TEST13)
                # 1 	sel_falsetick 	x 	    discarded by intersection algorithm
                # 2 	sel_excess 	    . 	    discarded by table overflow (not used)
                # 3 	sel_outlyer 	- 	    discarded by the cluster algorithm
                # 4 	sel_candidate 	+ 	    included by the combine algorithm
                # 5 	sel_backup 	    # 	    backup (more than tos maxclock sources)
                # 6 	sel_sys.peer 	* 	    system peer
                # 7 	sel_pps.peer 	o 	    PPS peer (when the prefer peer is valid)
                #line="$(ntpq -p | head -n 3 | tail -n 1 2>/dev/null)"
                #tally="$(echo ${line} | cut -c 1 2>/dev/null)"
                #offset="$(echo ${line} | awk '{print $9}' | cut -d '.' -f 1 2>/dev/null)"
                #tally="$(ntpq -p | head -n 3 | tail -n 1 | cut -c 1 2>/dev/null)"
                #case "${tally}" in
                #    ' ' | 'x' | '.' | '-') echo "<tr><td>Status is not OK.</td></tr>" ;;
                #    '+' | '#' | '*' | 'o') echo "<tr><td>Status is OK.</td></tr>" ;;
                #    *) echo "<tr><td>Status is unknown.</td></tr>" ;;
                #esac
                #offset="$(ntpq -p | head -n 3 | tail -n 1 | awk '{print $9}' | cut -d '.' -f 1 2>/dev/null)"
                #echo "<tr><td>Offset is ${offset} ms.</td></tr>"
            else
                echo "<tr><td>NTPD is not running.</td></tr>"
            fi
            
            echo '</table>'
            
            exit 0
        fi

####################################################################################################
####################################################################################################
####################################################################################################
        # dataHUB CTRL
		if test "${name}" = "dataHUB" && test "${wert}" = "CTRL"; then
        # CONTROL the dataHUB
            echo '<table>'
            echo '<tr>'
            #echo '<td><input onclick="opcd('"'stat'"','"'restart'"');;" type="button" value="Restart OPC"/></td>'
            echo '<td><input onclick="show_login('"'OPC_restart',event"');" type="button" value="Restart OPC"/></td>'
            echo '</tr><tr>'
            #echo '<td><input onclick="opcd('"'stat'"','"'stop'"');" type="button" value="Stop OPC"/></td>'
            echo '<td><input onclick="show_login('"'OPC_stop',event"');" type="button" value="Stop OPC"/></td>'
            echo '</tr><tr>'
            #echo '<td><input onclick="dataHUB_reboot();" type="button" value="Reboot dataHUB"/></td>'
            echo '<td><input onclick="show_login('"'dataHUB_reboot',event"');" type="button" value="Reboot dataHUB"/></td>'
            echo '</tr>'
            echo '</table>'
            exit 0
        fi

####################################################################################################
        # dataHUB CTRL OPCD {CIWD start restart stop status pid}
		if test "${name}" = "OPCD" && test -n "${wert}"; then
            /hbin/ciwd.sh "${wert}" &>/dev/null &
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
