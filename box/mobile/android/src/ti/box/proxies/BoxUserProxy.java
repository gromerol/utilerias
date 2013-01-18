/**
 * Ti.Box Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

package ti.box.proxies;

import org.appcelerator.kroll.KrollProxy;
import org.appcelerator.kroll.annotations.Kroll;
import ti.box.Util;

import com.box.androidlib.DAO.User;

@Kroll.proxy
public class BoxUserProxy extends KrollProxy {

	public BoxUserProxy() {
		super();
	}

	private User user;
	public void setBoxUser(User user) {
		this.user = user;
	}
	
	@Kroll.getProperty
	public String getAuthToken() {
		return user.getAuthToken();
	}
	
	@Kroll.getProperty
	public String getUserName() {
		return user.getLogin();
	}
	
	@Kroll.getProperty
	public String getEmail() {
		return user.getEmail();
	}
	
	@Kroll.getProperty
	public int getAccessId() {
		return Util.degrade(user.getAccessId());
	}
	
	@Kroll.getProperty
	public int getUserId() {
		return Util.degrade(user.getUserId());
	}
	
	@Kroll.getProperty
	public String getMaxUploadSize() {
		return "" + user.getMaxUploadSize();
	}
	
	@Kroll.getProperty
	public String getStorageQuota() {
		return "" + user.getSpaceAmount();
	}
	
	@Kroll.getProperty
	public String getStorageUsed() {
		return "" + user.getSpaceUsed();
	}
	
	@Kroll.getProperty
	public Boolean getLoggedIn() {
		return user != null;
	}
	
}
