/**
 * Ti.Box Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

package ti.box.proxies;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.appcelerator.kroll.KrollProxy;
import org.appcelerator.kroll.annotations.Kroll;

import ti.box.Util;

import com.box.androidlib.DAO.BoxFile;
import com.box.androidlib.DAO.BoxFolder;

@Kroll.proxy
public class BoxFolderProxy extends KrollProxy {

	public BoxFolderProxy() {
		super();
	}

	private BoxFolder folder;
	private Object[] children;
	private int numFolders, numFiles;
	
	public void setBoxFolder(BoxFolder folder) {
		if (folder == null)
			throw new IllegalArgumentException();
		
		this.folder = folder;
		ArrayList<Object> children = new ArrayList<Object>();
		
		List<? extends BoxFolder> folders = folder.getFoldersInFolder();
		numFolders = folders.size();
		for (BoxFolder f : folders) {
			BoxFolderProxy wrapped = new BoxFolderProxy();
			wrapped.setBoxFolder(f);
			children.add(wrapped);
		}
		
		List<? extends BoxFile> files = folder.getFilesInFolder();
		numFiles = files.size();
		for (BoxFile f : files) {
			BoxFileProxy wrapped = new BoxFileProxy();
			wrapped.setBoxFile(f);
			children.add(wrapped);
		}
		
		this.children = children.toArray();
	}
	
	private String error;
	public void setError(String error) {
		this.error = error;
	}
	
	@Kroll.getProperty
	public String getError() {
		return this.error;
	}
	
	@Kroll.getProperty
	public Boolean getIsFolder() {
		return true;
	}
	
	@Kroll.getProperty
	public Boolean getIsFile() {
		return false;
	}
	
	@Kroll.getProperty
	public Object[] getObjectsInFolder() {
		return children;
	}
	
	@Kroll.getProperty
	public int getFileCount() {
		return numFiles;
	}
	
	@Kroll.getProperty
	public int getFolderCount() {
		return numFolders;
	}
	
	@Kroll.getProperty
	public Boolean getIsCollaborated() {
		Util.w("BoxFolder's \"isCollaborated\" property is not supported on Android!");
		return false;
	}

	@Kroll.getProperty
	public int getObjectId() {
		return Util.degrade(folder.getId());
	}

	@Kroll.getProperty
	public String getObjectName() {
		return folder.getFolderName();
	}

	@Kroll.getProperty
	public String getObjectDescription() {
		return folder.getDescription();
	}

	@Kroll.getProperty
	public int getParentFolderId() {
		return Util.degrade(folder.getParentFolderId());
	}

	@Kroll.getProperty
	public BoxFolderProxy getParentFolder() {
		BoxFolderProxy parent = new BoxFolderProxy();
		parent.setBoxFolder(folder.getParentFolder());
		return parent;
	}

	@Kroll.getProperty
	public String getUserId() {
		Util.w("BoxFolder's \"userId\" property is not supported on Android!");
		return "";
	}
	
	@Kroll.getProperty
	public Boolean getIsShared() {
		return folder.getShared();
	}

	@Kroll.getProperty
	public String getSharedLink() {
		return folder.getSharedLink();
	}

	@Kroll.getProperty
	public String getPermissions() {
		return folder.getPermissions();
	}

	@Kroll.getProperty
	public int getObjectSize() {
		return Util.degrade(folder.getSize());
	}

	@Kroll.getProperty
	public Date getObjectCreatedTime() {
		return new Date(folder.getCreated());
	}

	@Kroll.getProperty
	public Date getObjectUpdatedTime() {
		return new Date(folder.getUpdated());
	}
}
