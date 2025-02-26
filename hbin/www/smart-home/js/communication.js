var connection = new WebSocket('ws://10.0.0.35:7681', 'smart-hmi');
connection.onmessage = function (e) {
	myd = JSON.parse(e.data);
	// alert(myd.value);
	document.getElementById(myd.id).checked = myd.value;
};

function sendToServer(checked) {
	
	// When the connection is open, send some data to the server
	//connection.onopen = function () {
	  connection.send("checkbutton="+checked); // Send the message 'Ping' to the server
	//};
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