/**
 * Ti.Box Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

package ti.box.calls;


import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;

import org.appcelerator.kroll.KrollDict;
import org.appcelerator.kroll.KrollFunction;
import org.appcelerator.kroll.KrollProxy;
import ti.box.Constants;
import ti.box.Util;
import ti.box.proxies.BoxCommentProxy;

import com.box.androidlib.Box;
import com.box.androidlib.DAO.Comment;
import com.box.androidlib.ResponseListeners.GetCommentsListener;

public class GetComments {

	/**
	 * Prevents instantiation.
	 */
	private GetComments() {}
	
	public static void call(final KrollProxy proxy, HashMap args) {

		KrollDict argsDict = new KrollDict(args);
		int objectId = argsDict.getInt("objectId");
		Boolean isFolder = argsDict.getBoolean("isFolder");
		
	    final KrollFunction success = (KrollFunction)args.get("success");
    	final KrollFunction error = (KrollFunction)args.get("error");
		
		final Box box = Box.getInstance(Constants.API_KEY);
	    box.getComments(Constants.getAuthToken(), isFolder?"folder":"file", objectId, new GetCommentsListener() {
			
			@Override
			public void onIOException(IOException ex) {
				Util.handleIOException(proxy, ex, error);
			}
			
			@Override
			public void onComplete(ArrayList<Comment> comments, String status) {
				if (status.equals("get_comments_ok")) {
					if (success != null) {
						HashMap retVal = new HashMap();
						ArrayList<BoxCommentProxy> commentsProxy = new ArrayList<BoxCommentProxy>();
						for (Comment comment : comments) {
							BoxCommentProxy commentProxy = new BoxCommentProxy();
							commentProxy.setComment(comment);
							commentsProxy.add(commentProxy);
						}
						retVal.put("comments", commentsProxy.toArray());
						success.callAsync(proxy.getKrollObject(), retVal);
					}
				}
				else if (status.equals("get_comments_error")) {
					Util.handleError(proxy, "An error happened while we were retrieving the comments. Try again?", status, error);
				}
				else {
					Util.handleCommonStatuses(proxy, status, error);
				}
			}
		});
	}
}
