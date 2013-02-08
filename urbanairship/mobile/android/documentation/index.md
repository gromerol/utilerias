# urbanairship Module

## Description

This module allows the Urban Airship Android library to be used inside of Titanium. Push Notifications are supported.

## Warning when Updating to Urban Airship v2.3.0

With the 2.3.0 update to the Urban Airship Module, several breaking changes have been made. When upgrading to 2.3.0, you will need to consider the following:

- BREAKING CHANGE: Google has discontinued support for C2DM, and is no longer processing either new applications for that service, or 
requests for a quota extension.  Per Google's advice, Urban Airship is deprecating C2DM and asks that all customers migrate to GCM at this time.
- BREAKING CHANGE: The c2dmId property has been removed from the module. The pushId property should be used instead.
- BREAKING CHANGE: Versions of this module prior to 1.3 provided an 'options' property and a 'takeOff' function for specifying the options and initializing the push library. These have been removed in order to more closely match the functionality of the Urban Airship Android Push Library. Please see the 'Setup' section below for further details on initializing your application for push notifications.

## Message "An application restart is required" fires incorrectly

When clicking on a notification that activates your application, a "Restart Required" alert with the message "An application restart is required" may fire incorrectly.
This is a known issue ([TIMOB-9285](https://jira.appcelerator.org/browse/TIMOB-9285)) that can be resolved in your application by adding the following property to `tiapp.xml`:
<pre><code>
        &lt;property name="ti.android.bug2373.finishfalseroot" type="bool"&gt;true&lt;/property&gt;
</code></pre>

Make sure that the `tiapp.xml` file doesn't include any other `ti.android.bug2373` properties.

## Getting Started

View the [Using Titanium Modules](http://docs.appcelerator.com/titanium/latest/#!/guide/Using_Titanium_Modules) document for instructions on getting
started with using this module in your application.

## Accessing the urbanairship Module

To access this module from JavaScript, you would do the following:

	var urbanairship = require("ti.urbanairship");

The urbanairship variable is a reference to the Module object.	

## Urban Airship Docs

* [Urban Airship Documentation](https://docs.urbanairship.com)

## Setup

Follow these steps to properly setup your Titanium Android application to use Urban Airship push notifications.

### Step 1: Setting App Credentials

Urban Airship is initialized automatically when your Titanium application starts. However you still need to specify your app's credentials before it can interact with an application you've created on the [Urban Airship dashboard](https://go.urbanairship.com). Urban Airship looks for these in a file called <strong>airshipconfig.properties</strong>, in the assets folder of your Android project directory.

* A sample airshipconfig.properties file has been provided in the module's example folder (example/platform/android/bin/assets/airshipconfig.properties).
* Copy the sample 'platform' folder to your application's project folder. For example, if your application folder is 'TestApp' then the resulting path should be 'TestApp/platform/android/bin/assets/airshipconfig.properties'. This will ensure that your airshipconfig.properties file is properly copied into the assets folder of your Android application package when it is built.
* Update the airshipconfig.properties file with your app's key and secret, whether the app is currently in development or production, and which transport your want to use.
* See the [Urban Airship Documentation](http://docs.urbanairship.com) for additional properties that can be set in this file.

### Step 2: Enable push notifications

Enabling or disabling push notifications is a preference often best left up to the user, so by default, push is disabled in the module. 

* Use the '<strong>pushEnabled</strong>' property to enable or disable push notifications.

### Step 3: Set additional options

Several additional options can be controlled in your application code.

* If you wish for your application to come forward (in case it's in the background) when a user clicks (taps) an Urban Airship notification, you should set the urbanairship.showAppOnClick property to 'true'.
* See the list of properties below for other module options that can be set in your application

### Step 4: Register event listeners

Events are generated when application registration is complete and when a new message is received or clicked in the notification window.

* If you want to receive notifications when new messages are received or clicked, then register for the urbanairship.EVENT_URBAN_AIRSHIP_CALLBACK event (see below)
* If you want to receive notifications when the application has successfully registered with Urban Airship, then register for the urbanairship.EVENT_URBAN_AIRSHIP_SUCCESS event (see below)

### Step 5: GCM Configuration

Please read the [Getting Started with GCM][gcm] documentation for additional information regarding using the GCM transport.

## Functions

## Events

### urbanairship.EVENT_URBAN_AIRSHIP_SUCCESS
Called upon successful registration with Urban Airship.

* The event object contains the following fields:
    * deviceToken[string]: The application ID
    * valid[bool]: Indicates if the application registration was successful

### urbanairship.EVENT_URBAN_AIRSHIP_ERROR
Called upon failure to register with Urban Airship.

* The event object contains the following fields:
    * deviceToken[string]: The application ID
    * valid[bool]: Indicates if the application registration was successful
    * error[string]: Error message

### urbanairship.EVENT_URBAN_AIRSHIP_CALLBACK
Called when a new push is received OR the user clicks the Android notification 

* The event object contains the following fields: 
    * message[string]: The message. 
    * payload[string]: The payload of the push message as a JSON string. 
    * clicked[bool]: Whether the event is the result of a notification click or not. 

<strong>Note:</strong>If you press the 'Back' hardware button or perform any other operation that causes the activity in which the module is loaded to be destroyed, your event listener will not be called if new notification messages are received. However, if you have set the urbanairship.showAppOnClick property to 'true' then the main activity will be re-launched when the user clicks on the Android notification. A notification for the message that was clicked will be processed when the activity registers for the urbanairship.EVENT_URBAN_AIRSHIP_CALLBACK event notification.

## Properties

### pushEnabled[boolean] (default: false)
Enables/disables push notifications.
NOTE: When push notifications are enabled there may be a delay before the urbanairship.EVENT_URBAN_AIRSHIP_SUCCESS event is raised due to the latency in communicating with the server.

### soundEnabled[boolean]
Enables/disables sound

### vibrateEnabled[boolean]
Enables/disables vibration

### isFlying[boolean]
Tests if Urban Airship has been initialized and is ready for use

### showOnAppClick[boolean]
Indicates if your application should come forward when a user clicks (taps) an Urban Airship notification.
(Default is 'false' if you don't set this property).

### tags[string[]]
Tags can be used to categorize devices, and you can push notifications to devices with particular tags.
WARNING: only call this after the module isFlying, or the call won't do anything.

### alias[string]
Aliases are associated with device tokens, providing an alternate name.
WARNING: only call this after the module isFlying, or the call won't do anything.

### pushId[string]
The device's associated APID

## Usage
- See example

## Author

Jeff English

## Module History

View the [change log](changelog.html) for this module.

## Feedback and Support

Please direct all questions, feedback, and concerns to [info@appcelerator.com](mailto:info@appcelerator.com?subject=Android%20%UrbanAirship20Module).

## License

Copyright(c) 2010-2013 by Appcelerator, Inc. All Rights Reserved. Please see the LICENSE file included in the distribution for further details.

[gcm]: gcm.html

