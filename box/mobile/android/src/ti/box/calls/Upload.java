/**
 * Ti.Box Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

package ti.box.calls;


import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.MalformedURLException;
import java.util.HashMap;

import org.appcelerator.kroll.KrollDict;
import org.appcelerator.titanium.io.TiBaseFile;
import org.appcelerator.titanium.io.TiFileFactory;
import org.appcelerator.kroll.KrollFunction;
import org.appcelerator.kroll.KrollProxy;
import ti.box.Constants;
import ti.box.Util;

import com.box.androidlib.Box;
import com.box.androidlib.DAO.BoxFile;
import com.box.androidlib.ResponseListeners.FileUploadListener;

public class Upload {

	/**
	 * Prevents instantiation.
	 */
	private Upload() {}
	
	public static void call(final KrollProxy proxy, HashMap args) {
		KrollDict argsDict = new KrollDict(args);
		int parentId = argsDict.getInt("parentId");
		String fileURL = argsDict.getString("fileURL");
		TiBaseFile tiFile = TiFileFactory.createTitaniumFile(fileURL, false);
		File file = tiFile.getNativeFile();
		
	    final KrollFunction success = (KrollFunction)args.get("success");
    	final KrollFunction error = (KrollFunction)args.get("error");
		
		final Box box = Box.getInstance(Constants.API_KEY);
		box.upload(Constants.getAuthToken(), Box.UPLOAD_ACTION_UPLOAD, file, file.getName(), parentId, new FileUploadListener() {

			@Override
			public void onIOException(IOException e) {
				Util.handleIOException(proxy, e, error);
			}
			
			@Override
			public void onMalformedURLException(MalformedURLException e) {
				Util.handleMalformedURLException(proxy, e, error);
			}

			@Override
			public void onFileNotFoundException(FileNotFoundException ex) {
				Util.handleError(proxy, "The file you specified could not be found!", "file_not_found", error);
			}

			@Override
			public void onProgress(long bytesTransferredCumulative) {
				// TODO We can expose this in the future
			}
			
			@Override
			public void onComplete(BoxFile file, String status) {
				if (status.equals("upload_ok"))
					if (success != null)
						success.callAsync(proxy.getKrollObject(), new Object[] {});
				else if (status.equals("upload_some_files_failed"))
					Util.handleError(proxy, "Some of the files were not successfully uploaded.", status, error);
				else if (status.equals("not_enough_free_space"))
					Util.handleError(proxy, "There is not enough space in this user's account to accommodate the new files.", status, error);
				else if (status.equals("filesize_limit_exceeded"))
					Util.handleError(proxy, "A file is too large to be uploaded to a user's account (Lite users have a 25 MB upload limit per file, premium users have a 1 GB limit per file).", status, error);
				else if (status.equals("access_denied"))
					Util.handleError(proxy, "The user does not have uploading privileges for that particular folder.", status, error);
				else if (status.equals("upload_wrong_folder_id"))
					Util.handleError(proxy, "The specified folder_id is not valid.", status, error);
				else if (status.equals("upload_invalid_file_name"))
					Util.handleError(proxy, "The name of the file contains invalid characters not accepted by Box.net.", status, error);
				else 
					Util.handleCommonStatuses(proxy, status, error);
			}
		});
	}
}
