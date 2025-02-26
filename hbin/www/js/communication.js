var connection = new WebSocket('ws://172.17.0.200:7681', 'home-control');
connection.onmessage = function (e) {
	myd = JSON.parse(e.data);
	// alert(myd.value);
	document.getElementById(myd.id).checked = myd.value;
};

function sendCheckboxToServer(check) {
	
	// When the connection is not open, create new websocket connection
	if (typeof connection === 'undefined' || !connection)
		connection = new WebSocket('ws://172.17.0.200:7681', 'home-control');
	
	// send some data to the server	
	connection.send("cmd:" + check.id + "=" + check.checked); // Send the message 'Ping' to the server

	// Log errors
	connection.onerror = function (error) {
	  console.log('WebSocket Error ' + error);
	};

	// Log messages from the server
	connection.onmessage = function (e) {
		myd = JSON.parse(e.data);
		// alert(myd.value);
	  document.getElementById(myd.id).checked = myd.value;
	};
}

function sendButtonToServer(button, value) {
	
	// When the connection is not open, create new websocket connection
	if (typeof connection === 'undefined' || !connection)
		connection = new WebSocket('ws://172.17.0.200:7681', 'home-control');
	
	// send some data to the server	
	connection.send("cmd:" + button.id + "=" + value); // Send the message 'Ping' to the server
	  
	// Log errors
	connection.onerror = function (error) {
	  console.log('WebSocket Error ' + error);
	};

	// Log messages from the server
	connection.onmessage = function (e) {
		myd = JSON.parse(e.data);
		// alert(myd.value);
	  document.getElementById(myd.id).checked = myd.value;
	};
}

function sendTagsToServer(tag, value) {
	if (typeof connection === 'undefined' || !connection)
		connection = new WebSocket('ws://172.17.0.200:7681', 'home-control');
	
	// When the connection is open, send some data to the server
	for (i = 0; i < tag.length; i++) { 
	  connection.send("cmd:" + tag[i] + "=" + value[i]); // Send the message 'Ping' to the server
	
	// Log errors
	connection.onerror = function (error) {
	  console.log('WebSocket Error ' + error);
	}
	};

	// Log messages from the server
	connection.onmessage = function (e) {
		myd = JSON.parse(e.data);
		// alert(myd.value);
	  document.getElementById(myd.id).checked = myd.value;
	};
}