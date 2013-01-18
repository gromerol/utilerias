/**
 * Ti.Box Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

package ti.box.calls;

import org.appcelerator.kroll.KrollProxy;
import java.io.IOException;

import ti.box.Constants;
import ti.box.Util;

import com.box.androidlib.Box;
import com.box.androidlib.ResponseListeners.LogoutListener;

public class Logout {

	/**
	 * Prevents instantiation.
	 */
	private Logout() {}
	
	public static void call(final KrollProxy proxy) {
		// Call the API to invalidate the authToken
	    final Box box = Box.getInstance(Constants.API_KEY);
		box.logout(Constants.getAuthToken(), new LogoutListener() {

			@Override
			public void onIOException(IOException ex) {
				Util.handleIOException(proxy, ex, null);
			}
			
			@Override
			public void onComplete(String status) {
				if (status.equals("logout_ok")) {
					Util.i("Logout complete; auth token deauthorized by the server.");
				}
				else {
					Util.handleCommonStatuses(proxy, status, null);
				}
			}
		});
		// Nullify the authToken.
		Util.saveAuthToken(null);
	}
}
