# Ti.Paypal.PaypalButton

## Description

A _Ti.Paypal_ module object which represents a button that performs PayPal operations.

## Warning

A paypal button may only be used once! It is designed to be created for one transaction. If the user cancels
the transaction, or goes through with it, you must recreate the paypal button before allowing them to touch it again.

## Events

### paymentCancelled
Sent upon cancellation of payment.  No event dictionary is sent.

### paymentFailed
Sent upon failure to process a payment.  The event dictionary is:

* errorCode[int, Android]: The error code for the error
* errorMessage[string, Android]: The error that occurred
* correlationID[string, iOS]: The correlation ID for the failed payment

### paymentSuccess
Sent up on successful processing of a payment.  The event dictionary is:

* transactionID[string]: The identifier representing this transaction.

### unknownResponse
Sent when we receive an unrecognized response from PayPal.

### buttonDisplayed
Fired when the PayPal button successfully loads and is displayed.

### buttonError
Fired when the PayPal button fails to load. This ordinarily only happens when app is unable to communicate with PayPal's
servers.