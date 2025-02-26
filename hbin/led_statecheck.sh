#!/bin/bash
####################################################################################################
# source vars+func
####################################################################################################
source "/hbin/def-vars.txt.sh"
source "/hbin/def-func.txt.sh"
####################################################################################################
while(true); do
	case "$(cat /cometintern/watchdog/server.state)" in
	0)
		S_leds_off
		;;
	1)
		S_led_62 0
		if [ "$(cat /sys/class/gpio/gpio3/value)" -eq 1 ]; then S_led_03 0; else S_led_03 1; fi
		S_led_63 0
		;;
	2)
		S_leds 0 1 0 # LED03 ON
		;;
	3)
		S_leds 1 0 0 # LED62 ON
		;;
	4)
		S_led_62 0
		S_led_03 0
		if [ "$(cat /sys/class/gpio/gpio63/value)" -eq 1 ]; then S_led_63 0; else S_led_63 1; fi
		;;
	*)
		;;
	esac
	usleep 200000 
done
exit 0
