# flurry Module

## Description

Module for using the flurry event tracking service.

## Accessing the flurry Module

To access this module from JavaScript, you would do the following:

	var flurry = require("ti.flurry",true));

The flurry variable is a reference to the Module object.	

## Reference

## Functions

### initialize(apiKey,booleanForGeolocation)

Initializes your Flurry session.  Takes one argument, a string representing the api key.

### reportOnClose(report)

Flag to control whether or not Flurry reports events on close.  report is a boolean value.

### logEvent(event, props)

Logs an event specified by the 'event' string, with the properties 'props'.

## Usage

// open a single window
var window = Ti.UI.createWindow({<br>
  backgroundColor:'white'<br>
});<br>
window.open();<br>

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
