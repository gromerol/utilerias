/**
 * Ti.Box Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

package ti.box.calls;


import java.io.IOException;

import org.appcelerator.kroll.KrollProxy;
import org.appcelerator.titanium.util.TiConvert;

import ti.box.Constants;
import ti.box.Util;
import ti.box.proxies.BoxFolderProxy;
import com.box.androidlib.BoxSynchronous;
import com.box.androidlib.DAO.BoxFolder;
import com.box.androidlib.ResponseParsers.AccountTreeResponseParser;

public class RetrieveFolder {

	/**
	 * Prevents instantiation.
	 */
	private RetrieveFolder() {}
	
	public static BoxFolderProxy call(final KrollProxy proxy, Object[] args) {
		int id;
		if (args.length == 0) {
			id = 0;
		}
		else {
			id = TiConvert.toInt(args[0]);
		}
		
		BoxFolderProxy retVal = new BoxFolderProxy();
		BoxSynchronous box = BoxSynchronous.getInstance(Constants.API_KEY);

		try {
			AccountTreeResponseParser response = box.getAccountTree(Constants.getAuthToken(), id, new String[] { "onelevel", "nozip" });
			String status = response.getStatus();
			if (status.equals("listing_ok")) {
				BoxFolder folder = response.getFolder();
				if (folder == null) {
					retVal.setError("Failed to retrieve that folder from the server!");
				}
				else {
					retVal.setBoxFolder(folder);
				}
			}
			else if (status.equals("e_folder_id")) {
				retVal.setError("Please provide a valid folderId!");
			}
			else {
				retVal.setError(Util.handleCommonStatuses(proxy, status, null));
			}
		} catch (IOException e) {
			retVal.setError(Util.handleIOException(proxy, e, null));
		}
		
		return retVal;
	}
}
