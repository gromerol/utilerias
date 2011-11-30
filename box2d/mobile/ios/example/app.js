var window = Ti.UI.createWindow();
var view = Ti.UI.createView();
window.add(view);
window.open();

// load the module
var Box2D = require('ti.box2d');

// create the world, using view as the surface
var world = Box2D.createWorld(view);

// create a block 
var redBlock = Ti.UI.createView({
	backgroundColor: "red",
	width: 50,
	height: 50,
	top: 0
});

var blueBall = Ti.UI.createView({
	backgroundColor: "blue",
	borderRadius: 15,
	width: 30,
	height: 30,
	top: 100
});

// add the block body to the world
var redBodyRef = world.addBody(redBlock, {
	density: 12.0,
	friction: 0.3,
	restitution: 0.4,
	type: "dynamic"
});

// add the ball body to the world
var blueBodyRef = world.addBody(blueBall, {
	radius: 15,
	density: 12.0,
	friction: 0.3,
	restitution: 0.4,
	type: "dynamic"
});

Ti.Gesture.addEventListener('orientationchange', function(e) {
	if (e.orientation == Titanium.UI.LANDSCAPE_LEFT) {
		world.setGravity(9.91, 0);
	} else if (e.orientation == Titanium.UI.LANDSCAPE_RIGHT) {
		world.setGravity(-9.91, 0);
	} else if (e.orientation == Titanium.UI.UPSIDE_PORTRAIT) {
		world.setGravity(0, 9.91);
	} else if (e.orientation == Titanium.UI.PORTRAIT) {
		world.setGravity(0, -9.91);
	}
});

world.addEventListener("collision", function(e) {
	if ((e.a == redBodyRef || e.b == redBodyRef) && e.phase == "begin") {
		Ti.API.info("the red block collided with something");

		Ti.API.info(JSON.stringify(e));
		Ti.Media.vibrate();
	}
});

// start the world
world.start();
