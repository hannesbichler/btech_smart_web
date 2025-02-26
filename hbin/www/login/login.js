/*################################################################################*/
/* VARIABLES */
/* VARIABLES */

/*################################################################################*/
/* LOGIN */
function show_login (toedit,event) {
	rm_loginTOP();
	var TOP = document.createElement('DIV');
		TOP.setAttribute('ID','loginTOP');
		TOP.style.position = 'absolute';
		TOP.style.left = event.clientX+'px';
		TOP.style.top = event.clientY+'px';
	document.getElementsByTagName('BODY')[0].appendChild(TOP);
	var mydiv = document.getElementById("loginTOP");
	mydiv.innerHTML  = '';
	mydiv.innerHTML += 'Edit '+toedit+'<br/>';
	mydiv.innerHTML += 'User: <input type="text" id="user" value="'+hold_web_user+'" placeholder="Username"/><br/>';
	mydiv.innerHTML += 'Pawo: <input type="password" id="pawo" value="'+hold_web_pawo+'" placeholder="Password"/><br/>';
	mydiv.innerHTML += '<input type="button" name="" value="Login" onclick="javascript:login_admin(\''+toedit+'\');"/>';
	mydiv.innerHTML += '<input type="button" name="" value="Close" onclick="javascript:rm_loginTOP();"/>';
}

function login_admin (toedit) {
	hold_web_user = $('#user').val();
	hold_web_pawo = $('#pawo').val();
	var user = $('#user').val();
	var pawo = CryptoJS.SHA3($('#pawo').val());
	rm_loginTOP();
	var D = $.ajax({ url: 'login/login.cgi', data: 'user_web='+user+':'+pawo, method: 'POST',
		success: function(data,textStatus,jqXHR){ check_login(toedit,data); },
		error: function(jqXHR,textStatus,errorThrown){},
		beforeSend: function(jqXHR,settings){ newMESG("Logging in"); },
		complete: function(jqXHR,textStatus,errorThrown){ delMESG("Logging in"); },
	});
}

function check_login (toedit, data) {
	if (data == "OK") {
		switch (toedit) {
		// CSV FILES
		case "csv_files":
			login_csv_files();
			break;
		// DRIVER COM
		case "driver_com":
			// function enable_driver_edit() steht in /.../runtime/.../drv.js
			enable_driver_edit();
			break;
		// CERTS MOVE
		case "certs_move":
			login_certs();
			break;
		// OPC RESTART
		case "OPC_restart":
			opcd('stat','restart');
			break;
		// OPC STOP
		case "OPC_stop":
			opcd('stat','stop');
			break;
		// DATAHUB REBOOT
		case "dataHUB_reboot":
			dataHUB_reboot();
			break;
		// CONFIG
		case "config":
			login_config();
			break;
		// DEBUG
		case "debug":
			login_debug();
			break;
		// ADMIN WEB
		case "admin_web":
			login_admin_web();
			break;
		// ADMIN SYS
		case "admin_sys":
			login_admin_sys();
			break;
		// ADMIN SYSDATE
		case "sysdate":
			login_admin_sysdate();
			break;
		// DEFAULT
		default:
			break;
		}
	} else {
		$('#div_login').text('Login Not OK.').show();
	}
}
/* LOGIN */

/*################################################################################*/

