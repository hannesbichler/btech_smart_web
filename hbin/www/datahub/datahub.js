/*################################################################################*/
/* VARIABLES */
/* VARIABLES */
/*################################################################################*/

/*################################################################################*/
/* NTPD */
function show_NTPD (id) {
	var D = $.ajax({ url: 'datahub/datahub.cgi', data: 'dataHUB=NTPD', method: 'POST', timeout: 10000,
		success: function(data,textStatus,jqXHR){document.getElementById(id).innerHTML = data;},
	});
}
/* NTPD */

/*################################################################################*/
/* CTRL */
function show_CTRL (id) {
	var D = $.ajax({ url: 'datahub/datahub.cgi', data: 'dataHUB=CTRL', method: 'POST',
		success: function(data,textStatus,jqXHR){document.getElementById(id).innerHTML = data;},
	});
}

function opcd (id,todo) {
	var D = $.ajax({ url: 'datahub/datahub.cgi', data: 'OPCD='+todo, method: 'POST',
		success: function(data,textStatus,jqXHR){menu_show_datahub();},
	});
}
/* CTRL */

/*################################################################################*/
/* INFO */
function show_INFO (id) {
	var D = $.ajax({ url: 'datahub/datahub.cgi', data: 'dataHUB=INFO', method: 'POST', timeout: 4500,
		success: function(data,textStatus,jqXHR){
			document.getElementById(id).innerHTML = data;
			document.getElementById('BrDtTm').innerHTML = new Date();
		},
	});
}
/* INFO */

/*################################################################################*/
/* BOOT */
function dataHUB_reboot () {
	if (confirm("Do you want to reboot the dataHUB ?")) {
		hide_login(0);
		var D = $.ajax({ url: 'datahub/datahub.cgi', data: 'dataHUB=ReBoot', method: 'POST',
			success: function(data,textStatus,jqXHR){
				var loc = window.location.hostname;
				if ( loc != data ) { data = loc; }
				// data is equal (new) ip-address-1
				bootWait(data);
			},
			error: function(jqXHR,textStatus,errorThrown){},
			beforeSend: function(jqXHR,settings){ newMESG("Reboot dataHUB"); },
			complete: function(jqXHR,textStatus,errorThrown){ delMESG("Reboot dataHUB"); },
		});
	} else {
		menu_show_datahub();
	}
}
/* BOOT */

/*################################################################################*/
/* DATAHUB MENU SHOWs */
function menu_show_datahub () {
	hide_login(1);
	var D = $.ajax({ url: 'datahub/datahub.cgi', data: 'datahub=show', method: 'POST',
		success: function(data,textStatus,jqXHR){
			var mydiv = document.getElementById("main");
			mydiv.innerHTML  = "<div>"+data+"</div>";
		},
		error: function(jqXHR,textStatus,errorThrown){},
		beforeSend: function(jqXHR,settings){ newMESG("Show dataHUB"); },
		complete: function(jqXHR,textStatus,errorThrown){ delMESG("Show dataHUB"); },
	});
	$('#CTRL').show();
	show_CTRL('CTRL');
	$('#INFO').show();
	show_INFO('INFO');
	INFOInterval = window.setInterval(function(){show_INFO('INFO');},5000);
	$('#NTPD').show();
	show_NTPD('NTPD');
	NTPDInterval = window.setInterval(function(){show_NTPD('NTPD');},12000);
}
/* DATAHUB MENU SHOWs */
/*################################################################################*/
