# box2d world object

## Description

The wold object is your "game board" or sorts, it's where all the Box2D stuff like gravity exists, and its where things like "bodies" and joints exist.

As a note, the world by default has no "walls" so objects will keep falling till they go off the screen (but note these elements will still exist in memory)

## Methods

### setGravity

This method takes 2 arguments, both floats. This sets the gravity for the world. The first argument sets the value of gravity along the x axis, the second along the y axis.

for example:

    world.setGravity(0, -9.91);

Would be a normal "earth like" gravity for a device in portrait mode. Where as:

    world.setGravity(9.91, 0);

Would be a device set to LANDSCAPE_LEFT.

### addBody

This method takes two arguments, the first a reference to a  view that is to be added to the world, the second a dictionary with the following properties:

* density (float)
* friction (float)
* restitution (float)
* type (Use the "constants" defined in the index of these docs)

The documentation for how these properties work can be found in the Box2D library documentation.

This method returns a [body proxy][]

### destroyBody

This method takes one argument, a [body proxy][]

This method removes the body from the world and destroys the body and view from memory.

### createJoint

This method takes three arguments, the first two are references to the bodies that are to be joined, the third a dictionary with the following available properties:

* enableLimit (bool)
* upperAngle (float)
* lowerAngle (float)
* enableMotor (bool)
* maxMotorTorque (int)
* motorSpeed (int)
* jointPoint (float)
* basePoint (float)
* collideConnected (bool)
* type (Use the "constants" defined in the index of these docs)


The documentation for how these properties work can be found in the Box2D library documentation.

This method returns a [revJoint proxy][] currently, but will be able to return other joint types soon.