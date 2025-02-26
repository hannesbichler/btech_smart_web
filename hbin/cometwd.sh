#!/bin/bash
####################################################################################################
# source vars+func
####################################################################################################
source "/hbin/def-vars.txt.sh"
source "/hbin/def-func.txt.sh"
####################################################################################################
falle () {
	W_dmesg "___PID=${$}___Ausgabekanal 3 freigeben..."
	test -L /proc/${$}/fd/3 && exec 3>&- || W_dmesg "___PID=${$}___Kein Ausgabekanal 3"
	W_dmesg "___PID=${$}___Ausgabekanal 3 freigegeben (exec 3>&-)."
	exit 1
}
trap falle 1 2 3 6 9 15
####################################################################################################
####################################################################################################
echo
####################################################################################################
# setze WatchDogTimeout auf 70 Sekunden:
test ! -L /proc/${$}/fd/3 && /hbin/wdinfo 70 &>/dev/null
test ! -L /proc/${$}/fd/3 && WDT=$(/hbin/wdinfo|tail -n 1|cut -d ':' -f 2|cut -c 2-|tr -d '\n') || WDT=0
W_dmesg "___PID=${$}___WatchDogTimeout=${WDT} Sekunden"
####################################################################################################
# starte system watchdog
# Ausgabekanal 3 nach /dev/watchdog umleiten
exec 3>/dev/watchdog
# Ausgabekanal 3 freigeben
# exec 3>&-
####################################################################################################
log_txt="/cometintern/watchdog/log.txt"
startversuch=0
maxstarts=4
uhrzeit=$(date +%s)
####################################################################################################
W_dmesg "************  ************"
W_dmesg "************ Starte WatchDog $(date) ************"
####################################################################################################
while (true); do
####################################################################################################
	anders=0
####################################################################################################
    #W_dmesg "___PID=${$}___anders=${anders} ___if_uhrzeit+opcd.sh pid>0"
    uhrzeit_tmp=$(date -r /cometintern/watchdog/cometsrvwd +%s)
	# auswerten ob prozess existiert und aenderungsdatum anders
    if [[ "${uhrzeit}" -lt "${uhrzeit_tmp}" ]] && [ "$(/hbin/opcd.sh pid)" -gt 0 ] ; then
    	anders=1
    	uhrzeit="${uhrzeit_tmp}"
        ###
    	#W_dmesg "************ anders = ${anders} $(date) ************"
        ###
    fi
####################################################################################################
    #W_dmesg "___PID=${$}___anders=${anders} ___if_anders -eq 1"
    # Aenderungsdatum geaendert, alles OK
    if [ "${anders}" -eq 1 ] ; then
    	startversuch=0
    	#echo 1 >&3
		test -L /proc/${$}/fd/3 && echo 1 >&3 || W_dmesg "___PID=${$}___Kein Ausgabekanal 3"
        ###
    	#W_dmesg "************ Startversuch Nr. ${startversuch} $(date) ************"
        ###
    else
    	startversuch=$((${startversuch} + 1))
    	d="$(date +%Y-%m-%d-%H-%M-%S)"
    	echo "${d} Kein OPC UA Server Prozess gefunden, versuche Server neu zu starten! ${startversuch}. Versuch" >> "${log_txt}"
    	#echo 1 >&3
		test -L /proc/${$}/fd/3 && echo 1 >&3 || W_dmesg "___PID=${$}___Kein Ausgabekanal 3"
    	# versuche opc ua server neu zu starten, zaehle Versuche mit
    	# opc server start
    	#/hbin/opcd.sh restart &
    	/hbin/opcd.sh restart &>/dev/null &
    	# maxstarts erreicht
    	if [ "${startversuch}" -gt "${maxstarts}" ] ; then
    		d="$(date +%Y-%m-%d-%H-%M-%S)"
    		# maximale anzahl an startversuchen erreicht, lass watchdog system neu starten
    		echo "${d} Maximale Startversuche(5) erreicht, System wird neu gestartet." >> "${log_txt}"
    		sleep 100
    	fi
    	W_dmesg "************ Startversuch Nr. ${startversuch} $(date) ************"
    fi
####################################################################################################
	for ((i=0; i<=9; i++)); do
		#W_dmesg "___PID=${$}___anders=${anders} ___for_i=1-10 sleep 5___${i}"
		sleep 5
	done
####################################################################################################
done
####################################################################################################
W_dmesg "************ Stoppe WatchDog $(date) ************"
W_dmesg "************  ************"
####################################################################################################
exit 0
####################################################################################################
