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

import com.box.androidlib.DAO.BoxFile;

@Kroll.proxy
public class BoxFileProxy extends KrollProxy {

	public BoxFileProxy() {
		super();
	}

	private BoxFile file;
	public void setBoxFile(BoxFile file) {
		this.file = file;
	}

	@Kroll.getProperty
	public Boolean getIsFolder() {
		return false;
	}
	
	@Kroll.getProperty
	public Boolean getIsFile() {
		return true;
	}

	@Kroll.getProperty
	public String getSmallThumbnailURL() {
		return file.getSmallThumbnail();
	}

	@Kroll.getProperty
	public String getLargeThumbnailURL() {
		return file.getLargerThumbnail();
	}

	@Kroll.getProperty
	public String getLargerThumbnailURL() {
		return file.getLargerThumbnail();
	}

	@Kroll.getProperty
	public String getPreviewThumbnailURL() {
		return file.getPreviewThumbnail();
	}
	
	@Kroll.getProperty
	public String getSha1() {
		return file.getSha1();
	}
	
	@Kroll.getProperty
	public int getObjectId() {
		return Util.degrade(file.getId());
	}

	@Kroll.getProperty
	public String getObjectName() {
		return file.getFileName();
	}

	@Kroll.getProperty
	public String getObjectDescription() {
		return file.getDescription();
	}

	@Kroll.getProperty
	public int getParentFolderId() {
		return Util.degrade(file.getFolderId());
	}

	@Kroll.getProperty
	public String getUserId() {
		Util.w("BoxFile's \"userId\" property is not supported on Android!");
		return "";
	}
	
	@Kroll.getProperty
	public Boolean getIsShared() {
		return file.getShared();
	}

	@Kroll.getProperty
	public String getSharedLink() {
		Util.w("BoxFile's \"sharedLink\" property is not supported on Android!");
		return "";
	}

	@Kroll.getProperty
	public String getPermissions() {
		return file.getPermissions();
	}

	@Kroll.getProperty
	public int getObjectSize() {
		return Util.degrade(file.getSize());
	}

	@Kroll.getProperty
	public Date getObjectCreatedTime() {
		return new Date(file.getCreated());
	}

	@Kroll.getProperty
	public Date getObjectUpdatedTime() {
		return new Date(file.getUpdated());
	}
}
