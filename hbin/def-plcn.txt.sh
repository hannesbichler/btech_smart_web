####################################################################################################
####################################################################################################
####################################################################################################
xml_header () {
	echo -n > ${pn_fxml}
	echo '<?xml version="1.0" encoding="UTF-8"?>' >> ${pn_fxml}
	echo '<NodeSet xmlns:i="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://opcfoundation.org/UA/2008/02/Types.xsd">' >> ${pn_fxml}
	echo '<NamespaceUris>' >> ${pn_fxml}
	echo '<String>http://opcfoundation.org/UA/</String>' >> ${pn_fxml}
	echo '<String>urn:localhost:UASDK:HB-Server</String>' >> ${pn_fxml}
	echo '<String>http://opcfoundation.org/UA/Diagnostics</String>' >> ${pn_fxml}
	#### csv names: fuer jede DB ein <String> tag
	for dbname in "${@}"; do
		echo '<String>http://hbs-siemens/'${dbname}'</String>' >> ${pn_fxml}
	done
	echo '</NamespaceUris>' >> ${pn_fxml}
	echo '<ServerUris/>' >> ${pn_fxml}
	echo '<Nodes>' >> ${pn_fxml}
}
####################################################################################################
xml_objectnode () {
	dbname="${1}"
	ns_cnt="${2}"
	i_cnt="${3}"
	#### node mit counter 1
	echo '<Node i:type="ObjectNode">' >> ${pn_fxml}
	echo '<NodeId>' >> ${pn_fxml}
	#### node mit counter i=1 (pro DB)
	#### counter: ns=${pn_NS};i=${pn_NC}
	echo '<Identifier>ns='${ns_cnt}';i='${i_cnt}'</Identifier>' >> ${pn_fxml}
	echo '</NodeId>' >> ${pn_fxml}
	echo '<NodeClass>Object_1</NodeClass>' >> ${pn_fxml}
	echo '<BrowseName>' >> ${pn_fxml}
	echo '<NamespaceIndex>0</NamespaceIndex>' >> ${pn_fxml}
	#### db name
	echo '<Name>'${dbname}'</Name>' >> ${pn_fxml}
	echo '</BrowseName>' >> ${pn_fxml}
	echo '<DisplayName>' >> ${pn_fxml}
	echo '<Locale>en</Locale>' >> ${pn_fxml}
	#### db name
	echo '<Text>'${dbname}'</Text>' >> ${pn_fxml}
	echo '</DisplayName>' >> ${pn_fxml}
	echo '<Description>' >> ${pn_fxml}
	echo '<Locale>en</Locale>' >> ${pn_fxml}
	#### db name
	echo '<Text>'${dbname}'</Text>' >> ${pn_fxml}
	echo '</Description>' >> ${pn_fxml}
	echo '<WriteMask>0</WriteMask>' >> ${pn_fxml}
	echo '<UserWriteMask>0</UserWriteMask>' >> ${pn_fxml}
	echo '<References>' >> ${pn_fxml}
	echo '<ReferenceNode>' >> ${pn_fxml}
	echo '<ReferenceTypeId>' >> ${pn_fxml}
	echo '<Identifier>i=35</Identifier>' >> ${pn_fxml}
	echo '</ReferenceTypeId>' >> ${pn_fxml}
	echo '<IsInverse>true</IsInverse>' >> ${pn_fxml}
	echo '<TargetId>' >> ${pn_fxml}
	#### i=85 bleibt, nur bei <Node> ersetzen
	echo '<Identifier>i=85</Identifier>' >> ${pn_fxml}
	echo '</TargetId>' >> ${pn_fxml}
	echo '</ReferenceNode>' >> ${pn_fxml}
	echo '<ReferenceNode>' >> ${pn_fxml}
	echo '<ReferenceTypeId>' >> ${pn_fxml}
	echo '<Identifier>i=40</Identifier>' >> ${pn_fxml}
	echo '</ReferenceTypeId>' >> ${pn_fxml}
	echo '<IsInverse>false</IsInverse>' >> ${pn_fxml}
	echo '<TargetId>' >> ${pn_fxml}
	echo '<Identifier>i=58</Identifier>' >> ${pn_fxml}
	echo '</TargetId>' >> ${pn_fxml}
	echo '</ReferenceNode>' >> ${pn_fxml}

	
	echo '</References>' >> ${pn_fxml}
	echo '<EventNotifier>1</EventNotifier>' >> ${pn_fxml}
	echo '</Node>' >> ${pn_fxml}
	#----------------------------------------------------------------------------------------------#
}
####################################################################################################
xml_node_header () {
	name="${1}"
	ns_cnt="${2}"
	i_cnt="${3}"
	echo '<Node i:type="VariableNode">' >> ${pn_fxml}
	echo '<NodeId>' >> ${pn_fxml}
	#### node mit counter i=2,3,4,... (pro DB)
	#### counter: ns=${pn_NS};i=${pn_NC}
	echo '<Identifier>ns='${ns_cnt}';i='${i_cnt}'</Identifier>' >> ${pn_fxml}
	echo '</NodeId>' >> ${pn_fxml}
	echo '<NodeClass>Variable_2</NodeClass>' >> ${pn_fxml}
	echo '<BrowseName>' >> ${pn_fxml}
	echo '<NamespaceIndex>0</NamespaceIndex>' >> ${pn_fxml}
	#### db name
	echo '<Name>'${name}'</Name>' >> ${pn_fxml}
	echo '</BrowseName>' >> ${pn_fxml}
	echo '<DisplayName>' >> ${pn_fxml}
	echo '<Locale i:nil="true"/>' >> ${pn_fxml}
	#### db name
	echo '<Text>'${name}'</Text>' >> ${pn_fxml}
	echo '</DisplayName>' >> ${pn_fxml}
	echo '<Description>' >> ${pn_fxml}
	echo '<Locale i:nil="true"/>' >> ${pn_fxml}
	#### db name
	echo '<Text>'${name}'</Text>' >> ${pn_fxml}
	echo '</Description>' >> ${pn_fxml}
	echo '<WriteMask>0</WriteMask>' >> ${pn_fxml}
	echo '<UserWriteMask>0</UserWriteMask>' >> ${pn_fxml}
	echo '<References>' >> ${pn_fxml}
	echo '<ReferenceNode>' >> ${pn_fxml}
	echo '<ReferenceTypeId>' >> ${pn_fxml}
	echo '<Identifier>i=47</Identifier>' >> ${pn_fxml}
	echo '</ReferenceTypeId>' >> ${pn_fxml}
	echo '<IsInverse>true</IsInverse>' >> ${pn_fxml}
	echo '<TargetId>' >> ${pn_fxml}
	echo '<Identifier>ns='${ns_cnt}';i=1</Identifier>' >> ${pn_fxml}
#	echo '<Identifier>i=85</Identifier>' >> ${pn_fxml}
	echo '</TargetId>' >> ${pn_fxml}
	echo '</ReferenceNode>' >> ${pn_fxml}
	echo '<ReferenceNode>' >> ${pn_fxml}
	echo '<ReferenceTypeId>' >> ${pn_fxml}
	echo '<Identifier>i=40</Identifier>' >> ${pn_fxml}
	echo '</ReferenceTypeId>' >> ${pn_fxml}
	echo '<IsInverse>false</IsInverse>' >> ${pn_fxml}
	echo '<TargetId>' >> ${pn_fxml}
	echo '<Identifier>i=63</Identifier>' >> ${pn_fxml}
	echo '</TargetId>' >> ${pn_fxml}
	echo '</ReferenceNode>' >> ${pn_fxml}
	echo '<ReferenceNode>' >> ${pn_fxml}
	echo '<ReferenceTypeId>' >> ${pn_fxml}
	echo '<Identifier>i=37</Identifier>' >> ${pn_fxml}
	echo '</ReferenceTypeId>' >> ${pn_fxml}
	echo '<IsInverse>false</IsInverse>' >> ${pn_fxml}
	echo '<TargetId>' >> ${pn_fxml}
	echo '<Identifier>i=78</Identifier>' >> ${pn_fxml}
	echo '</TargetId>' >> ${pn_fxml}
	echo '</ReferenceNode>' >> ${pn_fxml}
	echo '</References>' >> ${pn_fxml}
	echo '<AccessLevel>3</AccessLevel>' >> ${pn_fxml}
}
####################################################################################################
xml_node_value_array_header () {
	arrdim="${1}"
	clname="${2}"
	#### Arrays
	echo '<ArrayDimension>'${arrdim}'</ArrayDimension>' >> ${pn_fxml}
	#### SCALAR + ARRAY
	echo '<DataType>' >> ${pn_fxml}
	echo '<Identifier>i=24</Identifier>' >> ${pn_fxml}
	echo '</DataType>' >> ${pn_fxml}
	echo '<Historizing>true</Historizing>' >> ${pn_fxml}
	echo '<MinimumSamplingInterval>1000.0</MinimumSamplingInterval>' >> ${pn_fxml}
	echo '<UserAccessLevel>3</UserAccessLevel>' >> ${pn_fxml}
	#----------------------------------------------------------------------------------------------#
	echo '<Value>' >> ${pn_fxml}
	echo '<Value>' >> ${pn_fxml}
	echo '<Matrix>' >> ${pn_fxml}
	echo '<Dimensions><Int32>'${arrdim}'</Int32></Dimensions>' >> ${pn_fxml}
	#### clname
	echo '<Elements className="'${clname}'">' >> ${pn_fxml}
	#### Elements
}
####################################################################################################
xml_node_value_array_element () {
	type="${1}"
	value="${2}"
	echo '<'${type}'>'${value}'</'${type}'>' >> ${pn_fxml}
}
####################################################################################################
xml_node_value_array_footer () {
	valuerank="1"
	echo '</Elements>' >> ${pn_fxml}
	echo '</Matrix>' >> ${pn_fxml}
	echo '</Value>' >> ${pn_fxml}
	echo '</Value>' >> ${pn_fxml}
	#----------------------------------------------------------------------------------------------#
	#### valuerank: ARRAY 1
	echo '<ValueRank>'${valuerank}'</ValueRank>' >> ${pn_fxml}
}
####################################################################################################
xml_node_value_scalar () {
	type="${1}"
	value="${2}"
	valuerank="-1"
	#### SCALAR
	echo '<ArrayDimension/>' >> ${pn_fxml}
	#### SCALAR + ARRAY
	echo '<DataType>' >> ${pn_fxml}
	echo '<Identifier>i=24</Identifier>' >> ${pn_fxml}
	echo '</DataType>' >> ${pn_fxml}
	echo '<Historizing>true</Historizing>' >> ${pn_fxml}
	echo '<MinimumSamplingInterval>1000.0</MinimumSamplingInterval>' >> ${pn_fxml}
	echo '<UserAccessLevel>3</UserAccessLevel>' >> ${pn_fxml}
	#----------------------------------------------------------------------------------------------#
	#### type + value
	echo '<Value>' >> ${pn_fxml}
	echo '<Value>' >> ${pn_fxml}
	echo '<'${type}'>'${value}'</'${type}'>' >> ${pn_fxml}
	echo '</Value>' >> ${pn_fxml}
	echo '</Value>' >> ${pn_fxml}	
	#----------------------------------------------------------------------------------------------#
	#### valuerank: SCALAR -1
	echo '<ValueRank>'${valuerank}'</ValueRank>' >> ${pn_fxml}
}
####################################################################################################
xml_node_footer () {
	echo '</Node>' >> ${pn_fxml}
}
####################################################################################################
xml_footer () {
	echo '</Nodes>' >> ${pn_fxml}
	echo '</NodeSet>' >> ${pn_fxml}
}
####################################################################################################
# xml_header () { }
#...
# SCALAR
	# xml_node_header () { }
	# xml_node_value_scalar () { }
	# xml_node_footer () { }
