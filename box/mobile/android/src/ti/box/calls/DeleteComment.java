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
import com.box.androidlib.ResponseListeners.DeleteCommentListener;

public class DeleteComment {

	/**
	 * Prevents instantiation.
	 */
	private DeleteComment() {}
	
	public static void call(final KrollProxy proxy, HashMap args) {

		KrollDict argsDict = new KrollDict(args);
		int commentId = argsDict.getInt("commentId");

	    final KrollFunction success = (KrollFunction)args.get("success");
    	final KrollFunction error = (KrollFunction)args.get("error");
		
		final Box box = Box.getInstance(Constants.API_KEY);
	    box.deleteComment(Constants.getAuthToken(), commentId, new DeleteCommentListener() {
			
			@Override
			public void onIOException(IOException ex) {
				Util.handleIOException(proxy, ex, error);
			}
			
			@Override
			public void onComplete(String status) {
				if (status.equals("delete_comment_ok")) {
					if (success != null)
						success.callAsync(proxy.getKrollObject(), new Object[] {});
				}
				else if (status.equals("delete_comment_error")) {
					Util.handleError(proxy, "An error happened while we were deleting the comment. Try again?", status, error);
				}
				else {
					Util.handleCommonStatuses(proxy, status, error);
				}
			}
		});
	}
}
