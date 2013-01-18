# Ti.Box.Folder

## Description

Represents a folder.

## Properties

## Folder Specific Properties

### string error 
If the folder cannot be retrieved, this property will be set to an error message describing why.

### bool isFile [always false]
### bool isFolder [always true]
### [array of [Ti.Box.Folder][] and [Ti.Box.File][]] objectsInFolder
### int fileCount 
### int folderCount 
### bool isCollaborated [iOS only]

## Generic Properties of Folders and Files

### int objectId
### int parentFolderId [Android only]
### [Ti.Box.Folder][] parentFolder [Android only]
### string objectName
### string objectDescription
### string userId [iOS only]
### bool isShared
### string sharedLink
### string permissions
### int objectSize
### date objectCreatedTime
### date objectUpdatedTime

[Ti.Box.Folder]: folder.html
[Ti.Box.File]: file.html