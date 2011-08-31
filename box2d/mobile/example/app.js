var window = Ti.UI.createWindow({
    backgroundColor:'white'
});
var view = Ti.UI.createView();
window.add(view);
window.open();

// load the module
var box2d = require("ti.box2d");

// create the world, using view as the surface
var world = box2d.createWorld(view);

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

        var gutter = Ti.UI.createView({
            backgroundColor:'black',
            width: 75,
            right: 75,
            height: 6,
            bottom: 80
        });
        
        var flipper = Ti.UI.createView({
            backgroundColor:'green',
            width: 70,
            right:75,
            height: 15,
            bottom: 62
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

        // add body to the world
        var gutterRef = world.addBody(gutter, {
            density: 10.0,
            friction: 0.3,
            restitution: 0.4,
            type: "static"
        });
        gutterRef.setAngle(0.25);
        
        // add body to the world
        var flipperRef = world.addBody(flipper, {
            density: 10.0,
            friction: 0.3,
            restitution: 0.8,
            type: "dynamic"
        });
        
        var flippermoter = world.createJoint(flipperRef, gutterRef, {
            enableMotor: true,
            maxMotorTorque: 20000,
            motorSpeed: 10,
            jointPoint: 1.4,
            basePoint: -1.8,
            collideConnected:false
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
