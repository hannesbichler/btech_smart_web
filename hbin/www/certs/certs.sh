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
# (no descriptions on google drive)
G_month_num () {
# ${1} : month abbreviation english
N=
case "${1}" in
	Jan)N=1;;Feb)N=2;;Mar)N=3;;Apr)N=4;;May)N=5;;Jun)N=6;;Jul)N=7;;Aug)N=8;;Sep)N=9;;Oct)N=10;;Nov)N=11;;Dec)N=12;;*);;
esac
echo "${N}"
return 0
}
# (no descriptions on google drive)
####################################################################################################
# (no descriptions on google drive)
G_date_from_cert () {
# ${1} : certificate date string
M=$(G_month_num $(echo $(echo "${1}" | cut -d '=' -f 2) | cut -d ' ' -f 1))
D=$(echo $(echo "${1}" | cut -d '=' -f 2) | cut -d ' ' -f 2)
T=$(echo $(echo "${1}" | cut -d '=' -f 2) | cut -d ' ' -f 3)
Y=$(echo $(echo "${1}" | cut -d '=' -f 2) | cut -d ' ' -f 4)
Z=$(echo $(echo "${1}" | cut -d '=' -f 2) | cut -d ' ' -f 5)
DATE=$(date -u -d "${Y}-${M}-${D} ${T}" '+%s')
echo "${DATE}"
return 0
}
# (no descriptions on google drive)
####################################################################################################
