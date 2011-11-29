Appcelerator Titanium Box2D Module for iOS 
==========================================

This is a Box2D module for iOS originally developed by Jeff Haynie.

[Box2D](http://www.box2d.org/) is one of the most popular physics engines used for all sorts of 
cool things from popular games like Angry Birds to engineering simulations.


Basic usage:

~~~
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
  backgroundColor:"red",
  width:50,
  height:50,
  top:0
});

// add the block body to the world
var redBody = world.addBody(redBlock,{
  density:12.0,
  friction:0.3,
  restitution:0.4,
  type:"dynamic"
});

world.addEventListener("collision",function(e) {
  if ((e.a == redBody || e.b == redBody) && e.phase == "begin") {
    Ti.API.info("the redBody collided with something");
  }
});

// start the world
world.start();
~~~



TODO
===

Here is an outline of what needs to be done

* Joints - iPhone to Box2d coordinate system translation for the location of the joint as well as other layout and distance related properties. Also "constants" for joint types

* World - Sprites need to be added, and destroyJoint method needs to be added.

* Bodies - Distance, and time of impact methods. Fixed rotation property. Dampening property. Bullets property, Sensors property. 

* Polygons - creation of polygons should be done by passing an array of points as args for the shape property. 

* Debug drawing - This should be enabled with a property set such as box2d.debug = true;

LICENSE
=======
Apache Public License version 2


COPYRIGHT
=========
Copyright (c) 2011 by Jeff Haynie. All Rights Reserved.
