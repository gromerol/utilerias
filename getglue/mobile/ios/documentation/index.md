# ti.getglue Module

## Description

This module uses the GetGlue checkin widget to provide Titanium apps with the ability to checkin to media "events"

## Getting Started

View the [Using Titanium Modules](http://docs.appcelerator.com/titanium/latest/#!/guide/Using_Titanium_Modules) document for instructions on getting
started with using this module in your application.

## Accessing the ti.getglue Module

To access this module from JavaScript, you would do the following:

	var GetGlue = require('ti.getglue');

The getglue variable is a reference to the Module object.	

### GetGlue.createView({...})

Creates and returns a [Ti.getglue.View][] object which displays the getglue widget. 

When the widget is clicked, it opens a window that lets the user login to getglue and checkin to the event specified in the createView method.

## Usage

	var window = Ti.UI.createWindow({
	    backgroundColor:'white'
	});
	
	var GetGlue = require('ti.getglue');
	
	var widget = GetGlue.createView({
	    source: 'test app',
	    objectKey: 'movies/home_alone/chris_columbus',
	    top:30,
	    left:30,
	});
	 
	window.add(widget);
	
	window.open();


## Properties

### string source

The source of the checkin, a URL or user ID... setting this will act as a global source for all your widgets, each widget can override it with their own source property.

The default is an empty string.

## Author

Matt Apperson

## Module History

View the [change log](changelog.html) for this module.

## Feedback and Support

Please direct all questions, feedback, and concerns to [info@appcelerator.com](mailto:info@appcelerator.com?subject=iOS%20GetGlue%20Module).

## License

Copyright(c) 2010-2013 by Appcelerator, Inc. All Rights Reserved. Please see the LICENSE file included in the distribution for further details.

[Ti.getglue.View]: view.html