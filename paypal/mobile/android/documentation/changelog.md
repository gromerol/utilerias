# Change Log
<pre>
v2.2.3  [TIMODOPEN-256] Fixed click events not getting processed

v2.2.2  [MOD-942] Building with 2.1.3.GA and open sourcing
	
v2.2.1	Fixed crash with Titanium Mobile SDK 2.0.1 [MOD-632].

v2.2	BREAKING CHANGE (iOS/Android): Per popular request, events will now fire on the buttons for both platforms. This makes it easier to distinguish events when multiple buttons are present in your application [MOD-384].
		Fixed bug where enableShipping was always set to true on Android [MOD-379]
		Corrected documentation on feePaidByReceiver. It is not limited to just PERSONAL payment types, as previously documented.

v2.1	Fixed appID inconsistency between examples and documentation; the module will accept either, but using an uppercase D is the official case [MOD-426].

v2.0	Upgraded to module api version 2 for 1.8.0.1

v1.5	On Android, payment events now fire as soon as they happen instead of waiting until after the dialog is closed [MOD-294].

v1.4	Support for Preapproval. See documentation and example for more information [MOD-12].
		Support for Parallel and Chain payments. See documentation and example for more information [MOD-221][MOD-222].
		Exposed invoiceItems for more detailed invoice itemization. See documentation and example for more information.
		Full Android and iOS Module Parity [MOD-273]:
		- iOS now has and uses the PAYPAL_TEXT_* constants. It was using a "donation" boolean property, but not anymore.
		- BREAKING CHANGE (iOS/Android): "transactionType" was renamed to "paymentType", and is now a property on the "payment" dictionary. Check out the documentation and example to learn more!
		- BREAKING CHANGE (iOS): "amount" was renamed to "subtotal" to more accurately reflect what it does with the underlying PayPal MPL.
		- Added two new properties to the payment dictionary: "ipnUrl", and "memo".
		- BREAKING CHANGE (iOS): While documented as firing "paymentCancelled", the iOS module was actually firing "paymentCanceled" (with one l). "paymentCancelled" must be used from now on.
		- iOS now fires the "buttonDisplayed" and "buttonErrored" events, when appropriate.
		- BREAKING CHANGE (iOS): The events now fire off of the module itself, not the button. addEventListener should be called on Ti.Paypal, not on the button. See the documentation or example for more information!
		Donations are now exposed through the new "paymentSubtype" property on the payment dictionary. Check out the documentation and example for more information! [MOD-260]
		Upgraded iOS MPL to 1_5_5_060

v1.3	Button loading now takes place asynchronously, and the PayPal Library was updated to 1.5.5.44.

		Added two new events to the module; check out the example and documentation to find out more:
		- buttonDisplayed
		- buttonError
		
		Additional fixes were made for MOD-206:
		- Tablets require the additional "ACCESS_WIFI_STATE" and "INTERNET" permissions. These have been added.
		- The PayPal button needs to be recreated between uses. See the WARNING below and in the documentation.

		WARNING: The PayPal button is only designed to be used once! After a user returns from a transaction (by error,
		success, or cancellation), you must remove the existing button and create a new one. The example demonstrates
		how to do this successfully.

v1.2	Fixed issue MOD-206, checkout button can only be clicked once

v1.1    Updated PayPal Library

        With version 1.1, when you create a Paypal button, several of the properties have changed due to changes in the
        underlying API. Specifically:
        - *new* language
        - *new* textStyle
        - payment[dictionary]:
            - "amount" has been renamed to "subtotal"
            - *new* itemUnitPrice
            - *new* itemQuantity
            - *new* itemID
            - *new* customID
            - *new* ipnUrl
            - *new* memo

        "Ti.Paypal.PAYMENT_TYPE_HARD_GOODS" has been renamed to "Ti.Paypal.PAYMENT_TYPE_GOODS".
        "Ti.Paypal.PAYMENT_TYPE_DONATION" is no longer available, because it was removed from the underlying API.

        There are now only 4 available button sizes: 152x33, 194x37, 278x43, and 294x45.

v1.0    Initial Release
