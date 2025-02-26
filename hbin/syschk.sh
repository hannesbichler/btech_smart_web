#!/bin/bash
####################################################################################################
# source vars+func
####################################################################################################
source "/hbin/def-vars.txt.sh"
source "/hbin/def-func.txt.sh"
####################################################################################################
R_config_txt
####################################################################################################
getPID () {
    test -z "${1}" && return 0
    local PID=$(ps | awk '/'${1}'/ && !/awk/ {print $1}' OFS=' ' ORS=' ')
    test "$(echo "${PID}" | wc -w)" -eq 0 &&  echo -n "0" || echo -n "${PID%?}"
    return 0
}

numPID () {
    test -z "${1}" && echo -n "no proc" && return 0
    local NUM=$(ps | awk '/'${1}'/ && !/awk/ {print $1}' OFS=' ' ORS=' ' | wc -w)
    echo -n "${NUM}"
    return 0
}

####################################################################################################
ntpd () {
    if test "$(numPID ntpd)" -eq 1; then
        # not restarting ntpd
        #tally="$(ntpq -p | head -n 3 | tail -n 1 | cut -c 1 2>/dev/null)"
        #offset="$(ntpq -p | head -n 3 | tail -n 1 | awk '{print $9}' | cut -d '.' -f 1)"
        #msg="${msg} OK (pid: $(getPID ntpd)) (tally: ${tally}) (offset: ${offset} ms)"
        msg="${msg} OK (pid: $(getPID ntpd))"
    else
        if test "${flg}" -eq 1; then
            # restarting ntpd
            
            #/etc/init.d/ntpd stop
            #ntpdate -b "${ts}"
            #hwclock --systohc
            #/etc/init.d/ntpd start
            
            /etc/init.d/ntpd restart
            msg="${msg} restarted (pid: $(getPID ntpd)))"
        else
            msg="${msg} not started."
        fi
    fi
    return 0
}

sshd () {
    if test "$(numPID sshd)" -ge 1; then
        # not restarting sshd
        msg="${msg} OK (pid: $(getPID sshd))"
    else
        if test "${flg}" -eq 1; then
            # restarting sshd
            /etc/init.d/sshd restart
            msg="${msg} restarted (pid: $(getPID sshd)))"
        else
            msg="${msg} not started."
        fi
    fi
    return 0
}

thttpd () {
    if test "$(numPID thttpd)" -ge 1; then
        # not restarting thttpd
        msg="${msg} OK (pid: $(getPID thttpd))"
    else
        if test "${flg}" -eq 1; then
            # restarting thttpd
            /etc/init.d/thttpd restart
            msg="${msg} restarted (pid: $(getPID thttpd)))"
        else
            msg="${msg} not started."
        fi
    fi
    return 0
}

mysqld () {
    if test "$(numPID mysqld)" -ge 1; then
        # not restarting mysqld
        msg="${msg} OK (pid: $(getPID mysqld))"
    else
        if test "${flg}" -eq 1; then
            # restarting mysqld
            /etc/init.d/mysqld restart
            msg="${msg} restarted (pid: $(getPID mysqld)))"
        else
            msg="${msg} not started."
        fi
    fi
    return 0
}

ciwd () {
    if test "$(numPID cometwd)" -eq 1 && test "$(numPID javaOPC)" -eq 1; then
        # not restarting ciwd (cometwd and opcd)
        msg="${msg} OK (cometwd-pid: $(getPID cometwd)) (opcd-pid: $(getPID javaOPC))"
    else
        if test "${flg}" -eq 1; then
            # restarting ciwd (cometwd and opcd)
            /hbin/ciwd.sh restart
            msg="${msg} restarted (cometwd-pid: $(getPID cometwd)) (opcd-pid: $(getPID javaOPC))"
        else
            msg="${msg} not started."
        fi
    fi
    return 0
}

led_statecheck () {
    num=$(numPID led_statecheck)
    if test "${num}" -eq 1; then
        # not restarting led_statecheck
        msg="${msg} OK (pid: $(getPID led_statecheck))"
    else
        if test "${flg}" -eq 1; then
            if test "${num}" -eq 0 || test "${num}" -gt 1; then
                for pid in $(getPID led_statecheck); do
                    kill -1 "${pid}"
                done
                # restarting led_statecheck
                /hbin/led_statecheck.sh &
                msg="${msg} restarted (pid: $(getPID led_statecheck))"
            fi
        else
            msg="${msg} not started."
        fi
    fi
    return 0
}

broadcast_server () {
    num=$(numPID broadcast_server)
    if test "${num}" -eq 1; then
        # not restarting broadcast_server
        msg="${msg} OK (pid: $(getPID broadcast_server))"
    else
#        if test "${flg}" -eq 1; then
#            if test "${num}" -eq 0 || test "${num}" -gt 1; then
#                for pid in $(getPID broadcast_server); do
#                    kill -1 "${pid}"
#                done
                # restarting broadcast_server
                /cometintern/broadcast/broadcast_server &
                msg="${msg} restarted (pid: $(getPID broadcast_server))"
#            fi
#            /cometintern/broadcast/broadcast_server &
#        else
#            msg="${msg} not started."
#        fi
    fi
    return 0
}

