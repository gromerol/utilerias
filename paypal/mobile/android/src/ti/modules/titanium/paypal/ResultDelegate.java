/**
 * Ti.Paypal Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

package ti.modules.titanium.paypal;

import java.io.Serializable;
import com.paypal.android.MEP.PayPalResultDelegate;
import java.util.HashMap;
import java.util.concurrent.atomic.AtomicInteger;

public class ResultDelegate implements PayPalResultDelegate, Serializable {

	private static final long serialVersionUID = 9002L;
	private static transient AtomicInteger identifiers = new AtomicInteger();

	private int ourIdentifier;

	public ResultDelegate() {
		ourIdentifier = identifiers.incrementAndGet();
	}

	public int getID() {
		return ourIdentifier;
	}

	public void onPaymentSucceeded(String transactionID, String paymentStatus) {
		HashMap<String, Object> eventData = new HashMap<String, Object>();
		eventData.put("paymentStatus", paymentStatus);
		eventData.put("transactionID", transactionID);
		PaypalModule.dequeueDelegate(this, PaypalModule.EVENT_PAYMENT_SUCCESS, eventData);
	}

	public void onPaymentFailed(String paymentStatus, String correlationID, String transactionID, String errorID, String errorMessage) {
		HashMap<String, Object> eventData = new HashMap<String, Object>();
		eventData.put("errorID", errorID);
		eventData.put("errorCode", errorID);
		eventData.put("errorMessage", errorMessage);
		eventData.put("paymentStatus", paymentStatus);
		eventData.put("correlationID", correlationID);
		eventData.put("transactionID", transactionID);
		PaypalModule.dequeueDelegate(this, PaypalModule.EVENT_PAYMENT_ERROR, eventData);
	}

	public void onPaymentCanceled(String paymentStatus) {
		PaypalModule.dequeueDelegate(this, PaypalModule.EVENT_PAYMENT_CANCELLED, new HashMap<String, Object>());
	}
}