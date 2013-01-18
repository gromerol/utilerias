/**
 * Ti.Box Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

package ti.box;

import org.appcelerator.titanium.TiApplication;
import org.appcelerator.kroll.common.TiConfig;

import android.app.Activity;
import android.content.SharedPreferences;

public class Constants
{
	public static final String LCAT = "BoxModule";
	public static final boolean DBG = TiConfig.LOGD;
	
    public static String API_KEY = null;
    public static final String PREFS_FILE_NAME = "prefs";
	public static final String PREFS_KEY_AUTH_TOKEN = "AUTH_TOKEN";
	
	private static String AUTH_TOKEN;
	public static void setAuthToken(String val) {
		AUTH_TOKEN = val;
	}
	public static String getAuthToken() {
		if (AUTH_TOKEN == null) {
			Activity activity = TiApplication.getAppRootOrCurrentActivity();
			final SharedPreferences prefs = activity.getSharedPreferences(Constants.PREFS_FILE_NAME, 0);
			AUTH_TOKEN = prefs.getString(Constants.PREFS_KEY_AUTH_TOKEN, null);
		}
		return AUTH_TOKEN;
	}
	
}