#...
# ARRAY
	# xml_node_header () { }
	# xml_node_value_array_header () { }
		#...
		# ARRAY_ELEMENT
		# xml_node_value_array_element () { }
		#...
	# xml_node_value_array_footer () { }
	# xml_node_footer () { }
#...
# STRUCT ...
#...
# xml_footer () { }
####################################################################################################
####################################################################################################
####################################################################################################
com_header () {
	echo -n > ${pn_fcom}
	echo '<?xml version="1.0" encoding="UTF-16"?>' >> ${pn_fcom}
	echo '<DPConfiguration>' >> ${pn_fcom}
	echo '<DPs>' >> ${pn_fcom}
}
####################################################################################################
com_datapoint () {
	dbname="${1}"
	i_cnt="${2}"
	name="${3}"
	active="${4}"
	dbnumb="${5}"
	mapping="${6}"
	index="${7}"
	datatype=$(echo "${8}" | tr '[a-z]' '[A-Z]')
	arraydim="${9}"
	echo '<dp>' >> ${pn_fcom}
	# dbname: $pn_DB , i_cnt: $pn_NC (von VariableNode)
	echo '<nodeid value="ns=http://hbs-siemens/'${dbname}';i='${i_cnt}'" />' >> ${pn_fcom}
	# name: $N
	echo '<symbolname value="'${name}'" />' >> ${pn_fcom}
	# active: $A
	echo '<isactive value="'${active}'" />' >> ${pn_fcom}
	echo '<cycletime value="1000" />' >> ${pn_fcom}
	echo '<addresstype value="DB" />' >> ${pn_fcom}
	# dbnumb: $pn_DN
	echo '<address value="'${dbnumb}'" />' >> ${pn_fcom}
    # mapping: SCALAR oder ARRAY_ARRAY (oder SCALAR_ARRAY)
	echo '<mapping value="'${mapping}'" />' >> ${pn_fcom}
	# index: $I
	echo '<index value="'${index}'" />' >> ${pn_fcom}
	# datatype: ${pn_vdtype} (SCALAR Siemens-Data-Type)
	# datatype: ${pn_vdtype}[$arrdim] (ARRAY Siemens-Data-Type)
	echo '<datatype value="'${datatype}${arraydim}'" />' >> ${pn_fcom}
	echo '<description value="insert comment" />' >> ${pn_fcom}
	echo '</dp>' >> ${pn_fcom}
}
####################################################################################################
com_footer () {
	echo '</DPs>' >> ${pn_fcom}
	echo '</DPConfiguration>' >> ${pn_fcom}
}
####################################################################################################
####################################################################################################
####################################################################################################
set_XML_vdtype_clname () {
	# type: Siemens-Type
	# vdtype: OPC-Type
	# clname: Java-Type
	type="${1}"
	case "${type}" in
		"bool"|"Bool"|"BOOL")       pn_vdtype="Boolean" ; pn_clname="java.lang.Boolean" ;;
		"Byte"|"Byte"|"Byte")       pn_vdtype="Byte"    ; pn_clname="java.lang.Byte" ;;
		"int"|"Int"|"INT")          pn_vdtype="Int16"   ; pn_clname="java.lang.Short" ;;
		"dint"|"DInt"|"DINT")       pn_vdtype="Int32"   ; pn_clname="java.lang.Integer" ;;
		"word"|"Word"|"WORD")       pn_vdtype="UInt16"  ; pn_clname="org.opcfoundation.ua.builtintypes.UnsignedShort" ;;
		"dword"|"DWord"|"DWORD")    pn_vdtype="UInt32"  ; pn_clname="org.opcfoundation.ua.builtintypes.UnsignedInteger" ;;
		"real"|"Real"|"REAL")       pn_vdtype="Float"   ; pn_clname="java.lang.Float" ;;
		"string"|"String"|"STRING") pn_vdtype="String"  ; pn_clname="java.lang.String" ;;
		*)                          pn_vdtype="${type}" ; pn_clname="noclassname" ;;
	esac
}
####################################################################################################
####################################################################################################
####################################################################################################
pn_DM=1
debug () {
	test "${pn_DM}" -gt 0 && return 1
	echo "${1} : 
	RC=${pn_RC} : 
	DB=${pn_DB} : DN=${pn_DN} : DC=${pn_DC} : 
	NC=${pn_NC} : NS=${pn_NS} : 
	elecnt=${pn_elecnt} : elelst=${pn_elelst} : arrdim=${pn_arrdim}
	<br/>" >>/hbin/www/tmp/debug.log
}
####################################################################################################
####################################################################################################
####################################################################################################
checkFiles () {
	test -d $(dirname "${pn_fxml}") || return 1
	test -d $(dirname "${pn_fcom}") || return 2
	test -d $(dirname "${pn_fcom_sha1}") || return 3
	test -d "${pn_csvdir}" || return 4
	test -f "${pn_fcsv}" || return 5
	return 0
}
####################################################################################################
####################################################################################################
####################################################################################################
# 1: DB Nummer
# 2: TYPE
# 3: ARRAY
# 4: STRUCT
# 5: ELSE
# 6: END
####################################################################################################
####################################################################################################
####################################################################################################
# 
# plc_nodes hat 3 Parameter:
# plc_nodes CSV.TMP DriverName Datenbaustein-Namen
# CSV.TMP             : alle zu konvertierenden .csv Dateien werden in eine grosse csv.tmp zusammengefasst
# DriverName          : der Name des Drivers, fuer den die .csv konvertiert werden sollen
# Datenbaustein-Namen : Liste der Namen der .csv Dateien (ohne Endung)
# 
####################################################################################################
####################################################################################################
####################################################################################################
plc_nodes () {
	pn_t1=$(date +%s)
	#echo -n >/hbin/www/tmp/debug.log
	echo -n "START" >/hbin/www/tmp/progress
####################################################################################################
    ###### DATA_NODES.XML + DATAPOINTS.COM
    ### csv-Row-Counter
    pn_RC=0
    ### Datenbaustein-Name
    pn_DB=""
    ### Datenbaustein-Number
    pn_DN=0
    ### Datenbaustein-Counter
    pn_DC=0
    ### ns-Counter (ns=[012] already exist)
    pn_NS=2
    ### Datenbaustein-Node-Counter (i=)
    pn_NC=0
    ### valuedatetype
    pn_vdtype=""
    ### classname
    pn_clname=""
    ### number of array elements
    pn_arrdim=0
    ### index of last array element (arrdim-1)
    pn_elelst=0
    ### array elements counter
    pn_elecnt=0
    ### number of lines in .csv
    pn_LC=0
    ### character for progress
    pn_PR=""
####################################################################################################
    ###### Pattern
    ### pn_pat0: Erste Zeile - Nummber
    pn_pat0="([1-9][0-9]{0,})([\;]{1,})"
    ### pn_pat1: Primitive Typen
    pn_pat1_1="bool|byte|int|dint|word|dword|real|string"
    pn_pat1_2="Bool|Byte|Int|DInt|Word|DWord|Real|String"
    pn_pat1_3="BOOL|BYTE|INT|DINT|WORD|DWORD|REAL|STRING"
    pn_pat1="(${pn_pat1_1}|${pn_pat1_2}|${pn_pat1_3})"
    ### pn_pat2: STRUCT
    pn_pat2="([\"]{0,}[a-zA-Z0-9][a-zA-Z0-9_-]{0,}[\"]{0,})"
    ### pn_pat3: nur ARRAY von Primitive Typen (pn_pat1)
    pn_pat3="[\"]{0,}Array\ \[0\.\.([1-9][0-9]{0,})\]\ of\ (${pn_pat1})"
    #pn_pat3="[\"]{0,}Array\ \[0\.\.([1-9][0-9]{0,})\]\ of\ (${pn_pat1}|${pn_pat2})"
    ### pn_pat4: [zahl] in name
    pn_pat4="(\[([0-9]|[1-9][0-9]{1,})\])"
####################################################################################################
    ### pn_[sa]io=1: STRUCT oder ARRAY is open: FALSE 1
    pn_sio=1 ; pn_aio=1
####################################################################################################
	pn_fcsv="${1}" ; shift
    
    pn_drnm="${1}" ; shift
    pn_fxml="/hbs/comet/opc_ua_server/servers/HBSServer/informationmodel/custom.xml"
    pn_fcom="/hbs/comet/opc_ua_server/servers/HBSServer/drivers/${pn_drnm}/datapoints.com"
    pn_fcom_sha1="/hbs/comet/opc_ua_server/servers/HBSServer/drivers/${pn_drnm}/datapoints.com.sha1"
    
    pn_csvdir="/hbs/comet/opc_ua_server/servers/HBSServer/drivers/${pn_drnm}/csv"
    
	checkFiles ; cF="${?}" ; test "${cF}" -gt 0 && echo -n "ERROR" >/hbin/www/tmp/progress && return "${cF}"
	pn_LC=$(wc -l "${pn_fcsv}" | cut -d ' ' -f 1)
	xml_header "${@}"
	com_header
####################################################################################################
	while read line; do
####################################################################################################
		### csv-Row-Counter
		((pn_RC=${pn_RC}+1))
####################################################################################################
		### Felder: Active , Name , Type , Index , Value
		A=$(echo "${line}" | cut -d ';' -f 1)
		N=$(echo "${line}" | cut -d ';' -f 2)
		T=$(echo "${line}" | cut -d ';' -f 3)
		I=$(echo "${line}" | cut -d ';' -f 4)
		V=$(echo "${line}" | cut -d ';' -f 5)
		test "${A}" = "x" && A="true" || A="false"
####################################################################################################
		### 1: Nummer der DB
		if [[ "${line}" =~ ^${pn_pat0}$ ]]; then
			pn_DB="${1}" ; shift
			pn_DN=$(echo "${line}" | cut -d ';' -f 1)
			((pn_DC=${pn_DC}+1))
			((pn_NS=${pn_NS}+1))
			pn_NC=1
			xml_objectnode "${pn_DB}" "${pn_NS}" "${pn_NC}"
			debug 1__
####################################################################################################
		### 2: TYPE (SCALAR , element of ARRAY , NO struct)
		elif [[ "${T}" =~ ^${pn_pat1}$ ]]; then
			### valuedatatype + classname
			set_XML_vdtype_clname "${T}"
			### SCALAR
			if [[ ! "${N}" =~ ${pn_pat4} && "${pn_aio}" -eq 1 ]]; then
				((pn_NC=${pn_NC}+1))
				xml_node_header "${N:-noname}" "${pn_NS}" "${pn_NC}"
				xml_node_value_scalar "${pn_vdtype}" "${V:-novalue}"
				xml_node_footer
				com_datapoint "${pn_DB:-noDB}" "${pn_NC:-noNC}" "${N:-noname}" "${A}" "${pn_DN:-noDN}" "SCALAR" "${I:-0}" "${T}" ''
				debug 21_
			### element of ARRAY
			elif [[ "${N}" =~ ${pn_pat4} && "${pn_aio}" -eq 0 ]]; then
				pn_elecnt="${BASH_REMATCH[2]}"
				if test "${pn_elecnt}" -lt "${pn_elelst}"; then
					xml_node_value_array_element "${pn_vdtype}" "${V:-novalue}"
					debug 221
				elif test "${pn_elecnt}" -eq "${pn_elelst}"; then
					xml_node_value_array_element "${pn_vdtype}" "${V:-novalue}"
					xml_node_value_array_footer
					xml_node_footer
					# setze ARRAY is open: FALSE 1
					pn_aio=1
					pn_arrdim=0
					pn_elelst=0
					pn_elecnt=0
					debug 222
				else
					debug 223
				fi
				debug 22_
			### no SCALAR , no element of ARRAY , STRUCT ???
			else
				debug 23_
			fi
			debug 2__
####################################################################################################
		### 3: ARRAY: "Array [n..m] of ""TYPE|STRUCT"""
		elif [[ "${T}" =~ ^${pn_pat3}$ ]]; then
			### valuedatatype + classname
			T="${BASH_REMATCH[2]}"
			set_XML_vdtype_clname "${T}"
			# starte neuen ARRAY, wenn pn_aio=1: ARRAY is open: FALSE 1
			if test "${pn_aio}" -eq 1; then
				((pn_NC=${pn_NC}+1))
				pn_elelst="${BASH_REMATCH[1]}"
				pn_arrdim=$((${BASH_REMATCH[1]}+1))
				# setze ARRAY is open: TRUE 0
				pn_aio=0
				xml_node_header "${N:-noname}" "${pn_NS}" "${pn_NC}"
				xml_node_value_array_header "${pn_arrdim}" "${pn_clname}"
				com_datapoint "${pn_DB:-noDB}" "${pn_NC:-noNC}" "${N:-noname}" "${A}" "${pn_DN:-noDN}" "ARRAY_ARRAY" "${I:-0}" "${T}" "[${pn_arrdim}]"
				debug 31_
			fi
			debug 3__
####################################################################################################
		### 4: STRUCT
		elif [[ "${T}" =~ ^${pn_pat2}$ ]]; then
			# pn_sio=0: STRUCT is open: TRUE 0
			if test "${pn_sio}" -eq 0; then struct_index="${I}"; fi
			# pn_sio=1: STRUCT is open: FALSE 1
			if test "${pn_sio}" -eq 1; then struct_index="${I}"; fi
			#pn_sio=0
			debug 4__
####################################################################################################
		### 5: ELSE
		else
			#echo -n ''
			debug 5__
		fi
####################################################################################################
		echo -n "${pn_DB}:${pn_RC}:${pn_LC}" >/hbin/www/tmp/progress
####################################################################################################
	done <<< "$(cat ${pn_fcsv})"
	### 6: END
	xml_footer
	com_footer
	openssl sha1 "${pn_fcom}" | awk '{print $2}' | tr -d '\n' > "${pn_fcom_sha1}"
	debug 6___
####################################################################################################
	echo -n "END" >/hbin/www/tmp/progress
	echo "${pn_LC} rows in $(($(date +%s)-${pn_t1})) sec"
	return 0
####################################################################################################
}
#### plc_nodes
####################################################################################################
####################################################################################################
####################################################################################################
####################################################################################################
####################################################################################################
####################################################################################################
####################################################################################################


