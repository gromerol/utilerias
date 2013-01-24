/**
 * Ti.Paypal Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

package ti.modules.titanium.paypal;

import java.util.HashMap;

import org.appcelerator.kroll.KrollModule;
import org.appcelerator.kroll.annotations.Kroll;
import org.appcelerator.titanium.proxy.TiViewProxy;
import org.appcelerator.titanium.util.TiActivityResultHandler;
import org.appcelerator.kroll.common.TiConfig;
import org.appcelerator.titanium.TiApplication;

import android.app.Activity;
import android.content.Intent;
import android.util.Log;

import com.paypal.android.MEP.CheckoutButton;
import com.paypal.android.MEP.PayPal;
import com.paypal.android.MEP.PayPalAdvancedPayment;
import com.paypal.android.MEP.PayPalPayment;
import com.paypal.android.MEP.PayPalPreapproval;


@Kroll.module(name="Paypal", id="ti.paypal")
public class PaypalModule extends KrollModule
	implements TiActivityResultHandler
{
	private static final String LCAT = "PaypalModule";
	private static final boolean DBG = TiConfig.DEBUG;

	@Kroll.constant public static final int INITIALIZE_SUCCESS = 0;
	@Kroll.constant public static final int INITIALIZE_FAILURE = 1;
	
	@Kroll.constant public static final int PAYPAL_ENV_LIVE = PayPal.ENV_LIVE;
	@Kroll.constant public static final int PAYPAL_ENV_SANDBOX = PayPal.ENV_SANDBOX;
	@Kroll.constant public static final int PAYPAL_ENV_NONE = PayPal.ENV_NONE;
	
	@Kroll.constant public static final int PREAPPROVAL_TYPE_AGREE = PayPalPreapproval.TYPE_AGREE;
	@Kroll.constant public static final int PREAPPROVAL_TYPE_AGREE_AND_PAY = PayPalPreapproval.TYPE_AGREE_AND_PAY;
	
	@Kroll.constant public static final int PREAPPROVAL_DAY_SUNDAY = PayPalPreapproval.DAY_SUNDAY;
	@Kroll.constant public static final int PREAPPROVAL_DAY_MONDAY = PayPalPreapproval.DAY_MONDAY;
	@Kroll.constant public static final int PREAPPROVAL_DAY_TUESDAY = PayPalPreapproval.DAY_TUESDAY;
	@Kroll.constant public static final int PREAPPROVAL_DAY_WEDNESDAY = PayPalPreapproval.DAY_WEDNESDAY;
	@Kroll.constant public static final int PREAPPROVAL_DAY_THURSDAY = PayPalPreapproval.DAY_THURSDAY;
	@Kroll.constant public static final int PREAPPROVAL_DAY_FRIDAY = PayPalPreapproval.DAY_FRIDAY;
	@Kroll.constant public static final int PREAPPROVAL_DAY_SATURDAY = PayPalPreapproval.DAY_SATURDAY;
	
	@Kroll.constant public static final int PREAPPROVAL_PERIOD_ANNUALLY = PayPalPreapproval.PERIOD_ANNUALLY;
	@Kroll.constant public static final int PREAPPROVAL_PERIOD_BIWEEKLY = PayPalPreapproval.PERIOD_BIWEEKLY;
	@Kroll.constant public static final int PREAPPROVAL_PERIOD_DAILY = PayPalPreapproval.PERIOD_DAILY;
	@Kroll.constant public static final int PREAPPROVAL_PERIOD_MONTHLY = PayPalPreapproval.PERIOD_MONTHLY;
	@Kroll.constant public static final int PREAPPROVAL_PERIOD_NONE = PayPalPreapproval.PERIOD_NONE;
	@Kroll.constant public static final int PREAPPROVAL_PERIOD_SEMIMONTHLY = PayPalPreapproval.PERIOD_SEMIMONTHLY;
	@Kroll.constant public static final int PREAPPROVAL_PERIOD_WEEKLY = PayPalPreapproval.PERIOD_WEEKLY;

	@Kroll.constant public static final int PAYPAL_TEXT_PAY = CheckoutButton.TEXT_PAY;
	@Kroll.constant public static final int PAYPAL_TEXT_DONATE = CheckoutButton.TEXT_DONATE;

	@Kroll.constant public static final int PAYMENT_TYPE_GOODS = PayPal.PAYMENT_TYPE_GOODS;
	@Kroll.constant public static final int PAYMENT_TYPE_SERVICE = PayPal.PAYMENT_TYPE_SERVICE;
	@Kroll.constant public static final int PAYMENT_TYPE_PERSONAL = PayPal.PAYMENT_TYPE_PERSONAL;
	@Kroll.constant public static final int PAYMENT_TYPE_NONE = PayPal.PAYMENT_TYPE_NONE;
	
	@Kroll.constant public static final int PAYMENT_SUBTYPE_NONE = PayPal.PAYMENT_SUBTYPE_NONE;
	@Kroll.constant public static final int PAYMENT_SUBTYPE_AFFILIATE = PayPal.PAYMENT_SUBTYPE_AFFILIATE;
	@Kroll.constant public static final int PAYMENT_SUBTYPE_B2B = PayPal.PAYMENT_SUBTYPE_B2B;
	@Kroll.constant public static final int PAYMENT_SUBTYPE_PAYROLL = PayPal.PAYMENT_SUBTYPE_PAYROLL;
	@Kroll.constant public static final int PAYMENT_SUBTYPE_REBATES = PayPal.PAYMENT_SUBTYPE_REBATES;
	@Kroll.constant public static final int PAYMENT_SUBTYPE_REFUNDS = PayPal.PAYMENT_SUBTYPE_REFUNDS;
	@Kroll.constant public static final int PAYMENT_SUBTYPE_REIMBUSEMENTS = PayPal.PAYMENT_SUBTYPE_REIMBUSEMENTS;
	@Kroll.constant public static final int PAYMENT_SUBTYPE_REIMBURSEMENTS = PayPal.PAYMENT_SUBTYPE_REIMBURSEMENTS;
	@Kroll.constant public static final int PAYMENT_SUBTYPE_DONATIONS = PayPal.PAYMENT_SUBTYPE_DONATIONS;
	@Kroll.constant public static final int PAYMENT_SUBTYPE_UTILITIES = PayPal.PAYMENT_SUBTYPE_UTILITIES;
	@Kroll.constant public static final int PAYMENT_SUBTYPE_TUITION = PayPal.PAYMENT_SUBTYPE_TUITION;
	@Kroll.constant public static final int PAYMENT_SUBTYPE_GOVERNMENT = PayPal.PAYMENT_SUBTYPE_GOVERNMENT;
	@Kroll.constant public static final int PAYMENT_SUBTYPE_INSURANCE = PayPal.PAYMENT_SUBTYPE_INSURANCE;
	@Kroll.constant public static final int PAYMENT_SUBTYPE_REMITTANCES = PayPal.PAYMENT_SUBTYPE_REMITTANCES;
	@Kroll.constant public static final int PAYMENT_SUBTYPE_RENT = PayPal.PAYMENT_SUBTYPE_RENT;
	@Kroll.constant public static final int PAYMENT_SUBTYPE_MORTGAGE = PayPal.PAYMENT_SUBTYPE_MORTGAGE;
	@Kroll.constant public static final int PAYMENT_SUBTYPE_MEDICAL = PayPal.PAYMENT_SUBTYPE_MEDICAL;
	@Kroll.constant public static final int PAYMENT_SUBTYPE_CHILDCARE = PayPal.PAYMENT_SUBTYPE_CHILDCARE;
	@Kroll.constant public static final int PAYMENT_SUBTYPE_EVENTS = PayPal.PAYMENT_SUBTYPE_EVENTS;
	@Kroll.constant public static final int PAYMENT_SUBTYPE_CONTRACTORS = PayPal.PAYMENT_SUBTYPE_CONTRACTORS;
	@Kroll.constant public static final int PAYMENT_SUBTYPE_ENTERTAINMENT = PayPal.PAYMENT_SUBTYPE_ENTERTAINMENT;
	@Kroll.constant public static final int PAYMENT_SUBTYPE_TOURISM = PayPal.PAYMENT_SUBTYPE_TOURISM;
	@Kroll.constant public static final int PAYMENT_SUBTYPE_INVOICE = PayPal.PAYMENT_SUBTYPE_INVOICE;
	@Kroll.constant public static final int PAYMENT_SUBTYPE_TRANSFER = PayPal.PAYMENT_SUBTYPE_TRANSFER;
	
	@Kroll.constant public static final int BUTTON_152x33 = PayPal.BUTTON_152x33;
	@Kroll.constant public static final int BUTTON_194x37 = PayPal.BUTTON_194x37;
	@Kroll.constant public static final int BUTTON_278x43 = PayPal.BUTTON_278x43;
	@Kroll.constant public static final int BUTTON_294x45 = PayPal.BUTTON_294x45;
	
	@Kroll.constant public static final String EVENT_BUTTON_DISPLAYED = "buttonDisplayed";
	@Kroll.constant public static final String EVENT_BUTTON_ERROR = "buttonError";
	@Kroll.constant public static final String EVENT_PAYMENT_SUCCESS = "paymentSuccess";
	@Kroll.constant public static final String EVENT_PAYMENT_ERROR = "paymentError";
	@Kroll.constant public static final String EVENT_UNKNOWN_RESPONSE = "unknownResponse";
	@Kroll.constant public static final String EVENT_PAYMENT_CANCELLED = "paymentCancelled";

	private static PaypalModule _instance;

	public static PaypalModule getInstance() {
		return _instance;
	}

	public PaypalModule() {
		super();
		_instance = this;
	}

	private static HashMap<Integer, PaypalModule> idToModule = new HashMap<Integer, PaypalModule>();
	private static HashMap<Integer, TiViewProxy> idToViewProxy = new HashMap<Integer, TiViewProxy>();

	public static ResultDelegate enqueueDelegate(PaypalModule module, TiViewProxy proxy) {
		ResultDelegate delegate = new ResultDelegate();
		int id = delegate.getID();
		idToModule.put(id, module);
		idToViewProxy.put(id, proxy);
		return delegate;
	}

	public static void dequeueDelegate(ResultDelegate delegate, String event, HashMap<String, Object> eventData) {
		int id = delegate.getID();

		TiViewProxy proxy = idToViewProxy.get(id);
		if (proxy != null) {
			proxy.fireEvent(event, eventData);
			idToViewProxy.remove(id);
		}

		PaypalModule module = idToModule.get(id);
		if (module != null) {
			module.fireEvent(event, eventData);
			idToModule.remove(id);
		}
	}

	public void executePayment(TiViewProxy proxy, PayPalPayment newPayment) {
		Activity activity = TiApplication.getAppCurrentActivity();
		Intent checkoutIntent = PayPal.getInstance().checkout(newPayment, activity, enqueueDelegate(this, proxy));
		activity.startActivity(checkoutIntent);
	}

	public void executeAdvancedPayment(TiViewProxy proxy, PayPalAdvancedPayment newPayment) {
		Activity activity = TiApplication.getAppCurrentActivity();
		Intent checkoutIntent = PayPal.getInstance().checkout(newPayment, activity, enqueueDelegate(this, proxy));
		activity.startActivity(checkoutIntent);
	}

	public void executePreapproval(TiViewProxy proxy, PayPalPreapproval preapproval) {
		Activity activity = TiApplication.getAppCurrentActivity();
		Intent checkoutIntent = PayPal.getInstance().preapprove(preapproval, activity, enqueueDelegate(this, proxy));
		activity.startActivity(checkoutIntent);
	}

	@Override
	public void onError(Activity arg0, int arg1, Exception arg2) {
		// We don't use this; we use the ResultDelegate.
	}

	@Override
	public void onResult(Activity arg0, int arg1, int arg2, Intent arg3) {
		// We don't use this; we use the ResultDelegate.
	}
}
