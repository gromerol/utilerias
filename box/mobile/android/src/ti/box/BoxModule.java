/**
 * Ti.Box Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

package ti.box;

import org.appcelerator.kroll.KrollModule;
import org.appcelerator.kroll.annotations.Kroll;

import ti.box.calls.AddComment;
import ti.box.calls.Copy;
import ti.box.calls.CreateFolder;
import ti.box.calls.DeleteComment;
import ti.box.calls.Download;
import ti.box.calls.GetComments;
import ti.box.calls.GetUpdates;
import ti.box.calls.GetUser;
import ti.box.calls.Login;
import ti.box.calls.Logout;
import ti.box.calls.Move;
import ti.box.calls.PrivateShare;
import ti.box.calls.PublicShare;
import ti.box.calls.PublicUnshare;
import ti.box.calls.RegisterUser;
import ti.box.calls.Remove;
import ti.box.calls.Rename;
import ti.box.calls.RetrieveFolder;
import ti.box.calls.Upload;
import ti.box.proxies.BoxFolderProxy;
import ti.box.proxies.BoxUserProxy;

import java.util.HashMap;

@Kroll.module(name="Box", id="ti.box")
public class BoxModule extends KrollModule
{
	public BoxModule() {
		super();
	}

    //
	// Login and Registration Methods
	//
	@Kroll.method
	public void login(HashMap args) {
		Login.call(this, args);
	}

	
	@Kroll.method
	public void logout() {
		Logout.call(this);
	}
	
	@Kroll.method
	public void registerUser(HashMap args) {
		RegisterUser.call(this, args);
	}

	//
	// Uploading and Downloading Methods
	//
	@Kroll.method
	public BoxFolderProxy retrieveFolder(Object[] args) {
		return RetrieveFolder.call(this, args);
	}
	
	@Kroll.method
	public void download(HashMap args) {
		Download.call(this, args);
	}
	
	@Kroll.method
	public void upload(HashMap args) {
		Upload.call(this, args);
	}

	//
	// File and Folder Manipulation Methods
	//
	@Kroll.method
	public void move(HashMap args) {
		Move.call(this, args);
	}
	@Kroll.method
	public void copy(HashMap args) {
		Copy.call(this, args);
	}
	@Kroll.method
	public void rename(HashMap args) {
		Rename.call(this, args);
	}
	@Kroll.method
	public void remove(HashMap args) {
		Remove.call(this, args);
	}
	@Kroll.method
	public void createFolder(HashMap args) {
		CreateFolder.call(this, args);
	}

    //
    // Sharing Methods
    //
	@Kroll.method
	public void publicShare(HashMap args) {
		PublicShare.call(this, args);
	}
	@Kroll.method
	public void privateShare(HashMap args) {
		PrivateShare.call(this, args);
	}
	@Kroll.method
	public void publicUnshare(HashMap args) {
		PublicUnshare.call(this, args);
	}

	//
	// Comments Methods
	//
	@Kroll.method
	public void getComments(HashMap args) {
		GetComments.call(this, args);
	}
	@Kroll.method
	public void addComment(HashMap args) {
		AddComment.call(this, args);
	}
	@Kroll.method
	public void deleteComment(HashMap args) {
		DeleteComment.call(this, args);
	}

	//
	// Updates Methods
	//
	@Kroll.method
	public void getUpdates(HashMap args) {
		GetUpdates.call(this, args);
	}

	//
	// Properties
	//
	@Kroll.getProperty
	public BoxUserProxy getUser() {
		return GetUser.call(this);
	}
	
	@Kroll.getProperty
	public String getApiKey() {
		return Constants.API_KEY;
	}
	
    @Kroll.setProperty
	public void setApiKey(String value) {
	    Constants.API_KEY = value;
	}

	//
	// Constants
	//
    @Kroll.constant public static final int UPDATE_TYPE_SENT = 1;
	@Kroll.constant public static final int UPDATE_TYPE_DOWNLOADED = 2;
	@Kroll.constant public static final int UPDATE_TYPE_COMMENTEDON = 3;
	@Kroll.constant public static final int UPDATE_TYPE_MOVED = 4;
	@Kroll.constant public static final int UPDATE_TYPE_UPDATED = 5;
	@Kroll.constant public static final int UPDATE_TYPE_ADDED = 6;
	@Kroll.constant public static final int UPDATE_TYPE_PREVIEWED = 7;
	@Kroll.constant public static final int UPDATE_TYPE_DOWNLOADEDANDPREVIEWED = 8;
	@Kroll.constant public static final int UPDATE_TYPE_COPIED = 9;
	@Kroll.constant public static final int UPDATE_TYPE_LOCKED = 10;
	@Kroll.constant public static final int UPDATE_TYPE_UNLOCKED = 11;
	@Kroll.constant public static final int UPDATE_TYPE_ASSIGNEDTASK = 12;
	@Kroll.constant public static final int UPDATE_TYPE_RESPONDEDTOTASK = 13;

}
