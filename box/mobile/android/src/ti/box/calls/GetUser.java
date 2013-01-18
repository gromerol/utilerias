/**
 * Ti.Box Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

package ti.box.calls;


import java.io.IOException;

import org.appcelerator.kroll.KrollProxy;
import ti.box.Constants;
import ti.box.Util;
import ti.box.proxies.BoxUserProxy;

import com.box.androidlib.BoxSynchronous;
import com.box.androidlib.DAO.User;
import com.box.androidlib.ResponseParsers.UserResponseParser;

public class GetUser {

	/**
	 * Prevents instantiation.
	 */
	private GetUser() {}
	
	public static BoxUserProxy call(final KrollProxy proxy) {
		BoxSynchronous box = BoxSynchronous.getInstance(Constants.API_KEY);
		
		try {
			UserResponseParser response = box.getAccountInfo(Constants.getAuthToken());
			String status = response.getStatus();
			if (status.equals("get_account_info_ok")) {
				User user = response.getUser();
				if (user != null) {
				    BoxUserProxy userProxy = new BoxUserProxy();
				    userProxy.setBoxUser(user);
				    return userProxy;
				}
				else {
					Util.e("Failed to retrieve that user from the server!");
				}
			}
			else if (status.equals("not_logged_in")) {
				// The authToken was invalid
				Util.i("The user is not logged in");
			}
			else if (status.equals("application_restricted")) {
				// The API key was invalid, or has been restricted by Box.net
				Util.e("Got back application_restricted response from server; THE API KEY YOU SPECIFIED IS PROBABLY NOT VALID, OR HAS BEEN INVALIDATED BY BOX.NET!");
			}
			else {
				Util.e("Unknown status returned from Box.net server! " + status);
			}
		}
		catch (IOException e) {
			Util.handleIOException(proxy, e, null);
		}
		return null;
	}
}
