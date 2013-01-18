/**
 * Ti.Box Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

package ti.box;

import java.io.IOException;
import java.net.MalformedURLException;

import org.appcelerator.titanium.TiApplication;
import org.appcelerator.kroll.KrollFunction;
import org.appcelerator.kroll.KrollProxy;
import org.appcelerator.kroll.common.Log;

import android.app.Activity;
import android.content.SharedPreferences;

import java.util.HashMap;
/**
 * Holds various static methods that we will use throughout the module.
 * @author Dawson Toth, Appcelerator Inc.
 */
public final class Util {

	/**
	 * Prevents instantiation.
	 */
	private Util() {}
	
	public static int degrade(long l) {
		int i = (int)l;
	    if ((long)i != l) {
	        throw new IllegalArgumentException(l + " cannot be downgraded to int without changing its value.");
	    }
	    return i;
	}
	
	/**
	 * Persists an authorization token for later use.
	 * @param authToken
	 */
	public static void saveAuthToken(String authToken) {
		Activity activity = TiApplication.getAppRootOrCurrentActivity();
		final SharedPreferences prefs = activity.getSharedPreferences(Constants.PREFS_FILE_NAME, 0);
	    final SharedPreferences.Editor editor = prefs.edit();
	    if (authToken == null) {
	    	editor.remove(Constants.PREFS_KEY_AUTH_TOKEN);
	    }
	    else {
	    	editor.putString(Constants.PREFS_KEY_AUTH_TOKEN, authToken);
	    }
	    editor.commit();
	    Constants.setAuthToken(authToken);
	}

	/**
	 * Knows about common statuses that the Box.net servers can return, and will log and fire off callbacks are appropriate.
	 * @param status
	 * @param error
	 * @return The English error message interpreted from the status code.
	 */
	public static String handleCommonStatuses(KrollProxy proxy, String status, KrollFunction error) {
		String message = null;
		if (status.equals("not_logged_in")) {
			message = "You have to be logged in to do that!";
		}
		else if (status.equals("application_restricted")) {
			message = "You provided an invalid apiKey, or the apiKey is restricted from calling this function!";
		}
		else if (status.equals("e_filename_in_use")) {
			message = "The file cannot be copied because a file of the same name already exists in that folder.";
		}
		else if (status.equals("e_no_access")) {
			message = "You do not have the necessary permissions to do that.  Most likely you are trying to act on a collaborated folder, to which you have view-only permission.";
		}
		else {
			message = "Received an unexpected response from the server: " + status + ".";
		}
		
		e(message);
		if (error != null) {
			HashMap event = new HashMap();
			event.put("error", message);
			event.put("status", status);
			error.callAsync(proxy.getKrollObject(), event);
		}
		return message;
	}
	
	/**
	 * Deals with an error by logging it (and the provided status), and calling the provided error callback.
	 * @param message
	 * @param status
	 * @param error
	 * @return
	 */
	public static String handleError(KrollProxy proxy, String message, String status, KrollFunction error) {
		e(status + ": " + message);
		if (error != null) {
			HashMap event = new HashMap();
			event.put("error", message);
			event.put("status", status);
			error.callAsync(proxy.getKrollObject(), event);
		}
		return message;
	}
	
	/**
	 * A specific wrapper around the handleError method for the MalformedURLException that is so common in the Box APIs.
	 * @param ex
	 * @param error
	 * @return
	 */
	public static String handleMalformedURLException(KrollProxy proxy, MalformedURLException ex, KrollFunction error) {
		e("A malformed URL exception was thrown.", ex);
		if (error != null) {
			HashMap event = new HashMap();
			event.put("error", ex.toString());
			event.put("type", "MalformedURLException");
			error.callAsync(proxy.getKrollObject(), event);
		}
		return "A malformed URL exception was thrown.";
	}
	
	/**
	 * A specific wrapper around the handleError method for the IOException that is so common in the Box APIs.
	 * @param ex
	 * @param error
	 * @return
	 */
	public static String handleIOException(KrollProxy proxy, IOException ex, KrollFunction error) {
		e("A IO exception was thrown.", ex);
		if (error != null) {
			HashMap event = new HashMap();
			event.put("error", ex.toString());
			event.put("type", "IOException");
			error.callAsync(proxy.getKrollObject(), event);
		}
		return "A IO exception was thrown.";
	}
	

	/*
	 * These 8 methods are useful for logging purposes -- they make what we do in this module a tiny bit easier.
	 */
	public static void d(String msg) {
		Log.d(Constants.LCAT, msg);
	}
	public static void d(String msg, Throwable e) {
		Log.d(Constants.LCAT, msg, e);
	}
	
	public static void i(String msg) {
		Log.i(Constants.LCAT, msg);
	}
	public static void i(String msg, Throwable e) {
		Log.i(Constants.LCAT, msg, e);
	}

	public static void w(String msg) {
		Log.w(Constants.LCAT, msg);
	}
	public static void w(String msg, Throwable e) {
		Log.w(Constants.LCAT, msg, e);
	}
	
	public static void e(String msg) {
		Log.e(Constants.LCAT, msg);
	}
	public static void e(String msg, Throwable e) {
		Log.e(Constants.LCAT, msg, e);
	}
}
