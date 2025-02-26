#!/bin/bash
### BEGIN INIT INFO
# Provides:          /hbin/ciwd.sh
# Required-Start:    $local_fs $network
# Required-Stop:     
# Default-Start:     S
# Default-Stop:      0 1 6
# Short-Description: Comet Intern Watch Dog by HB-Softsolution
### END INIT INFO

ciwd='/hbin/cometwd.sh'

# PID or 0
PID () {
  local pat='\{cometwd.sh\}'
  test -n "${1}" && pat="${1}"
  local pid=$(ps | awk '/'${pat}'/ && !/awk/ { print $1 }' | tr -d '\n')
  if [[ "${pid}" -gt 0 ]] ; then echo -n "${pid}"; else echo -n "0"; fi
  return 0
}

# Starts the CIWD
start () {
  echo -n "Starting CIWD: pid=$(PID) "
  if [[ "$(PID)" -gt 0 ]] ; then
    echo "is already started."
  else
    "${ciwd}" &
    # damit nach dem uebertragen der ssh channel geschlossen werden kann von java aus
    sleep 1
    local sec=0; while [ "$(PID)" -eq 0 ] && [ "${sec}" -lt 5 ];do sleep 1; sec=$((${sec} + 1));done
    if [ "$(PID)" -gt 0 ]; then echo "CIWD: pid=$(PID)"; else echo "PROBLEM: No Start. pid=$(PID)"; exit 1; fi
  fi
  return 0
}

# Stops the CIWD
stop () {
  echo -n "Stopping CIWD: pid=$(PID) "
  if [[ "$(PID)" -eq 0 ]] ; then 
    echo "is already stopped."
  else
    kill -15 "$(PID)" &
    /hbin/opcd.sh stop &
    # damit nach dem uebertragen der ssh channel geschlossen werden kann von java aus
    sleep 1
    local sec=0; while [ "$(PID)" -gt 0 ] && [ "${sec}" -lt 5 ];do sleep 1; sec=$((${sec} + 1));done
    if [ "$(PID)" -eq 0 ]; then echo "CIWD: pid=$(PID)"; else echo "Kill CIWD. pid=$(PID)"; kill -9 "$(PID)"; exit 2; fi
  fi
  return 0
}

# Show the CIWD status
status () {
  echo -n "CIWD "
  if [[ "$(PID)" -gt 0 ]] ; then echo "is started."; else echo "is stopped."; fi
  return 0
}

# Show the CIWD status
#status () {
#  echo -n "$(date) CIWD: pid=$(PID) "
#  if [[ "$(PID)" -gt 0 ]] ; then echo "CIWD is started."; else echo "CIWD is stopped."; fi
#  return 0
#}

# Parameters of /hbin/ciwd.sh
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
