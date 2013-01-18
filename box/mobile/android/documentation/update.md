# Ti.Box.Update

## Description

Folder and file updates are represented by this class, which stores information about the user who caused the update,
the update time, and the item that was updated.

## Properties

### int updateId
### int userId
### string userName
### string userEmail
### date updateUpdatedTime
### int folderId
### string folderName
### bool isShared
### string shareName
### int ownerId
### bool collabAccess
### int updateType
### string update
### [Ti.Box.File][][] files [Android only]
### [Ti.Box.Folder][][] folders [Android only]

Note: update type corresponds to the following values:
* Ti.Box.UPDATE_TYPE_SENT,
* Ti.Box.UPDATE_TYPE_DOWNLOADED,
* Ti.Box.UPDATE_TYPE_COMMENTEDON,
* Ti.Box.UPDATE_TYPE_MOVED,
* Ti.Box.UPDATE_TYPE_UPDATED,
* Ti.Box.UPDATE_TYPE_ADDED,
* Ti.Box.UPDATE_TYPE_PREVIEWED,
* Ti.Box.UPDATE_TYPE_DOWNLOADEDANDPREVIEWED,
* Ti.Box.UPDATE_TYPE_COPIED,
* Ti.Box.UPDATE_TYPE_LOCKED,
* Ti.Box.UPDATE_TYPE_UNLOCKED,
* Ti.Box.UPDATE_TYPE_ASSIGNEDTASK,
* Ti.Box.UPDATE_TYPE_RESPONDEDTOTASK

[Ti.Box.Folder]: folder.html
[Ti.Box.File]: file.html