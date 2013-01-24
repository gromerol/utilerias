var Paypal = require('ti.paypal');

var win = Ti.UI.currentWindow;
var u = Ti.Android != undefined ? 'dp' : 0;

var status = Ti.UI.createLabel({
    top: 50 + u, height: 45 + u, color: '#333',
    text: 'Loading, please wait...'
});
win.add(status);

var button;
function addButtonToWindow() {
    if (button) {
        win.remove(button);
        button = null;
    }
    button = Paypal.createPaypalButton({
        // NOTE: height/width only determine the size of the view that the button is embedded in - the actual button size
        // is determined by the buttonStyle property!
        width: 194 + u, height: 37 + u,
        buttonStyle: Paypal.BUTTON_194x37, // The style & size of the button
        bottom: 50 + u,

        language: 'en_US',
        textStyle: Paypal.PAYPAL_TEXT_DONATE, // Causes the button's text to change from "Pay" to "Donate"

        appID: '<<<YOUR APP ID HERE>>>', // The appID issued by Paypal for your application; for testing, feel free to delete this property entirely.
        paypalEnvironment: Paypal.PAYPAL_ENV_SANDBOX, // Sandbox, None or Live

        feePaidByReceiver: false,
        enableShipping: false, // Whether or not to select/send shipping information

        payment: { // The payment itself
            paymentType: Paypal.PAYMENT_TYPE_SERVICE, // The type of payment
            subtotal: 10, // The total cost of the order, excluding tax and shipping
            tax: 0,
            shipping: 0,
            currency: 'USD',
            recipient: '<<<YOUR RECIPIENT HERE>>>',
            customID: 'anythingYouWant',
            invoiceItems: [
                { name: 'Shoes', totalPrice: 8, itemPrice: 2, itemCount: 4 },
                { name: 'Hats', totalPrice: 2, itemPrice: 0.5, itemCount: 4 }
            ],
            ipnUrl: 'http://www.appcelerator.com/',
            merchantName: 'Dev Tools',
            memo: 'For the orphans and widows in the world!'
        }
    });

    // Events available
    button.addEventListener('paymentCancelled', function (e) {
        status.text = 'Payment Cancelled.';
        // The button should only be used once; so after a payment is cancelled, succeeds, or errors, we must redisplay it.
        addButtonToWindow();
    });
    button.addEventListener('paymentSuccess', function (e) {
        status.text = 'Payment Success.  TransactionID: ' + e.transactionID + ', Reloading...';
        // The button should only be used once; so after a payment is cancelled, succeeds, or errors, we must redisplay it.
        addButtonToWindow();
    });
    button.addEventListener('paymentError', function (e) {
        status.text = 'Payment Error,  errorCode: ' + e.errorCode + ', errorMessage: ' + e.errorMessage;
        // The button should only be used once; so after a payment is cancelled, succeeds, or errors, we must redisplay it.
        addButtonToWindow();
    });

    button.addEventListener('buttonDisplayed', function () {
        status.text = 'The button was displayed!';
    });
    button.addEventListener('buttonError', function () {
        status.text = 'The button failed to display!';
    });
    win.add(button);
}
addButtonToWindow();