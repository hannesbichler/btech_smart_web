#!/bin/bash

datadirs="cometintern/ hbin/"
fulldirs="cometintern/ hbin/ hbs/* etc/ home/"

case "${1}" in
	data) files=${datadirs} ;;
	full) files=${fulldirs} ;;
	*) echo "unknown backup method" && echo "$(basename ${0}) [ data | full ]" && exit 1 ;;
esac

echo "dirs: ${files}"

cd /

E=
N=
for F in ${files}; do
	if test -e "${F}"; then
		E="${E} ${F}"
	else
		N="${N} ${F}"
	fi
done

D=$(date +'%Y-%m-%d_%H-%M')

if test -n "${E}"; then
	echo "existing dirs: ${E}"
	case "${1}" in
		data) tar -cf  "bkup_data_${D}.tar" ${E} ;;
		full) tar -czf "bkup_full_${D}.tgz" ${E} ;;
		#data)  ;;
		#full)  ;;
	esac
else
	echo "no directories for tar"
fi

test -n "${N}" && echo " missing dirs: ${N}"

exit 0
