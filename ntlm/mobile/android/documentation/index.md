# Ti.Ntlm Module

## Description

This module provides NTLM authentication on Android using JCIFS.

## Getting Started

View the [Using Titanium Modules](http://docs.appcelerator.com/titanium/latest/#!/guide/Using_Titanium_Modules) document for instructions on getting
started with using this module in your application.

## Accessing the Ntlm Module

To access this module from JavaScript, you would do the following:

	var Ntlm = require("ti.ntlm");

The Ntlm variable is a reference to the Module object.	

## Methods

### String Ntlm.getAuthScheme()
Returns "ntlm" as th authorization scheme. 

### Object Ntlm.getAuthFactory()
Returns an Auth Scheme Factory object.

## Example

	var url = "http://someserver";
	var client = Ti.Network.createHTTPClient({
		// function called when the response data is available
	    onload : function(e) {
	    	Ti.API.info("Received text: " + this.responseText);
	    },
	    // function called when an error occurs, including a timeout
	    onerror : function(e) {
	    	Ti.API.info(e.error);
	    },
	    timeout : 5000  // in milliseconds
	});<br/>
	<br/> 
	client.username = 'someusername';
	client.password = 'somepassword';
	client.domain = 'someDomain';
	
	//ANDROID SPECIFIC CODE STARTS.
	var jcifsntlm = require("com.jcifsntlm");
	client.addAuthFactory(Ntlm.getAuthScheme(),Ntlm.getAuthFactory());
	//ANDROID SPECIFIC CODE ENDS. 
	
	// Prepare the connection.
	client.open("GET", url);
	// Send the request.
	client.send();

## Usage
See the example applications in the `example` folder of the module.

## Author
Vishal Duggal

## Module History

View the [change log](changelog.html) for this module.

## Feedback and Support
Please direct all questions, feedback, and concerns to [info@appcelerator.com](mailto:info@appcelerator.com?subject=Android%20Ntlm%20Module).

## License
Copyright(c) 2013 by Appcelerator, Inc. All Rights Reserved. Please see the LICENSE file included in the distribution for further details.