bichler_smart () {
    num=$(numPID bichler_smart)
    if test "${num}" -eq 1; then
        # not restarting bichler_smart
        msg="${msg} OK (pid: $(getPID bichler_smart))"
    else
#        if test "${flg}" -eq 1; then
#            if test "${num}" -eq 0 || test "${num}" -gt 1; then
#                for pid in $(getPID bichler_smart); do
#                    kill -1 "${pid}"
#                done
                # restarting bichler_smart
                 /hbin/bichler_smart &
                 msg="${msg} restarted (pid: $(getPID bichler_smart))"
#            fi
#            /hbin/bichler_smart &
#            msg="${msg} restarted (pid: $(getPID bichler_smart))"
#        else
#            msg="${msg} not started."
#        fi
    fi
    return 0
}

home_control () {
    num=$(numPID home_control)
    if test "${num}" -eq 1; then
        # not restarting home_control
        msg="${msg} OK (pid: $(getPID home_control))"
    else
#        if test "${flg}" -eq 1; then
#            if test "${num}" -eq 0 || test "${num}" -gt 1; then
#                for pid in $(getPID smart_home); do
#                    kill -1 "${pid}"
#                done
                # restarting home_control
                /hbin/home_control &
                msg="${msg} restarted (pid: $(getPID home_control))"
#            fi
#        else
#            msg="${msg} not started."
#        fi
    fi
    return 0
}

####################################################################################################
chkPROC () {
    procs="ntpd sshd thttpd mysqld ciwd led_statecheck broadcast_server bichler_smart home_control"
    [[ "${flg}" =~ [12] ]] && echo "+++ Check Processes: ${procs}" >/dev/kmsg
    for proc in ${procs}; do
        msg="${proc}:"
        case "${proc}" in
            ntpd) ntpd ;;
            sshd) sshd ;;
            thttpd) thttpd ;;
			mysqld) mysqld ;;
            ciwd) ciwd ;;
            led_statecheck) led_statecheck ;;
            broadcast_server) broadcast_server ;;
            bichler_smart) bichler_smart ;;
	    home_control) home_control ;;
            *) msg="${msg} unknown" ;;
        esac
        [[ "${flg}" =~ [12] ]] && echo "${msg}" >/dev/kmsg
        [[ "${flg}" =~ [0] ]] && echo "${msg}"
        [[ "${flg}" =~ [3] ]] && echo "<tr><td>${msg}</td></tr>"
    done
    [[ "${flg}" =~ [12] ]] && echo "=== Check Processes: done." >/dev/kmsg
    return 0
}

chkNET () {
    nets="loop eth0 eth1"
    [[ "${flg}" =~ [12] ]] && echo "+++ Check Network: ${nets}" >/dev/kmsg
    for net in ${nets}; do
        msg="${net}:"
        case "${net}" in
            loop)
                loop=$(ip addr show lo | head -n 1 | grep LOWER_UP)
				ipad=$(ip addr show lo | tail -n 1 | sed -e 's/^[[:space:]]*//' | cut -d ' ' -f 2)
                test "${loop}" = '' && msg="${msg} down (${ipad})" || msg="${msg} up (${ipad})"
            ;;
            eth0)
                eth0=$(ip addr show eth0 | head -n 1 | grep LOWER_UP)
 				ipad=$(ip addr show eth0 | tail -n 1 | sed -e 's/^[[:space:]]*//' | cut -d ' ' -f 2)
               test "${eth0}" = '' && msg="${msg} down (${ipad})" || msg="${msg} up (${ipad})"
            ;;
            eth1)
                eth1=$(ip addr show eth1 | head -n 1 | grep LOWER_UP)
				ipad=$(ip addr show eth1 | tail -n 1 | sed -e 's/^[[:space:]]*//' | cut -d ' ' -f 2)
                test "${eth1}" = '' && msg="${msg} down (${ipad})" || msg="${msg} up (${ipad})"
            ;;
            *) msg="${msg} unknown" ;;
        esac
        [[ "${flg}" =~ [12] ]] && echo "${msg}" >/dev/kmsg
        [[ "${flg}" =~ [0] ]] && echo "${msg}"
        [[ "${flg}" =~ [3] ]] && echo "<tr><td>${msg}</td></tr>"
    done
    [[ "${flg}" =~ [12] ]] && echo "=== Check Network: done." >/dev/kmsg
    return 0
}

####################################################################################################
system_check () {
	test "$(cat /hbin/do_cron_jobs 2>/dev/null)" = "0" && echo "cron job: on" || echo "cron job: off"
    [[ "${flg}" =~ [3] ]] && echo "<table>"
    chkNET
    chkPROC
    [[ "${flg}" =~ [3] ]] && echo "</table>"
}
####################################################################################################
####################################################################################################
####################################################################################################
# flg=0     echo output
# flg=1     dmesg output + restarting processes
# flg=2     dmesg output
# flg=3     html output
####################################################################################################
####################################################################################################
####################################################################################################

flg=0
if test -z "${1}"; then
	
	if test "$(cat /hbin/do_cron_jobs 2>/dev/null)" = "0"; then
		flg=1
	fi
	
else
	
	test "${1}" = "on"  && echo 0 >/hbin/do_cron_jobs
	test "${1}" = "off" && echo 1 >/hbin/do_cron_jobs
	
	if [[ "${1}" =~ ^[0-3]$ ]]; then
		flg=${1}
	fi
	
fi

msg=''
system_check

####################################################################################################
####################################################################################################
####################################################################################################
exit 0