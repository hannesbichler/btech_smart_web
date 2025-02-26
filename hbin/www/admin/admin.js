/*################################################################################*/
/* VARIABLES */
/* VARIABLES */

/*################################################################################*/
/* LOGIN */
function login_admin_web () {
	var mydiv = document.getElementById("main");
	mydiv.innerHTML += 'Web ("web")<br/>';
	mydiv.innerHTML += 'Enter new password: <input type="password" id="pawo1web" name="" value=""><br/>';
	mydiv.innerHTML += 'Re--enter password: <input type="password" id="pawo2web" name="" value=""><br/>';
	mydiv.innerHTML += '<input type="button" name="" value="Save" class="admin_web_buttons" onclick="javascript:save_admin_web();"/>';
	mydiv.innerHTML += '<input type="button" name="" value="Back" class="admin_web_buttons" onclick="javascript:menu_show_admin();"/>';
}
function login_admin_sys () {
	var mydiv = document.getElementById("main");
	mydiv.innerHTML += 'System ("root")<br/>';
	mydiv.innerHTML += '# Current password: <input type="password" id="pawo0sys" name="" value=""><br/>';
	mydiv.innerHTML += 'Enter new password: <input type="password" id="pawo1sys" name="" value=""><br/>';
	mydiv.innerHTML += 'Re--enter password: <input type="password" id="pawo2sys" name="" value=""><br/>';
	mydiv.innerHTML += '<input type="button" name="" value="Save" class="admin_sys_buttons" onclick="javascript:save_admin_sys();"/>';
	mydiv.innerHTML += '<input type="button" name="" value="Back" class="admin_sys_buttons" onclick="javascript:menu_show_admin();"/>';
}
function login_admin_sysdate () {
	var mydiv = document.getElementById("main");
	var curdate = sysdate_format_now();
	mydiv.innerHTML += 'New System Date (will converted to UTC): <input type="text" id="sysdate" name="" value="'+curdate+'" maxlength="16"><br/>';
	mydiv.innerHTML += '<input type="button" name="" value="Save" class="admin_web_buttons" onclick="javascript:save_sysdate();"/>';
	mydiv.innerHTML += '<input type="button" name="" value="Back" class="config_buttons" onclick="javascript:menu_show_admin();"/>';
	$('#sysdate').datetimepicker({dateFormat:'yy-mm-dd',timeFormat:'HH:mm',separator:' '});
}
/* LOGIN */

/*################################################################################*/
/* Fuehrende Null */
// admin/admin.js: sysdate_format_now()
function fN(n){return n<10 ? '0'+n : n}
/* Fuehrende Null */

/*################################################################################*/
/* SYSDATE_FORMAT_NOW */
// admin/admin.js: login_admin_sysdate()
function sysdate_format_now () {
	var now = new Date();
	var Y=now.getUTCFullYear();
	var M=fN(now.getUTCMonth()+1);
	var D=fN(now.getUTCDate());
	var h=fN(now.getUTCHours());
	var m=fN(now.getUTCMinutes());
	return Y+'-'+M+'-'+D+' '+h+':'+m;
}
/* SYSDATE_FORMAT_NOW */

/*################################################################################*/
/* SAVE */
function save_sysdate () {
	var mydiv = document.getElementById("stat");
	var sysdate = $('#sysdate').val();
	//
	var res1 = sysdate.split(" ");
	var date = res1[0];
	var time = res1[1];
	
	var res2 = date.split("-");
	var year = res2[0];
	var mont = res2[1];
	var days = res2[2];
	
	var res3 = time.split(":");
	var hour = res3[0];
	var minu = res3[1];
	
	var sysdate1 = new Date(year,mont,days,hour,minu);
	
	var Y=sysdate1.getUTCFullYear();
	var M=fN(sysdate1.getUTCMonth());
	var D=fN(sysdate1.getUTCDate());
	var h=fN(sysdate1.getUTCHours());
	var m=fN(sysdate1.getUTCMinutes());
	
	sysdate = Y+'-'+M+'-'+D+' '+h+':'+m;
	//
	var D = $.ajax({ url: 'admin/admin.cgi', data: 'change_sysdate='+sysdate, method: 'POST',
		success: function(data,textStatus,jqXHR){
			menu_show_admin();
			mydiv.innerHTML = data;
		},
		error: function(jqXHR,textStatus,errorThrown){},
		beforeSend: function(jqXHR,settings){ newMESG("Save System Date"); },
		complete: function(jqXHR,textStatus,errorThrown){ delMESG("Save System Date"); },
	});
	
}

function save_admin_web () {
	var pawo1 = $('#pawo1web').val();
	var pawo2 = $('#pawo2web').val();
	if (pawo1 == pawo2) {
		var D = $.ajax({ url: 'admin/admin.cgi', data: 'pawo_web='+'web:'+CryptoJS.SHA3(pawo1), method: 'POST',
			success: function(data,textStatus,jqXHR){
				document.getElementById("main").innerHTML = "Web password changed.";
			},
			error: function(jqXHR,textStatus,errorThrown){},
			beforeSend: function(jqXHR,settings){ newMESG("Save Web Password"); },
			complete: function(jqXHR,textStatus,errorThrown){ delMESG("Save Web Password"); },
		});
	} else {
		document.getElementById("main").innerHTML += "<br/>different web passwords";
	}
}

function save_admin_sys () {
	var pawo0 = $('#pawo0sys').val();
	var pawo1 = $('#pawo1sys').val();
	var pawo2 = $('#pawo2sys').val();
	if (pawo1 == pawo2) {
		/* 1. confirm sys pawo: usersys=pawo0_clear */
		var D0 = $.ajax({ url: 'admin/admin.cgi', data: 'user_sys='+pawo0, method: 'POST',
			success: function(data,textStatus,jqXHR){
				if (data == "OK") {
					/* 2. save sys pawo: pawo_sys=pawo1_clear */
					var D1 = $.ajax({ url: 'admin/admin.cgi', data: 'pawo_sys='+pawo1, method: 'POST',
						success: function(data,textStatus,jqXHR){
							document.getElementById("main").innerHTML = "System password changed.";
						},
						error: function(jqXHR,textStatus,errorThrown){},
					});
				} else {
					document.getElementById("main").innerHTML += "<br/>wrong sys passwords";
				}
			},
			error: function(jqXHR,textStatus,errorThrown){},
			beforeSend: function(jqXHR,settings){ newMESG("Save System Password"); },
			complete: function(jqXHR,textStatus,errorThrown){ delMESG("Save System Password"); },
		});
	} else {
		document.getElementById("main").innerHTML += "<br/>different sys passwords";
	}
}
/* SAVE */

/*################################################################################*/
/* ADMIN MENU SHOWs */
function menu_show_admin () {
	hide_login(1);
	var D = $.ajax({ url: 'admin/admin.cgi', data: 'admin=show', method: 'POST',
		success: function(data,textStatus,jqXHR){
			var mydiv = document.getElementById("main");
			mydiv.innerHTML  = data;
		},
		error: function(jqXHR,textStatus,errorThrown){},
		beforeSend: function(jqXHR,settings){ newMESG("Show Admin"); },
		complete: function(jqXHR,textStatus,errorThrown){ delMESG("Show Admin"); },
	});
}
/* ADMIN MENU SHOWs */

/*################################################################################*/

