/*################################################################################*/
/* VARIABLES */
/* VARIABLES */

/*################################################################################*/
/* CERTIFICATES */
function login_certs () {
	var mydiv = document.getElementById("main");
	$("input.cb_certs_checkboxes_class").removeAttr("disabled");
	$("input.cb_certs_buttons_class").remove();
	mydiv.innerHTML += '<input type="button" name="" value="Save" class="cb_certs_buttons_class" onclick="javascript:move_certs();"/>';
	mydiv.innerHTML += '<input type="button" name="" value="Back" class="cb_certs_buttons_class" onclick="javascript:menu_show_certs();"/>';
}

function move_certs () {
	hide_login(0);
	var mydiv = document.getElementById("stat");
	var F = $('input[type="checkbox"][name="cb_certs_checkbox_name[]"]:checked').toArray();
	if (F.length > 0) {
		var S = "";
		for (var i=0; i<F.length; i++) { S += F[i].value+";"; }
		S=S.substr(0,S.length-1);
		var D = $.ajax({ url: 'certs/certs.cgi', data: 'movecerts='+S, method: 'POST', //async: false,
			success: function(data,textStatus,jqXHR){
				mydiv.innerHTML += "Ready.<br/>";
				mydiv.innerHTML += data+"";
				menu_show_certs();
			},
			error: function(jqXHR,textStatus,errorThrown){
				mydiv.innerHTML += "status: "+textStatus+" error: "+errorThrown+"<br/>";
			},
			beforeSend: function(jqXHR,settings){ newMESG("Move Certificates"); },
			complete: function(jqXHR,textStatus,errorThrown){ delMESG("Move Certificates"); },
		});
	} else {
		var D = $.ajax({ url: 'certs/certs.cgi', data: 'movecerts=', method: 'POST', //async: false,
			success: function(data,textStatus,jqXHR){
				mydiv.innerHTML += "Ready.<br/>";
				mydiv.innerHTML += data+"";
				menu_show_certs();
			},
			error: function(jqXHR,textStatus,errorThrown){
				mydiv.innerHTML += "status: "+textStatus+" error: "+errorThrown+"<br/>";
			},
			beforeSend: function(jqXHR,settings){ newMESG("Move all Certificates to rejected"); },
			complete: function(jqXHR,textStatus,errorThrown){ delMESG("Move all Certificates to rejected"); },
		});
	}
}

function menu_show_certs () {
	hide_login(1);
	var D = $.ajax({ url: 'certs/certs.cgi', data: 'certs=show', method: 'POST',
		success: function(data,textStatus,jqXHR){
			var mydiv = document.getElementById("main");
			mydiv.innerHTML  = data;
		},
		error: function(jqXHR,textStatus,errorThrown){},
		beforeSend: function(jqXHR,settings){ newMESG("Show Certs"); },
		complete: function(jqXHR,textStatus,errorThrown){ delMESG("Show Certs"); },
	});
}
/* CERTIFICATES */

/*################################################################################*/
