# custompopover Module

## Description

This module provides similar functionality as Ti.UI.iPad.popover, but allows the
application designer to provide custom graphics for the popover background.

## Accessing the custompopover Module

To access this module from JavaScript, you would do the following:

	var custompopover = require("ti.custompopover");

The custompopover variable is a reference to the Module object.	

## Methods

### createPopover

This method takes any arguments that Ti.UI.iPad.createPopover would take.

Because of how Apple exposes the functionality of customizing popovers, certain things
are hardwired until a more consistent way is discovered. As such, you may have to
modify the constants mentioned in the _initWithProperties: method in
TiCustompopoverPopoverProxy.m, lines 35 to 41.

10 images must be provided: 5 at standard resolution, 5 at retina display resolution, named
popoverBackground.png, popoverBackground@2x.png, popoverDownArrow.png,
popoverDownArrow@2x.png, popoverLeftArrow.png, popoverLeftArrow@2x.png
popoverRightArrow.png, popoverRightArrow@2x.png, popoverUpArrow.png
popoverUpArrow@2x.png. Both popoverBackground.png and popoverBackground@2x.png
are treated as stretchable images, stretching vertically and horizontally at the
middle.

ArrowOverlap specifies how much of the arrow graphics are superimposed on top of the
background graphic. The reason for the overlap is to allow for the arrow to change
the border of the background where the two merge. This is set to 10 device-independent
pixels on line 35 of TiCustompopoverPopoverProxy.m.

BorderMargins specifies how much of the background image appears outside the content area
This is set to 20 device-independent pixels in each direction on line 36 of
TiCustompopoverPopoverProxy.m

