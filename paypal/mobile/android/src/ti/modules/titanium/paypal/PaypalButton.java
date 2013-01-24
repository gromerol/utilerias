/**
 * Ti.Paypal Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

package ti.modules.titanium.paypal;

import org.appcelerator.kroll.KrollDict;
import org.appcelerator.titanium.proxy.TiViewProxy;
import org.appcelerator.kroll.common.Log;
import org.appcelerator.titanium.view.TiUIView;
import org.appcelerator.titanium.TiApplication;

import android.content.Context;

import java.util.HashMap;

import com.paypal.android.MEP.CheckoutButton;
import com.paypal.android.MEP.PayPal;

public class PaypalButton extends TiUIView {
	// Debug helpers
	private static final String LCAT = "PaypalButton";

	public PaypalButton(TiViewProxy proxy) {
		super(proxy);

		createButton(proxy);
	}

	private void createButton(final TiViewProxy proxy) {
		Context context = TiApplication.getInstance().getApplicationContext();
		KrollDict props = proxy.getProperties();
		
		PaypalModule module = (PaypalModule) proxy.getCreatedInModule();
		if (module == null) {
	            // NOTE: Using an object in a static isn't necessarily safe, but
	            // currently getCreatedInModule isn't implemented completely. So,
	            // if we get null back then we'll grab the statically maintained
	            // module object and use it. This code can be removed once the
	            // getCreatedModule is working again.
		  	    module = PaypalModule.getInstance();
		}

		String appID = props.optString("appID", props.optString("appId", "APP-80W284485P519543T"));
		int paypalEnvironment = props.optInt("paypalEnvironment", PayPal.ENV_SANDBOX);
		String language = props.optString("language", "en_US");
		int feePaidByReceiver = props.optBoolean("feePaidByReceiver", false) ? PayPal.FEEPAYER_EACHRECEIVER : PayPal.FEEPAYER_SENDER;
		boolean enableShipping = props.optBoolean("enableShipping", true);
		int buttonStyle = props.optInt("buttonStyle", PayPal.BUTTON_152x33);
		Log.i(LCAT, "buttonStyle: " + buttonStyle);
		int textStyle = props.containsKey("textStyle") ? props.getInt("textStyle") : CheckoutButton.TEXT_PAY;
		PayPal paypal = PayPal.initWithAppID(context, appID, paypalEnvironment);
		paypal.setLanguage(language);
		paypal.setFeesPayer(feePaidByReceiver);
		paypal.setShippingEnabled(enableShipping);
		
		if (props.containsKey("preapprovalKey")) {
			paypal.setPreapprovalKey(props.getString("preapprovalKey"));
		}
		if (props.containsKey("cancelUrl")) {
			paypal.setCancelUrl(props.getString("cancelUrl"));
		}
		if (props.containsKey("returnUrl")) {
			paypal.setReturnUrl(props.getString("returnUrl"));
		}

		// The library is initialized so let's create our CheckoutButton
		// and update the UI.
		if (PayPal.getInstance() != null && PayPal.getInstance().isLibraryInitialized()) {
			setNativeView(paypal.getCheckoutButton(context, buttonStyle, textStyle));
			HashMap<String, Object> eventData = new HashMap<String, Object>();
			proxy.fireEvent(PaypalModule.EVENT_BUTTON_DISPLAYED, eventData);
			module.fireEvent(PaypalModule.EVENT_BUTTON_DISPLAYED, eventData);
		} else {
			HashMap<String, Object> eventData = new HashMap<String, Object>();
			eventData.put("errorCode", 0);
			eventData.put("errorMessage", "Failed to initialize the PayPal library!");
			proxy.fireEvent(PaypalModule.EVENT_BUTTON_ERROR, eventData);
			module.fireEvent(PaypalModule.EVENT_BUTTON_ERROR, eventData);
		}
	}
}
