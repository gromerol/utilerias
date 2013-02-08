/**
 * Ti.Urbanairship Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

package ti.modules.titanium.urbanairship;

import java.util.Arrays;
import java.util.List;
import java.util.Set;
import java.util.HashMap;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

import com.urbanairship.push.PushManager;

public class IntentReceiver extends BroadcastReceiver {
	private static final String LCAT = "UrbanAirshipModule";
	
	// New in the latest version of Urban Airship is that the extra string has been deprecated
	// and extra data is now delivered as a set of key-value pairs. This method builds a 
	// dictionary of these values to be sent back to the user.
	private HashMap<String, String> getPushExtras(Intent intent) {
		Set<String> keys = intent.getExtras().keySet();
		
		// We want to ignore all of the UA-specific keys that are sent down with the data
		List<String> ignoredKeys = (List<String>)Arrays.asList(
				"collapse_key", // c2dm collapse key
				"from",         // c2dm sender
				PushManager.EXTRA_NOTIFICATION_ID,  // int id of generated notification
				PushManager.EXTRA_PUSH_ID,          // internal UA push id
				PushManager.EXTRA_ALERT);           // ignore alert
		
		HashMap<String, String> kd = new HashMap<String, String>();
		for (String key : keys) {
			if (!ignoredKeys.contains(key)) {
				kd.put(key, intent.getStringExtra(key));
			}
		}
		
		return kd;
	}
	
	@Override
	public void onReceive(Context context, Intent intent) {
		Log.i(LCAT, "Received intent: " + intent.toString());
		String action = intent.getAction();

		if (action.equals(PushManager.ACTION_PUSH_RECEIVED)) {
		    String message = intent.getStringExtra(PushManager.EXTRA_ALERT);
		    HashMap<String, String> extras = getPushExtras(intent);

		    UrbanAirshipModule.handleReceivedMessage(message, extras.toString(), false, false);		    
		} else if (action.equals(PushManager.ACTION_NOTIFICATION_OPENED)) {
		    String message = intent.getStringExtra(PushManager.EXTRA_ALERT);
		    HashMap<String, String> extras = getPushExtras(intent);
		    
			UrbanAirshipModule.handleReceivedMessage(message, extras.toString(), true, true);
		} else if (action.equals(PushManager.ACTION_REGISTRATION_FINISHED)) {
			String apid = intent.getStringExtra(PushManager.EXTRA_APID);
			Boolean valid = intent.getBooleanExtra(PushManager.EXTRA_REGISTRATION_VALID, false);
			
            UrbanAirshipModule.handleRegistrationComplete(apid, valid);           
		}
	}
}
