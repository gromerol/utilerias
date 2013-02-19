# Ti.Bump Module

## Description

A module supporting Bump(TM) functionality for your app.  This allows devices to
communicate when they are tapped together.

## Getting Started

View the [Using Titanium Modules](http://docs.appcelerator.com/titanium/latest/#!/guide/Using_Titanium_Modules) document for instructions on getting
started with using this module in your application.

## System Requirements

To use this module you must install it local to the application project. To install, copy the module zip file into your application folder.

## Accessing the Ti.Bump Module

To access this module from JavaScript, you would do the following:

	var Bump = require('ti.bump');

## Methods

### Ti.Bump.connect

Opens up the bump dialog, asking the user to bump two devices together.

#### Arguments

Takes one argument, a dictionary with keys:

* apikey[string]: Your API key; you can get this from http://bu.mp/apiagree
* username[string]: Your Bump(TM) username
* message[string]: The message to display while waiting for connections

Fires the event "ready" after the dialog shows up, and "connected" after connecting to another device.

### Ti.Bump.disconnect

Stop listening for connections.

### Ti.Bump.sendMessage

Sends a message via Bump(TM). Only utilize this after the "connected" event fires, and before the "disconnected" event fires.

#### Arguments

Takes one argument, a string. If the message fails to send, the "error" event fires.

## Events

### ready

Event indicating that Bump(TM) is ready for connections.

### error

Event indicating an error occurred.  Has one property, "message", which is the error message.

### connected

Event indicating that there is a connection to another device.  Has one property, "username", which
is the username of the other device.

### disconnected

Event indicating that the connection ended.  Has one property, "message", which is
one of:

* END_USER_QUIT: The user quit the service
* END_LOST_NET: The user's device lost network
* END_OTHER_USER_QUIT: The user on the other device quit the service
* END_USER_OTHER_LOST: The connection to the other user was lost

### error

Event indicating there was an error with the connection.  Has one property, "message",
which is one of:

* Not connected: Sent when a message send attempt is made before connect() is called.
* UNKNOWN: Unknown failure
* FAIL_NONE: No failure
* FAIL_NETWORK_UNAVAILABLE: No network connection
* FAIL_INVALID_AUTHORIZATION: The authorization tokens provided when connecting are invalid
* FAIL_EXCEEDED_RATE_LIMIT: Exceeded transfer limit
* FAIL_EXPIRED_KEY: The API key used to connect has expired
* FAIL_BAD_CONTACT: Improper contact was made.

### cancel

Event indicating the user cancelled the connection.  Has one property, "message",
which always has the value "FAIL_USER_CANCELED".

### data

A message was transmitted between devices over the connection.  Has one property,
"data", which is a blob of type "text/plain" that holds text.

## Usage

See example.js

## Author

Jeff Haynie

## Module History

View the [change log](changelog.html) for this module.

## Feedback and Support

Please direct all questions, feedback, and concerns to [info@appcelerator.com](mailto:info@appcelerator.com?subject=Android%20Bump%20Module).

## License

Copyright(c) 2010-2013 by Appcelerator, Inc. All Rights Reserved. Please see the LICENSE file included in the distribution for further details.
