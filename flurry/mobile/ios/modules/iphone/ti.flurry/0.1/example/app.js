// This is a test harness for your module
// You should do something interesting in this harness 
// to test out the module and to provide instructions 
// to users on how to use it by example.


// open a single window
var window = Ti.UI.createWindow({
  backgroundColor:'white'
});
window.open();

Titanium.Flurry = require('ti.flurry');
//set the second param to true to use geolocation, set to false to not use geolocation
Titanium.Flurry.initialize('<<<YOUR API KEY>>>',true);
Titanium.Flurry.reportOnClose(true);

var button = Ti.UI.createButton({
	title:'Fire event',
	width:200,
	height:40
});
var count = 0;
button.addEventListener('click', function() {
	//this will log an event against Flurry
	Titanium.Flurry.logEvent('click', {
		clickCount:++count
	});
});
window.add(button);

