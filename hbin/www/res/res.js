/*################################################################################*/
/* VARIABLES */
// datahub/datahub.js: menu_show_datahub()
// res/res.js: hide_login(flag)
var INFOInterval;
var NTPDInterval;
// login/login.js: login_admin(toedit)
//var hold_web_user='';
//var hold_web_pawo='';
var hold_web_user='web';
var hold_web_pawo='abc';
/* VARIABLES */

/*################################################################################*/
/* HIDE LOGIN */
function hide_login (flag) {cleanUP(flag);}
/* HIDE LOGIN */

/*################################################################################*/
/* cleanUP */
function cleanUP (flag) {
	//var F = flag.toString();
	//var flag1 = F.charAt(1);
	//var flag2 = F.charAt(2);
	// flag=0 : empty "stat"-div
	if (flag == 0) {
		document.getElementById("stat").innerHTML = "";
	}
	// flag=1 : empty "main"+"stat"-divs
	if (flag == 1) {
		document.getElementById("stat").innerHTML = "";
		document.getElementById("main").innerHTML = "";
	}
	// flag=2 : menu_show_datahub
	if (flag == 2) {
		menu_show_datahub();
	}
	// flag=3 : nothing
	if (flag == 3) {}
	// loginTOP
	rm_loginTOP();
	// CTRL + INFO + NTPD
	hide_CIN();
}
/* cleanUP */

/*################################################################################*/
/* rm_loginTOP */
function rm_loginTOP(){if(document.getElementById("loginTOP")){document.getElementById("loginTOP").remove();}}
/* rm_loginTOP */

/*################################################################################*/
/* hide_CIN */
function hide_CIN(){
	// CTRL
	$('#CTRL').hide();
	document.getElementById("CTRL").innerHTML = "";
	// INFO
	$('#INFO').hide();
	clearInterval(INFOInterval);
	document.getElementById("INFO").innerHTML = "";
	// NTPD
	$('#NTPD').hide();
	clearInterval(NTPDInterval);
	document.getElementById("NTPD").innerHTML = "";
}
/* hide_CIN */

/*################################################################################*/
/* BOOT */
// datahub/datahub.js: dataHUB_reboot()
// config/config.js: save_config()
// */*.js: *()
// ipaddr  ::: ip-address-1
function bootReady(ipaddr) {
	var R = $.ajax({
		url: 'http://'+ipaddr+'/datahub/datahub.cgi',
		data: 'bootReady='+ipaddr,
		method: 'POST',
		cache: false,
		crossDomain: true,
		xhrFields: { },
		headers: { },
		contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
		timeout: 5000,
		success: function(data,textStatus,jqXHR){ window.location.href = "http://"+data; },
		error: function(jqXHR,textStatus,errorThrown){
			bootNow(ipaddr);
		},
		beforeSend: function(jqXHR,settings){ newMESG("Reboot dataHUB on "+ipaddr); },
		complete: function(jqXHR,textStatus,errorThrown){ delMESG("Reboot dataHUB on "+ipaddr); },
	});
}

function bootNow(ipaddr){
	bootReady(ipaddr);
}

function bootWait(ipaddr){
	addBlankDIV();
	newMESG("Reboot dataHUB on "+ipaddr);
	setTimeout(function(){
		delMESG("Reboot dataHUB on "+ipaddr);
		bootReady(ipaddr);
	},20000);
}

function addBlankDIV() {
	var blankDIV = document.createElement('DIV');
	blankDIV.style.position="absolute";
	blankDIV.style.left="0px";
	blankDIV.style.top="0px";
	blankDIV.style.height="100%";
	blankDIV.style.width="100%";
	document.getElementsByTagName("BODY")[0].appendChild(blankDIV);

}
/* BOOT */

/*################################################################################*/

