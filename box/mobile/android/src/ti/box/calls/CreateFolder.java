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
import com.box.androidlib.DAO.BoxFolder;
import com.box.androidlib.ResponseListeners.CreateFolderListener;

public class CreateFolder {

	/**
	 * Prevents instantiation.
	 */
	private CreateFolder() {}
	
	public static void call(final KrollProxy proxy, HashMap args) {

		KrollDict argsDict = new KrollDict(args);
		String name = argsDict.getString("name");
		int parentFolderId = argsDict.getInt("parentFolderId");

	    final KrollFunction success = (KrollFunction)args.get("success");
    	final KrollFunction error = (KrollFunction)args.get("error");
		
		final Box box = Box.getInstance(Constants.API_KEY);
	    box.createFolder(Constants.getAuthToken(), parentFolderId, name, false, new CreateFolderListener() {
			
			@Override
			public void onIOException(IOException ex) {
				Util.handleIOException(proxy, ex, error);
			}
			
			@Override
			public void onComplete(BoxFolder folder, String status) {
				if (status.equals("create_ok")) {
					if (success != null)
						success.callAsync(proxy.getKrollObject(), new Object[] {});
				}
				else if (status.equals("no_parent")) {
					Util.handleError(proxy, "The folder_id provided is not a valid folder_id for the user's account.", status, error);
				}
				else if (status.equals("s_folder_exists")) {
					Util.handleError(proxy, "A folder with the same name already exists in that location.", status, error);
				}
				else if (status.equals("invalid_folder_name")) {
					Util.handleError(proxy, "The name provided for the new folder contained invalid characters or too many characters.", status, error);
				}
				else if (status.equals("e_no_folder_name")) {
					Util.handleError(proxy, "Please provide a folder name.", status, error);
				}
				else if (status.equals("folder_name_too_big")) {
					Util.handleError(proxy, "The folder name you specified was too long! Please shorten it, and try again.", status, error);
				}
				else if (status.equals("e_input_params")) {
					Util.handleError(proxy, "An error happened while we were creating your folder. Please try again.", status, error);
				}
				else {
					Util.handleCommonStatuses(proxy, status, error);
				}
			}
		});
	}
}
