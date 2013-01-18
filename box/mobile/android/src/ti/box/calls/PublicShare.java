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
import com.box.androidlib.ResponseListeners.PublicShareListener;

public class PublicShare {

	/**
	 * Prevents instantiation.
	 */
	private PublicShare() {}
	
	public static void call(final KrollProxy proxy, HashMap args) {
		
		KrollDict argsDict = new KrollDict(args);
		int objectId = argsDict.getInt("objectId");
		Boolean isFolder = argsDict.getBoolean("isFolder");
		String password = argsDict.getString("password");
		String[] emailAddresses = argsDict.getStringArray("emailAddresses");
		String message = argsDict.getString("message");
		
	    final KrollFunction success = (KrollFunction)args.get("success");
    	final KrollFunction error = (KrollFunction)args.get("error");
		
		final Box box = Box.getInstance(Constants.API_KEY);
	    box.publicShare(Constants.getAuthToken(), isFolder?"folder":"file", objectId, password, message, emailAddresses, new PublicShareListener() {
			
			@Override
			public void onIOException(IOException ex) {
				Util.handleIOException(proxy, ex, error);
			}
			
			@Override
			public void onComplete(String publicName, String status) {
				if (status.equals("share_ok")) {
					if (success != null)
						success.callAsync(proxy.getKrollObject(), new Object[] {});
				}
				else if (status.equals("wrong_node")) {
					Util.handleError(proxy, "We weren't able to find what you tried to share in your account!", status, error);
				}
				else if (status.equals("share_error")) {
					Util.handleError(proxy, "An error happened while we were sharing your file. Try again?", status, error);
				}
				else {
					Util.handleCommonStatuses(proxy, status, error);
				}
			}
		});
	}
}
