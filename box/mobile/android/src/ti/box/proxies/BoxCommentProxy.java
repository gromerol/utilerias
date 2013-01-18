/**
 * Ti.Box Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

package ti.box.proxies;

import java.util.Date;

import org.appcelerator.kroll.KrollProxy;
import org.appcelerator.kroll.annotations.Kroll;

import ti.box.Util;

import com.box.androidlib.DAO.Comment;

@Kroll.proxy
public class BoxCommentProxy extends KrollProxy {

	public BoxCommentProxy() {
		super();
	}

	private Comment obj;
	
	public void setComment(Comment obj) {
		this.obj = obj;
	}
	
	@Kroll.getProperty
	public int getCommentId() {
		return Util.degrade(obj.getId());
	}
	
	@Kroll.getProperty
	public String getMessage() {
		return obj.getMessage();
	}
	
	@Kroll.getProperty
	public Date getCreatedAt() {
		return new Date(obj.getCreated());
	}
	
	@Kroll.getProperty
	public String getUserName() {
		return obj.getFromUserName();
	}
	
	@Kroll.getProperty
	public int getUserId() {
		return Util.degrade(obj.getFromUserId());
	}
	
	@Kroll.getProperty
	public String getAvatarURL() {
		return obj.getAvatarURL();
	}
	
	@Kroll.getProperty
	public BoxCommentProxy[] getReplyComments() {
		Util.w("BoxComment's \"replyComments\" property is not supported on Android!");
		return new BoxCommentProxy[0];
	}
}
