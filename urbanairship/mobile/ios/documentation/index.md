# Ti.UrbanAirship Module

## Description

This Module allows the Urban Airship iOS library to used inside of Titanium. Push and Rich Push are supported.

## Getting Started

View the [Using Titanium Modules](http://docs.appcelerator.com/titanium/latest/#!/guide/Using_Titanium_Modules) document for instructions on getting
started with using this module in your application.

## Accessing the UrbanAirship Module

To access this module from JavaScript, you would do the following:

	var UrbanAirship = require('ti.urbanairship');

## Urban Airship Docs
<https://docs.urbanairship.com>

## Apple Push Docs
<http://developer.apple.com/library/ios/#documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/Introduction/Introduction.html>

## Breaking Changes

If you are upgrading from an earlier version of this module (prior to version 3.0.0) you should be
aware of the following breaking changes to the API:

* The deprecated `options` property has been removed. The `airshipconfig.plist' file is now required to specify your Urban Airship credentials and options.
* The properties in the `airshipconfig.plist` file have changed from earlier versions of the Urban Airship SDK. See the `Create AirshipConfig.plist` section of
the [Urban Airship documentation](http://docs.urbanairship.com/build/ios.html) for further details. The `airshipconfig.plist` file included with the module's
example application contains the updated properties.
* Rich Push user info is stored in the device keychain. This allows the user info to persist through app uninstalls and device upgrades, but this can cause
problems during development if you want to test a fresh install. To force a reset of the user credentials, set `clearKeychain` to YES in either the `AirshipConfig.plist`
file. This clears the keychain every time the application starts, so it should only be used in development.

## Setup

Follow these steps to properly setup your Titanium iOS application to use Urban Airship push notifications.

### Step 1: Setting App Credentials

You need to specify your app's credentials before it can interact with an application you've created on the Urban Airship dashboard (https://go.urbanairship.com).
Urban Airship looks for these in a file called <strong>AirshipConfig.plist</strong>, in the root of your application bundle.
You can optionally specify these values using the `options` property on the module.

* A sample AirshipConfig.plist file has been provided in the module's example folder (example/platform/iphone/AirshipConfig.plist).
* Copy the sample 'platform' folder to your application's project folder. For example, if your application folder is 'TestApp' then the resulting path should be 'TestApp/platform/iphone/AirshipConfig.plist'. This will ensure that your AirshipConfig.plist file is properly copied into the application bundle of your iPhone application when it is built.
* Update the AirshipConfig.plist file with your app's key and secret, and whether the app is currently in development or production.
* See the [Urban Airship Documentation](http://docs.urbanairship.com) for additional properties that can be set in this file.

### Step 2: Register for push notifications

Your application must register with Titanium to receive push notifications.

* Add a call to Ti.Network.registerForPushNotifications
* When the `success` function is called, register the device token with the module by calling the `registerDevice` method
* When the `callback` function is called, process the notification and pass the data to the module by calling `handleNotification`.

### Step 3: Set additional options

Several additional options can be controlled in your application code.

* See the list of properties below for other module options that can be set in your application

## Urban Airship Module Functions

### Ti.UrbanAirship.registerDevice(token[string])

Registers the device with Urban Airship for push notifications. Call this function after calling
Ti.Network.registerForPushNotifications.

<strong>Note:</strong> Versions of this module prior to 1.3.0 provided an `options` property for specifying `tags` and
`alias`. These have been deprecated in order to more closely match the functionality of the Urban Airship iOS Push Library.
You should now set the `tags` and `alias` properties directly on the module object.

#### Arguments

Requires one argument.

* token[string, required]: The deviceToken returned from Ti.Network.registerForPushNotifications.

### Ti.UrbanAirship.unregisterDevice()

Unregisters the device with Urban Airship.

#### Arguments

None.

### Ti.UrbanAirship.displayInbox({ animated[bool] })

Shows the persistent inbox that stores and organizes rich push notifications.

#### Arguments

Takes one optional argument, a dictionary with keys:

* animated[bool]: Whether the inbox should animate in; defaults to true

### Ti.UrbanAirship.hideInbox()

Hides the persistent inbox.

### Ti.UrbanAirship.handleNotification(data[object])

Handles a notification from Apple's servers.

#### Arguments

Takes one argument, the data payload from the "Ti.Network.registerForPushNotifications" callback.

* data[object]: The data payload from the "Ti.Network.registerForPushNotification" callback.

### Ti.UrbanAirship.resetBadge()

Resets the badge count on the UA servers. Note that the badge count is automatically reset at startup, application resume, and notification received events if the autoResetBadge property is true (the default value).

#### Arguments

None

## Properties

### isFlying[boolean] (read-only)

Tests if Urban Airship has been initialized and is ready for use

### tags[string[]]

Tags can be used to categorize devices, and you can push notifications to devices with particular tags.

### alias[string]

Aliases are associated with device tokens, providing an alternate name.

### notificationsEnabled[boolean] (read-only)

Whether or not notifications are enabled for your application (of any type: badge, alert, or sound).

### autoBadge[boolean] (write-only)

Ensures that the client will always sync badge changes with the server so that subsequent autobadge notifications will increment properly.

### badgeNumber[int] (write-only)

Sets the current badge number

### autoResetBadge[boolean] (default: true)

Enables the Urban Airship module to automatically call resetBadge after takeoff, when the application resumes, and when a notification is received (via a call to handleNotification).

### username[string] (read-only)

The username created by Urban Airship during device registration

### options[object]

A dictionary of the configuration options for this application. These values can be used to override any values
specified in the AirshipConfig.plist file (if provided):

* PRODUCTION\_APP\_KEY[string]: The application key for production
* PRODUCTION\_APP\_SECRET[string]: The application secret for production
* DEVELOPMENT\_APP\_KEY[string]: The application key for development
* DEVELOPMENT\_APP\_SECRET[string]: The application secret for development
* APP\_STORE\_OR\_AD\_HOC\_BUILD[bool]: Whether or not the app is in production (true if yes, false if not)
* LOGGING\_ENABLED[bool]: Whether or not logging should be enabled

## Example
<pre>/*
 * Demonstrates how to set up your UA Inbox,
 * and how to display the messages from it via the picker interface.
 */

var window = Ti.UI.createWindow({
    backgroundColor: 'white'
});

var UrbanAirship = require('ti.urbanairship');

Ti.UrbanAirship.options = {
    APP_STORE_OR_AD_HOC_BUILD: false,
    PRODUCTION_APP_KEY: '=== YOUR PROD APP KEY ===',
    PRODUCTION_APP_SECRET: '=== YOUR PROD APP SECRET ===',
    DEVELOPMENT_APP_KEY: '=== YOUR DEV APP KEY ===',
    DEVELOPMENT_APP_SECRET: '=== YOUR DEV APP SECRET ===',
    LOGGING_ENABLED: true
};

var b = Ti.UI.createButton({
    title: 'Open UA Inbox',
    width: 200, height: 40
});
b.addEventListener('click', function() {
    // Open default mailbox
    Ti.UrbanAirship.displayInbox({ animated:true });
});
window.add(b);

Ti.Network.registerForPushNotifications({
    types:[
        Ti.Network.NOTIFICATION_TYPE_BADGE,
        Ti.Network.NOTIFICATION_TYPE_ALERT,
        Ti.Network.NOTIFICATION_TYPE_SOUND
    ],
    success: function(e) {
        var token = e.deviceToken;
        Ti.UrbanAirship.registerDevice(token);

        b.enabled = true;
    },
    error: function(e) {
        alert("Error: " + e.error);
    },
    callback: function(e) {
        Ti.UrbanAirship.handleNotification(e.data);
    }
});

window.open();</pre>

## Author

Jeff English

## Module History

View the [change log](changelog.html) for this module.

## Feedback and Support

Please direct all questions, feedback, and concerns to [info@appcelerator.com](mailto:info@appcelerator.com?subject=iOS%20UrbanAirship%20Module).

## License

Copyright(c) 2010-2013 by Appcelerator, Inc. All Rights Reserved. Please see the LICENSE file included in the distribution for further details.
