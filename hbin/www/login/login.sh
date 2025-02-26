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
