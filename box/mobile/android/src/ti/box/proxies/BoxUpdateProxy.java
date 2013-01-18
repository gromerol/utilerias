/**
 * Ti.Box Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

package ti.box.proxies;

import java.util.ArrayList;
import java.util.Date;

import org.appcelerator.kroll.KrollProxy;
import org.appcelerator.kroll.annotations.Kroll;

import ti.box.BoxModule;
import ti.box.Util;

import com.box.androidlib.DAO.BoxFile;
import com.box.androidlib.DAO.BoxFolder;
import com.box.androidlib.DAO.Update;

@Kroll.proxy
public class BoxUpdateProxy extends KrollProxy {

	public BoxUpdateProxy( ) {
		super();
	}

	private Update obj;
	public void setUpdate(Update obj) {
		this.obj = obj;
	}
	
	@Kroll.getProperty
	public int getUpdateId() {
		return Util.degrade(obj.getUpdated());
	}
	
	@Kroll.getProperty
	public int getUserId() {
		return Util.degrade(obj.getUserId());
	}
	
	@Kroll.getProperty
	public String getUserName() {
		return obj.getUserName();
	}
	
	@Kroll.getProperty
	public String getUserEmail() {
		return obj.getUserEmail();
	}
	
	@Kroll.getProperty
	public Date getUpdateUpdatedTime() {
		return new Date(obj.getUpdated());
	}
	
	@Kroll.getProperty
	public int getFolderId() {
		return Util.degrade(obj.getFolderId());
	}
	
	@Kroll.getProperty
	public String getFolderName() {
		return obj.getFolderName();
	}
	
	@Kroll.getProperty
	public Boolean getIsShared() {
		return obj.getSharedName() != null;
	}
	
	@Kroll.getProperty
	public String getSharedName() {
		return obj.getSharedName();
	}
	
	@Kroll.getProperty
	public int getOwnerId() {
		return Util.degrade(obj.getOwnerId());
	}
	
	@Kroll.getProperty
	public Boolean getCollabAccess() {
		return obj.isCollabAccess();
	}

	@Kroll.getProperty
	public Object[] getFolders() {
		ArrayList<BoxFolderProxy> children = new ArrayList<BoxFolderProxy>();
		ArrayList<BoxFolder> folders = obj.getFolders();
		for (BoxFolder f : folders) {
			BoxFolderProxy wrapped = new BoxFolderProxy();
			wrapped.setBoxFolder(f);
			children.add(wrapped);
		}
		return children.toArray();
	}

	@Kroll.getProperty
	public Object[] getFiles() {
		ArrayList<BoxFileProxy> children = new ArrayList<BoxFileProxy>();
		ArrayList<BoxFile> files = obj.getFiles();
		for (BoxFile f : files) {
			BoxFileProxy wrapped = new BoxFileProxy();
			wrapped.setBoxFile(f);
			children.add(wrapped);
		}
		return children.toArray();
	}
	
	@Kroll.getProperty
	public int getUpdateType() {
		String type = obj.getUpdateType();
		if (type.equals("sent")) {
			return BoxModule.UPDATE_TYPE_SENT;
		} else if(type.equals("downloaded")) {
			return BoxModule.UPDATE_TYPE_DOWNLOADED;
		} else if(type.equals("commented on")) {
			return BoxModule.UPDATE_TYPE_COMMENTEDON;
		} else if(type.equals("moved")) {
			return BoxModule.UPDATE_TYPE_MOVED;
		} else if(type.equals("updated")) {
			return BoxModule.UPDATE_TYPE_UPDATED;
		} else if(type.equals("added")) {
			return BoxModule.UPDATE_TYPE_ADDED;
		} else if(type.equals("previewed")) {
			return BoxModule.UPDATE_TYPE_PREVIEWED;
		} else if(type.equals("downloaded and previewed")) {
			return BoxModule.UPDATE_TYPE_DOWNLOADEDANDPREVIEWED;	
		} else if(type.equals("copied")) {
			return BoxModule.UPDATE_TYPE_COPIED;
		} else if(type.equals("locked")) {
			return BoxModule.UPDATE_TYPE_LOCKED;
		} else if(type.equals("unlocked")) {
			return BoxModule.UPDATE_TYPE_UNLOCKED;
		} else if(type.equals("assigned task")) {
			return BoxModule.UPDATE_TYPE_ASSIGNEDTASK;
		} else if(type.equals("responded to task")) {
			return BoxModule.UPDATE_TYPE_RESPONDEDTOTASK;
		}
		return 0;
	}
	
	@Kroll.getProperty
	public String getUpdate() {
		return obj.getUpdateType();
	}
}
