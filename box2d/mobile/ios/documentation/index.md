# box2d Module

## Description

This module uses the Box2D library to add physics to your iOS based Titanium games.

We strive to keep the API of this module as close as we can to the API of Box2D while making it simple for Titanium devs to work with.

This module is to be considered a beta, but as it is open source, we encourage all who can to contribute to it.

## Accessing the box2d Module

To access this module from JavaScript, you would do the following:

  var box2d = require("ti.box2d");

The box2d variable is a reference to the Module object.  

## Methods

### createWorld

This method takes no arguments, it returns a [world object][].


## Properties
### REV_JOINT (read only)
defines the joint type as a revJoint

### STATIC_BODY (read only)
defines the body type as static

### DYNAMIC_BODY (read only)
defines the body type as dynamic

### KINEMATIC_BODY (read only)
defines the body type as kinematic

[world object]: world.md