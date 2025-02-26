/*################################################################################*/
/* VARIABLES */
/* VARIABLES */
/*################################################################################*/

/*################################################################################*/
/* LOGIN */
function login_csv_files () {
	var mydiv = document.getElementById("main");
	// options
	$("input.csv_files_options").removeAttr("disabled");
	// buttons
	$("input.csv_files_buttons").remove();
	$("input.csv_files_buttons_hidden").show();
}
/* LOGIN */

/*################################################################################*/
/* SHOW FILES */
function csv_files_convert (drvname) {
	hide_login(0);
	var mydiv = document.getElementById("stat");
	var F = $( 'input:checkbox[name="cb_files_checkbox_name[]"]:checked' ).toArray();
	if (F.length > 0) {
		//var S = "";
		//for (var i=0; i<F.length; i++) { S += F[i].value+" "; }
		//S=S.substr(0,S.length-1);
		var S = drvname;
		for (var i=0; i<F.length; i++) { S += " "+F[i].value; }
		var D = $.ajax({ url: 'csv/csv.cgi', data: 'csv_files_convert='+S, method: 'POST',
			success: function(data,textStatus,jqXHR){
				mydiv.innerHTML += "Convert "+S+" ... ";
				mydiv.innerHTML += "Ready.<br/>";
				mydiv.innerHTML += data+"";
				menu_show_driver(drvname);
			},
			error: function(jqXHR,textStatus,errorThrown){
				mydiv.innerHTML += "status: "+textStatus+" error: "+errorThrown+"<br/>";
			},
			beforeSend: function(jqXHR,settings){ newMESG("Convert CSV file(s)"); },
			complete: function(jqXHR,textStatus,errorThrown){ delMESG("Convert CSV file(s)"); },
		});
	} else {
		mydiv.innerHTML += "no file(s) selected<br/>"
	}
}

function csv_files_upload (drvname,files) {
	hide_login(0);
	var mydiv = document.getElementById("stat");
	var formData = new FormData();
	formData.append(drvname,'DRIVERNAME');
	for (var i = 0, f; f = files[i]; i++) {
		//formData.append(f.name,f);
		formData.append('CSV-FILE',f,f.name);
		mydiv.innerHTML += f.name+" ";
	}
	mydiv.innerHTML += "... ";
	var xhr = new XMLHttpRequest();
	xhr.onreadystatechange = function() {
    	if(xhr.status==200 && xhr.readyState==4) {
    	    mydiv.innerHTML += xhr.responseText+"";
    	}
	}
	xhr.open("POST","csv/ful.cgi",false);
	xhr.setRequestHeader("Content-Type","multipart/form-data");
	xhr.send(formData);
	mydiv.innerHTML += "Ready.<br/>";
	menu_show_driver(drvname);
}

function csv_files_delete (drvname) {
	hide_login(0);
	var mydiv = document.getElementById("stat");
	var F = $( 'input:checkbox[name="cb_files_checkbox_name[]"]:checked' ).toArray();
	if (F.length > 0) {
		var S = "";
		for (var i=0; i<F.length; i++) { S += F[i].value+" "; }
		S=S.substr(0,S.length-1);
		var D = $.ajax({ url: 'csv/csv.cgi', data: 'csv_files_delete='+S, method: 'POST',
			success: function(data,textStatus,jqXHR){
				mydiv.innerHTML += "Delete "+S+" ... ";
				mydiv.innerHTML += "Ready.<br/>";
				mydiv.innerHTML += data+"";
				menu_show_driver(drvname);
			},
			error: function(jqXHR,textStatus,errorThrown){
				mydiv.innerHTML += "status: "+textStatus+" error: "+errorThrown+"<br/>";
			},
			beforeSend: function(jqXHR,settings){ newMESG("Delete CSV file(s)"); },
			complete: function(jqXHR,textStatus,errorThrown){ delMESG("Delete CSV file(s)"); },
		});
	} else {
		mydiv.innerHTML += "no file(s) selected<br/>"
	}
}

function csv_file_show (file) {
	hide_login(1);
	var D = $.ajax({ url: 'csv/csv.cgi', data: 'csv_file_show='+file, method: 'POST',
		success: function(data,textStatus,jqXHR){
			var mydiv = document.getElementById("main");
			mydiv.innerHTML  = data;
		},
		error: function(jqXHR,textStatus,errorThrown){},
		beforeSend: function(jqXHR,settings){ newMESG("Show CSV file"); },
		complete: function(jqXHR,textStatus,errorThrown){ delMESG("Show CSV file"); },
	});
}
/* SHOW FILES */

/*################################################################################*/
