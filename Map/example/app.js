
// This is a test harness for your module
// You should do something interesting in this harness 
// to test out the module and to provide instructions 
// to users on how to use it by example.



// TODO: write your module tests here
var MapModule = require('ti.map');




var win = Ti.UI.createWindow();
var anno = MapModule.createAnnotation({latitude: -33.87365, longitude: 151.20689, title: "Sydney", subtitle: "Sydney is quite chill", draggable: true});
var anno2 = MapModule.createAnnotation({latitude: -33.86365, longitude: 151.21689, title: "Anno2", subtitle: "This is anno2", draggable: true});
var anno3 = MapModule.createAnnotation({latitude: -33.85365, longitude: 151.20689, title: "Anno3", subtitle: "This is anno3", draggable: false});
var anno4 = MapModule.createAnnotation({latitude: -33.86365, longitude: 151.22689, title: "Anno4", subtitle: "This is anno4", draggable: true});

var map = MapModule.createView({
	userLocation: true,
	animate: true,
	annotations: [anno, anno2, anno4],
	region: {latitude: -33.87365, longitude: 151.20689, latitudeDelta: 0.1, longitudeDelta: 0.1 }, //Sydney
	top: '30%'
});
win.add(map);

map.addEventListener('click', function(e) {
	Ti.API.info("Latitude: " + e.latitude);
	Ti.API.info("Source: " + e.clicksource);
});
var button = Ti.UI.createButton({top: 0, left: 0, title: "Go Mt. View"});
button.addEventListener('click', function(e) {
	map.region = {latitude: 37.3689, longitude: -122.0353, latitudeDelta: 0.1, longitudeDelta: 0.1 }; //Mountain View
});

var button2 = Ti.UI.createButton({top: 0, right: 0, title: "add anno3"});
button2.addEventListener('click', function(e) {
	map.addAnnotation(anno3);
});

var button3 = Ti.UI.createButton({top: 0, title: "rm anno3"});
button3.addEventListener('click', function(e) {
	map.removeAnnotation(anno3);
});

var button4 = Ti.UI.createButton({top: '10%', title: "rm all annos"});
button4.addEventListener('click', function(e) {
	map.removeAllAnnotations();
});

var button5 = Ti.UI.createButton({top: '10%', left: 0, title: "remove annos"});
button5.addEventListener('click', function(e) {
	Ti.API.info(anno.getTitle());
	map.removeAnnotations(["Sydney", anno2]);
});

var button6 = Ti.UI.createButton({top: '10%', right: 0, title: "select anno2"});
button6.addEventListener('click', function(e) {
	map.selectAnnotation(anno2);
});

var button7 = Ti.UI.createButton({top: '20%', left: 0, title: "deselect anno2"});
button7.addEventListener('click', function(e) {
	map.deselectAnnotation(anno2);
});

win.add(button);
win.add(button2);
win.add(button3);
win.add(button4);
win.add(button5);
win.add(button6);
win.add(button7);
win.open();




