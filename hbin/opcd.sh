#!/bin/bash
### BEGIN INIT INFO
# Provides:          /hbin/opcd.sh
# Required-Start:    $local_fs $network
# Required-Stop:     
# Default-Start:     S
# Default-Stop:      0 1 6
# Short-Description: OPC Server by HB-Softsolution
### END INIT INFO

opcd='/hbs/comet/opc_ua_server/servers/startup.sh'

# PID or 0
PID () {
  local pat='javaOPC'
  test -n "${1}" && pat="${1}"
  local pid=$(ps | awk '/'${pat}'/ && !/awk/ { print $1 }' | tr -d '\n')
  if [[ "${pid}" -gt 0 ]] ; then echo -n "${pid}"; else echo -n "0"; fi
}

PIDstartup () { PID '\{startup.sh\}'; }
DWNstartup () { kill -6 "$(PIDstartup)" & }

# Starts the OPCD
start () {
  echo -n "Starting OPCD: pid=$(PID) "
  if [[ "$(PID)" -gt 0 ]] ; then
    echo "is already started."
  else
    "${opcd}" &
    local sec=0; while [ "$(PID)" -eq 0 ] && [ "${sec}" -lt 5 ];do sleep 1;sec=$((${sec} + 1));done
    if [ "$(PID)" -gt 0 ]; then echo "OPCD: pid=$(PID)"; else echo "PROBLEM: No Start. pid=$(PID)"; exit 1; fi
  fi
}

# Stops the OPCD
stop () {
  echo -n "Stopping OPCD: pid=$(PID) "
  if [[ "$(PID)" -eq 0 ]] ; then 
    echo "is already stopped."
  else
    kill -15 "$(PID)" &
    local sec=0; while [ "$(PID)" -gt 0 ] && [ "${sec}" -lt 5 ];do sleep 1;sec=$((${sec} + 1));done
    if [ "$(PID)" -eq 0 ]; then echo "OPCD: pid=$(PID)"; else echo "Kill OPCD. pid=$(PID)"; kill -9 "$(PID)"; exit 2; fi
  fi
}

# Show the OPCD status
status () {
  echo -n "OPC "
  if [[ "$(PID)" -gt 0 ]] ; then echo "is started."; else echo "is stopped."; fi
}

# Show the OPCD status
#status () {
#  echo -n "OPCD: pid=$(PID) "
#  if [[ "$(PID)" -gt 0 ]] ; then echo "OPCD is started."; else echo "OPCD is stopped."; fi
#}

# Parameters of /hbin/opcd.sh
case "${1}" in
  start) start ;;
  stop) stop ;;
  restart) stop; start ;;
  status) status ;;
  pid) PID ;;
  *) echo "Usage: ${0} {start|stop|restart|status|pid}"; exit 3 ;;
esac

exit 0

# 0 started + stopped + status
# 1 start + restart
# 2 stop
# 3 usage
