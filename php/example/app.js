// This is a test harness for your module
// You should do something interesting in this harness 
// to test out the module and to provide instructions 
// to users on how to use it by example.


// open a single window
var window = Ti.UI.createWindow({
	backgroundColor:'white'
});
var label = Ti.UI.createLabel();
window.add(label);
window.open();

// TODO: write your module tests here
var tiphp = require('ti.php');
Ti.API.info("module is => " + tiphp);

var getKeys = function(obj){
   var keys = [];
   for(var key in obj){
      keys.push(key);
   }
   return keys;
}

keys = getKeys(tiphp);

Ti.API.info(tiphp.test);

tiphp.addslashes('test');

Ti.API.info("module exampleProp is => " + tiphp.exampleProp);
tiphp.exampleProp = "This is a test value";

if (Ti.Platform.name == "android") {
	var proxy = tiphp.createExample({message: "Creating an example Proxy"});
	proxy.printMessage("Hello world!");
}