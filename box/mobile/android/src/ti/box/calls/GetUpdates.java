/**
 * Ti.Box Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

package ti.box.calls;


import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;

import org.appcelerator.kroll.KrollDict;
import org.appcelerator.kroll.KrollFunction;
import org.appcelerator.kroll.KrollProxy;
import ti.box.Constants;
import ti.box.Util;
import ti.box.proxies.BoxUpdateProxy;

import com.box.androidlib.Box;
import com.box.androidlib.DAO.Update;
import com.box.androidlib.ResponseListeners.GetUpdatesListener;

public class GetUpdates {

	/**
	 * Prevents instantiation.
	 */
	private GetUpdates() {}
	
	public static void call(final KrollProxy proxy, HashMap args) {
		
		KrollDict argsDict = new KrollDict(args);
		Date sinceTime = (Date) argsDict.get("sinceTime");

	    final KrollFunction success = (KrollFunction)args.get("success");
    	final KrollFunction error = (KrollFunction)args.get("error");
		
		final Box box = Box.getInstance(Constants.API_KEY);
	    box.getUpdates(Constants.getAuthToken(), sinceTime.getTime() / 1000, new Date().getTime() / 1000, new String[] { }, new GetUpdatesListener() {
			
			@Override
			public void onIOException(IOException ex) {
				Util.handleIOException(proxy, ex, error);
			}
			
			@Override
			public void onComplete(ArrayList<Update> updates, String status) {
				if (status.equals("s_get_updates")) {
					if (success != null) {
						HashMap retVal = new HashMap();
						ArrayList<BoxUpdateProxy> proxies = new ArrayList<BoxUpdateProxy>();
						for (Update update : updates) {
							BoxUpdateProxy proxy = new BoxUpdateProxy();
							proxy.setUpdate(update);
							proxies.add(proxy);
						}
						retVal.put("updates", proxies.toArray());
						success.callAsync(proxy.getKrollObject(), retVal);
					}
				}
				else if (status.equals("e_invalid_timestamp")) {
					Util.handleError(proxy, "You specified an invalid time.", status, error);
				}
				else {
					Util.handleCommonStatuses(proxy, status, error);
				}
			}
		});
	}
}
