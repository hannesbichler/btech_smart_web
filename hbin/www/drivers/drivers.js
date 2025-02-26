/*################################################################################*/
/* VARIABLES */
/* VARIABLES */
/*################################################################################*/

/*################################################################################*/
/* SAVE */
function save_driver_com (drivername) {
	console.log( $( this ).serializeArray() );
	var D = $.ajax({ url: 'drivers/drivers.cgi', data: $('#driver_form').serialize(), method: 'POST',
		success: function(data,textStatus,jqXHR){
			menu_show_driver(drivername);
		},
		error: function(jqXHR,textStatus,errorThrown){},
		beforeSend: function(jqXHR,settings){ newMESG("Save Driver and Restart OPC"); },
		complete: function(jqXHR,textStatus,errorThrown){ delMESG("Save Driver and Restart OPC"); },
	});
}
/* SAVE */

/*################################################################################*/
/* DRIVERS MENU SHOWs (onLoaD in index.html) */
function auto_drivernames () {
	var D = $.ajax({ url: 'drivers/drivers.cgi', data: 'drivers=menu', method: 'POST',
		success: function(data,textStatus,jqXHR){
			var mydiv = document.getElementById("drivers");
			mydiv.innerHTML  = data;
		},
		error: function(jqXHR,textStatus,errorThrown){},
		beforeSend: function(jqXHR,settings){ newMESG("List Driver Names"); },
		complete: function(jqXHR,textStatus,errorThrown){ delMESG("List Driver Names"); },
	});
}

/*################################################################################*/
/* menu_show_drivers () */
function menu_show_drivers () {
	hide_login(1);
	var D = $.ajax({ url: 'drivers/drivers.cgi', data: 'drivers=show', method: 'POST',
		success: function(data,textStatus,jqXHR){
			var mydiv = document.getElementById("main");
			mydiv.innerHTML  = data;
		},
		error: function(jqXHR,textStatus,errorThrown){},
		beforeSend: function(jqXHR,settings){ newMESG("Show Drivers"); },
		complete: function(jqXHR,textStatus,errorThrown){ delMESG("Show Drivers"); },
	});
}

/*################################################################################*/
/* menu_show_driver (drvname) */
function menu_show_driver (drvname) {
	hide_login(1);
	var mydiv = document.getElementById("main");
	
	// /.../runtime/drivers/ < DRVTYPE > /drv.info+drv.sh einbinden
	var D = $.ajax({ url: 'drivers/drivers.cgi', data: 'driver='+drvname, method: 'POST',
		success: function(data,textStatus,jqXHR){
			mydiv.innerHTML += data;
		},
		error: function(jqXHR,textStatus,errorThrown){},
		beforeSend: function(jqXHR,settings){ newMESG("Insert drv.info and drv.sh"); },
		complete: function(jqXHR,textStatus,errorThrown){ delMESG("Insert drv.info and drv.sh"); },
	});
	// /.../runtime/drivers/ < DRVTYPE > /drv.info+drv.sh einbinden
	
	// /.../runtime/drivers/ < DRVTYPE > /drv.js einbinden
	var D = $.ajax({ url: 'drivers/drivers.cgi', data: 'driverscript='+drvname, method: 'POST',
		success: function(data,textStatus,jqXHR){
			var neuesScript = document.createElement("script");
			neuesScript.type = "text/javascript";
			neuesScript.innerHTML = data;
			mydiv.appendChild(neuesScript);
		},
		error: function(jqXHR,textStatus,errorThrown){},
		beforeSend: function(jqXHR,settings){ newMESG("Insert drv.js"); },
		complete: function(jqXHR,textStatus,errorThrown){ delMESG("Insert drv.js"); },
	});
	// /.../runtime/drivers/ < DRVTYPE > /drv.js einbinden
	
	// /hbs/comet/opc_ua_server/servers/HBSServer/drivers/ < DRVNAME > /csv anzeigen
	var D = $.ajax({ url: 'csv/csv.cgi', data: 'csv_files_list='+drvname, method: 'POST',
		success: function(data,textStatus,jqXHR){
			mydiv.innerHTML += data;
		},
		error: function(jqXHR,textStatus,errorThrown){},
		beforeSend: function(jqXHR,settings){ newMESG("Show CSV files"); },
		complete: function(jqXHR,textStatus,errorThrown){ delMESG("Show CSV files"); },
	});
	// /hbs/comet/opc_ua_server/servers/HBSServer/drivers/ < DRVNAME > /csv anzeigen
}
/* DRIVERS MENU SHOWs */

/*################################################################################*/
