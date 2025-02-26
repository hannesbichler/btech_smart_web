/*################################################################################*/
/* VARIABLES */
/* VARIABLES */
/*################################################################################*/

/*################################################################################*/
/* LOGIN */
function login_config () {
	var mydiv = document.getElementById("main");
	$("input.config_inputs").removeAttr("readonly");
	$("input.config_inputs").css({"background-color":"white"});
	$("input.config_checks").removeAttr("disabled");
	$("label.config_labels").removeAttr("onclick");
	$("input.config_buttons").remove();
	mydiv.innerHTML += '<input type="button" name="" value="Save+Boot" class="config_buttons" onclick="javascript:save_config();"/>';
	//mydiv.innerHTML += '<input type="button" name="" value="Boot" class="config_buttons" onclick="javascript:sys_reboot();"/>';
	mydiv.innerHTML += '<input type="button" name="" value="Back" class="config_buttons" onclick="javascript:menu_show_config();"/>';
}
/* LOGIN */

/*################################################################################*/
/* SAVE */
function save_config () {
	hide_login(0);
	var D = $.ajax({ url: 'config/config.cgi', data: $('#config_form').serialize(), method: 'POST',
		success: function(data,textStatus,jqXHR){
			bootWait(data);
		},
		error: function(jqXHR,textStatus,errorThrown){},
		beforeSend: function(jqXHR,settings){ newMESG("Save Config and Reboot"); },
		complete: function(jqXHR,textStatus,errorThrown){ delMESG("Save Config and Reboot"); },
	});
}

/* SAVE */

/*################################################################################*/
/* MENU SHOWs */
function menu_show_config () {
	hide_login(1);
/*	menu: farbe aendern, wenn ausgewaehlt */
/*	document.getElementById("m_combox").style.backgroundColor = "#228c8b";
	document.getElementById("m_combox").style.color = "#363636";*/
	var D = $.ajax({ url: 'config/config.cgi', data: 'config=show', method: 'POST',
		success: function(data,textStatus,jqXHR){
			var mydiv = document.getElementById("main");
			mydiv.innerHTML  = data;
		},
		error: function(jqXHR,textStatus,errorThrown){},
		beforeSend: function(jqXHR,settings){ newMESG("Show Config"); },
		complete: function(jqXHR,textStatus,errorThrown){ delMESG("Show Config"); },
	});
}
/* MENU SHOWs */

/*################################################################################*/
