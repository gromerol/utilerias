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
import org.appcelerator.titanium.io.TiBaseFile;
import org.appcelerator.titanium.io.TiFileFactory;
import ti.box.Constants;
import ti.box.Util;

import com.box.androidlib.Box;
import com.box.androidlib.ResponseListeners.FileDownloadListener;

public class Download {

	/**
	 * Prevents instantiation.
	 */
	private Download() {}
	
	public static void call(final KrollProxy proxy, HashMap args) {

		KrollDict argsDict = new KrollDict(args);
		int objectId = argsDict.getInt("objectId");
		String fileURL = argsDict.getString("fileURL");
		TiBaseFile file = TiFileFactory.createTitaniumFile(fileURL, false);
		
	    final KrollFunction success = (KrollFunction)args.get("success");
    	final KrollFunction error = (KrollFunction)args.get("error");
		
		final Box box = Box.getInstance(Constants.API_KEY);
		box.download(Constants.getAuthToken(), objectId, file.getNativeFile(), null, new FileDownloadListener() {

			@Override
			public void onIOException(IOException e) {
				Util.handleIOException(proxy, e, error);
			}
			
			@Override
			public void onProgress(long percent) {
				// TODO We won't do anything with this quite yet. We can expose it in the future, though!
			}

			@Override
			public void onComplete(String status) {
				if (status.equals("download_ok"))
					if (success != null)
						success.callAsync(proxy.getKrollObject(), new Object[] {});
				if (status.equals("wrong auth token"))
					Util.handleError(proxy, "Your token has expired; please login again!", status, error);
				else if (status.equals("restricted"))
					Util.handleError(proxy, "You cannot access that file!", status, error);
				else
					Util.handleCommonStatuses(proxy, status, error);
			}
		});
	}
}
