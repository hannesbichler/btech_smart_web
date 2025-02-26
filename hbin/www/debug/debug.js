/*################################################################################*/
/* VARIABLES */
/* VARIABLES */
/*################################################################################*/

/*################################################################################*/
/* LOGIN */
function login_debug () {
	var mydiv = document.getElementById("main");
	$("option.debug_options").removeAttr("disabled");
	$("input.debug_checks").removeAttr("disabled");
	$("input.debug_inputs").removeAttr("readonly");
	$("input.debug_inputs").css({"background-color":"white"});
	$("input.debug_buttons").remove();
	mydiv.innerHTML += '<input type="button" name="" value="Save" class="debug_buttons" onclick="javascript:save_debug();"/>';
	mydiv.innerHTML += '<input type="button" name="" value="Back" class="debug_buttons" onclick="javascript:menu_show_debug();"/>';
}
/* LOGIN */

/*################################################################################*/
/* SAVE */
function save_debug () {
	var D = $.ajax({ url: 'debug/debug.cgi', data: $('#debug_form').serialize(), method: 'POST',
		success: function(data,textStatus,jqXHR){
			menu_show_debug();
		},
		error: function(jqXHR,textStatus,errorThrown){},
		beforeSend: function(jqXHR,settings){ newMESG("Save Debug"); },
		complete: function(jqXHR,textStatus,errorThrown){ delMESG("Save Debug"); },
	});
}
/* SAVE */

/*################################################################################*/
/* DEBUG MENU SHOWs */
function menu_show_debug () {
	hide_login(1);
	var D = $.ajax({ url: 'debug/debug.cgi', data: 'debug=show', method: 'POST',
		success: function(data,textStatus,jqXHR){
			var mydiv = document.getElementById("main");
			mydiv.innerHTML  = data;
		},
		error: function(jqXHR,textStatus,errorThrown){},
		beforeSend: function(jqXHR,settings){ newMESG("Show Debug"); },
		complete: function(jqXHR,textStatus,errorThrown){ delMESG("Show Debug"); },
	});
}
/* DEBUG MENU SHOWs */

/*################################################################################*/
