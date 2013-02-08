# Change Log
<pre>
v2.3.2  [MOD-1268] Open sourcing
	
v2.3.1  [MOD-1087][MOD-1104] Added attribution and built with 2.1.3.GA to support x86 devices
	
v2.3.0  [MOD-1013] Upgraded to Urban Airship version 2.0.3
        - BREAKING CHANGE - C2DM functionality has been deprecated. Use GCM instead.
        Added support for GCM

v2.2.0  [MOD-804] Upgraded to Urban Airship version 1.1.5

v2.1.1  [MOD-623] Upgraded to Urban Airship version 1.1.1
        [MOD-529] Updated default airshipconfig.properties to mention that c2dmSender is not optional when using c2dm

v2.1    [MOD-192] Updated timodule.xml to use auto-replacement for package name

v2.0	Upgraded to module api version 2 for 1.8.0.1

v1.4    [MOD-296] Updated manifest and documentation for minimum SDK requirements
        [MOD-291] Improved logging for invalid setup and configuration

v1.3    Refactored to match UA Android Client library API and functionality.
        Removed 'takeOff' function and 'options' property
        Added pushId and c2dmId properties
        Added airshipconfig.properties sample file
        Updated documentation and example

v1.2	Exposed "tags" and "alias" properties. Check out the documentation for more information.

v1.1.1  MOD-157 Refactored to support new onAppCreate method to initialize UA during Push Service startup

v1.1    Upgraded to support the latest Urban Airship Android library (Push Notifications only)
        Module name has changed to all lowercase (ti.urbanairship). You will need to update any previous references to this library.
        Version number of module has changed to 1.1. You will need to update your tiapp.xml file to reference the new version number.
        The new 'takeoff' method must be used to register for notifications
        Options are specified by setting the new 'options' module dictionary property (see documentation and example)
        Several new module properties are available for managing sound, vibrate, and push settings (see documentation and example)
        Support added for event listeners to handle Urban Airship notifications (as an option to callbacks in the takeoff method - see documentation and example)
        Updated documentation
        New example demonstrating takeoff, module property management, and both notification techniques
        C2DM transport is supported via the Urban Airship library. Refer to the Urban Airship and Google C2DM documentation for additional details on using this transport in your application.

v1.0    Initial Release
