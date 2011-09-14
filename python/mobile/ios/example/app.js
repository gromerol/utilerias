// This is a test harness for your module
// You should do something interesting in this harness 
// to test out the module and to provide instructions 
// to users on how to use it by example.


// open a single window
var window = Ti.UI.createWindow({
	backgroundColor:'white'
});
var label = Ti.UI.createLabel({
    text:'test'
});
window.add(label);
window.open();

// TODO: write your module tests here
var tipy = require('ti.python');
Ti.API.info("module is => " + tipy);

var minValue = tipy.builtins.min(677, 45, 99, 12, 200);
label.text = minValue;