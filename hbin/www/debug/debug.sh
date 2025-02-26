#!/bin/bash
####################################################################################################
# D_ (delete) , C_ (check) , G_ (get) , L_ (list) , R_ (read) , S_ (set) , W_ (write)
####################################################################################################
R_qstr () {
if test -n "${QUERY_STRING}"; then
    #echo "GET: QUERY_STRING: ${QUERY_STRING}"
    qstr="${QUERY_STRING}"
elif test -n "${CONTENT_LENGTH}"; then
    #echo "POST: CONTENT_LENGTH: ${CONTENT_LENGTH}"
    qstr=$(dd count=${CONTENT_LENGTH} bs=1 2>/dev/null)
else
	#echo "No query string"
    qstr=
fi
}
####################################################################################################
R_debug_conf () {
if [ -f "${debug_conf}" ]; then
	debug_nodes=''
	while read line; do
		[[ "${line}" =~ ${patbl} ]] && debug_state="${line}"
		[[ "${line}" =~ ${patnb} ]] && debug_level="${line}"
		[[ "${line}" =~ ${patnd} ]] && debug_nodes="${line}"
	done <<< "$(cat ${debug_conf})"
	# Levels 1 (1), 2 (2), 3 (4), 4 (8), 5 (16)
	if [[ "${debug_level}" -lt 32 ]]; then
		DEC="${debug_level}"; BIN=; NUM="${DEC}"
		while [[ "${NUM}" -ne 0 ]];do BIT=$((${NUM} % 2));BIN="${BIT}${BIN}";NUM=$((${NUM} / 2));done
		BIT=$(echo "${BIN}" | rev | cut -c1)
		if [[ "${BIT}" != '' && "${BIT}" -eq 1 ]];then dl1check="checked"; fi
		BIT=$(echo "${BIN}" | rev | cut -c2)
		if [[ "${BIT}" != '' && "${BIT}" -eq 1 ]];then dl2check="checked"; fi
		BIT=$(echo "${BIN}" | rev | cut -c3)
		if [[ "${BIT}" != '' && "${BIT}" -eq 1 ]];then dl3check="checked"; fi
		BIT=$(echo "${BIN}" | rev | cut -c4)
		if [[ "${BIT}" != '' && "${BIT}" -eq 1 ]];then dl4check="checked"; fi
		BIT=$(echo "${BIN}" | rev | cut -c5)
		if [[ "${BIT}" != '' && "${BIT}" -eq 1 ]];then dl5check="checked"; fi
	else
		dl1check="checked"; dl2check="checked"; dl3check="checked"; dl4check="checked"; dl5check="checked"
	fi
else
	return 1
fi
return 0
}
####################################################################################################
W_debug_conf () {
#cp "${debug_conf}" "${debug_conf}.$(date +%s)"
debug_level=$((${l1} + ${l2} + ${l3} + ${l4} + ${l5}))
echo "${debug_state}" >  "${debug_conf}"
echo "${debug_level}" >> "${debug_conf}"
echo "${debug_nodes}" >> "${debug_conf}"
}
####################################################################################################
