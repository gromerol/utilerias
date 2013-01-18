/**
 * Ti.Box Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

package ti.box.calls;


import java.io.IOException;
import java.util.HashMap;

import org.appcelerator.kroll.KrollDict;
import org.appcelerator.kroll.KrollFunction;
import org.appcelerator.kroll.KrollProxy;
import ti.box.Constants;
import ti.box.Util;

import com.box.androidlib.Box;
import com.box.androidlib.DAO.User;
import com.box.androidlib.ResponseListeners.RegisterNewUserListener;

public class RegisterUser {

	/**
	 * Prevents instantiation.
	 */
	private RegisterUser() {}
	
	public static void call(final KrollProxy proxy, HashMap args) {
		KrollDict argsDict = new KrollDict(args);
		String username = argsDict.getString("username");
		String password = argsDict.getString("password");

	    final KrollFunction success = (KrollFunction)args.get("success");
    	final KrollFunction error = (KrollFunction)args.get("error");
	    final Box box = Box.getInstance(Constants.API_KEY);
		box.registerNewUser(username, password, new RegisterNewUserListener() {

			@Override
			public void onIOException(IOException ex) {
				Util.handleIOException(proxy, ex, error);
			}
			
			@Override
			public void onComplete(User user, String status) {
				if (status.equals("successful_register")) {
					Util.saveAuthToken(user.getAuthToken());
					success.callAsync(proxy.getKrollObject(), new Object[] {});
				}
				else if (status.equals("email_invalid")) {
					Util.handleError(proxy, "The username you specified is not valid!", status, error);
				}
				else if (status.equals("email_already_registered")) {
					Util.handleError(proxy, "That username is already registered!", status, error);
				}
				else if (status.equals("e_register")) {
					Util.handleError(proxy, "The username or password you specified was not valid!", status, error);
				}
				else {
					Util.handleCommonStatuses(proxy, status, error);
				}
			}
		});
	}
}
