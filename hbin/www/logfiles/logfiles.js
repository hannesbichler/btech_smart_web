/*################################################################################*/
/* VARIABLES */
/* VARIABLES */

/*################################################################################*/
/* LOG FILES */
function empty_log_file (logfile) {
	var D = $.ajax({ url: 'logfiles/logfiles.cgi', data: 'empty_logfile='+logfile, method: 'POST',
		success: function(data,textStatus,jqXHR){
			menu_show_logs();
		},
		error: function(jqXHR,textStatus,errorThrown){},
		beforeSend: function(jqXHR,settings){ newMESG("Empty Logfile"); },
		complete: function(jqXHR,textStatus,errorThrown){ delMESG("Empty Logfile"); },
	});
}

function prepare_log_file (logfile) {
	var D = $.ajax({ url: 'logfiles/logfiles.cgi', data: 'logfile='+logfile, method: 'POST',
		success: function(data,textStatus,jqXHR){
			$("a.a_"+data).attr('href','/log/'+logfile+'.gz');
			$("a.a_"+data)[0].click();
			menu_show_logs();
		},
		error: function(jqXHR,textStatus,errorThrown){},
		beforeSend: function(jqXHR,settings){ newMESG("Prepare Logfile for Download"); },
		complete: function(jqXHR,textStatus,errorThrown){ delMESG("Prepare Logfile for Download"); },
	});
}
/* LOG FILES */

/*################################################################################*/
/* LOG FILES MENU SHOWs */
function menu_show_logs () {
	hide_login(1);
	var D = $.ajax({ url: 'logfiles/logfiles.cgi', data: 'logfiles=show', method: 'POST',
		success: function(data,textStatus,jqXHR){
			var mydiv = document.getElementById("main");
			mydiv.innerHTML  = data;
		},
		error: function(jqXHR,textStatus,errorThrown){},
		beforeSend: function(jqXHR,settings){ newMESG("Show Logfiles"); },
		complete: function(jqXHR,textStatus,errorThrown){ delMESG("Show Logfiles"); },
	});
}
/* LOG FILES MENU SHOWs */

/*################################################################################*/
