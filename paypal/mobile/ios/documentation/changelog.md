# Change Log
<pre>
v1.8.0  Upgraded to PayPal MPL library version 2.1.0 (iOS7 fix) [TIMODOPEN-348]

v1.7.0  Upgraded to PayPal MPL library version 2.0.0 (UDID fix) [TIMODOPEN-243]

v1.6.2  Building with 2.1.3.GA and open sourcing [MOD-942]
	
v1.6.1  Fix for memory exception when using preapproval merchant name property [TIMODOPEN-152]

v1.6    Upgraded to PayPal MPL library version 1.6.0

v1.5	BREAKING CHANGE (iOS/Android): Per popular request, events will now fire on the buttons for both platforms. This makes it easier to distinguish events when multiple buttons are present in your application [MOD-384].
		Fixed bug when feePaidByReceiver was set to true [MOD-386].
		Corrected documentation on feePaidByReceiver. It is not limited to just PERSONAL payment types, as previously documented.

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
		On Android, payment events now fire as soon as they happen instead of waiting until after the dialog is closed [MOD-294].

v1.3	Exposed the "language" property of the PayPal button.
		- The default language will now properly be whatever language the user has selected in their internationalization
			settings. Note that if PayPal does not support the users language, they will fall back to use English.

v1.2	Exposed the "customID" property of payments.

v1.1    Upgraded to PayPal MPL 1.2.1 library. Several changes to the API had to be made as a consequence:
        - There are now fewer size options for the button. Only the following sizes remain: 152x33, 194x37, 278x43, and 294x43
        - "Donation" is no longer a valid type of payment, according to the library
        
v1.0    Initial Release
