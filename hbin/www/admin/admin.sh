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
W_admin_web () {
# ${1} : "web:new_pawo_sha3"
echo -n "${1}" >/hbin/www/res/userpawo
}
####################################################################################################
W_admin_sys () {
# ${1} : ${new_pawo_clear}
echo "root:${1}" | /usr/sbin/chpasswd -c SHA512
#echo ''
}
####################################################################################################
# (no descriptions on google drive)
# OK from Thomas
W_admin_sys_props_txt () {
# ${1} : "clear_sys_password"
sed -r 's/^passWD: [a-zA-Z0-9_-]{0,};$/passWD: '${1}';/1' -i "/cometintern/properties/props.txt"
}
# OK from Thomas
# (no descriptions on google drive)
####################################################################################################
