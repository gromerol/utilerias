# Ti.Box Module

## Description

Box simplifies online file storage, replaces FTP and connects teams in online workspaces.

Note that your application must have a unique Box API key. To retrieve this key, go to:

https://www.box.net/developers/services

and click "Create New Application". After that is completed, an API key will be assigned to your application. Store it
in the _Ti.Box.apiKey_ property.

## Getting Started

View the [Using Titanium Modules](http://docs.appcelerator.com/titanium/latest/#!/guide/Using_Titanium_Modules) document for instructions on getting
started with using this module in your application.

## Accessing the Ti.Box Module

To access this module from JavaScript, you would do the following:

	var Box = require('ti.box');


## Methods


## Login and Registration Methods

### void login(args)
Using the provided webview, asks the user to log in to their Box.net account. Args is a dictionary with the following:

* [Ti.Box.LoginView][] view [required]: The Ti.Box.LoginView Box.net will use to log the user in. Note that you MUST show this view to the user yourself! Add it to a window, show it in a modal popup, etc. The choice belongs to you.
* function success(): A callback to be executed when the user successfully logs in.
* function error(evt { error[string] }): A callback to be executed when the log in fails.

### void logout()
Logs the current user out.

### void registerUser(args)
Attempts to register a user. If successful, the user will be logged in. Args is a dictionary with the following:

* string username [required]:
* string password [required]:
* function success(): A callback to be executed after a successful registration.
* function error(evt { error[string] }): A callback to be executed after an unsuccessful registration.


## Uploading and Downloading Methods

### [Ti.Box.Folder][] retrieveFolder(int optionalId)
Retrieves the [Ti.Box.Folder][] with the optionally specified Id. If you do not specify an Id, the top level folder is
retrieved.

### void download(args)
Downloads the specified item to the specified file URL. Args is a dictionary with the following:

* int objectId [required]: The Id of the file you want to download
* string fileURL [required]: The URL to where you would like the file to be downloaded.
* function success(): A callback to be executed after a successful download.
* function error(evt { error[string] }): A callback to be executed after an unsuccessful download.

### void upload(args)
Uploads a file to Box.net for the logged in user. Args is a dictionary with the following:

* int parentId: The Id of the folder this should be upload to (or leave this blank to upload to the root folder)
* string fileURL [required]: The URL to the file you would like to upload.
* function success(): A callback to be executed after a successful operation.
* function error(evt { error[string] }): A callback to be executed after an unsuccessful operation.


## File and Folder Manipulation Methods

### void move(args)
Moves a file or folder to another folder. Args is a dictionary with the following:

* int objectId: The Id of the file or folder.
* bool isFolder: Whether or not the object is a folder.
* int destinationFolderId: The folder's objectId to which you want to move.
* function success(): A callback to be executed after a successful operation.
* function error(evt { error[string] }): A callback to be executed after an unsuccessful operation.

### void copy(args)
Copies a file or folder to another folder. Args is a dictionary with the following:

* int objectId: The Id of the file or folder.
* bool isFolder: Whether or not the object is a folder.
* int destinationFolderId: The folder's objectId to which you want to copy.
* function success(): A callback to be executed after a successful operation.
* function error(evt { error[string] }): A callback to be executed after an unsuccessful operation.

### void rename(args)
Renames a file or folder. Args is a dictionary with the following:

* int objectId: The Id of the file or folder.
* bool isFolder: Whether or not the object is a folder.
* string newName: The new name for your object.
* function success(): A callback to be executed after a successful operation.
* function error(evt { error[string] }): A callback to be executed after an unsuccessful operation.

### void remove(args)
Deletes a file or folder. Args is a dictionary with the following:

* int objectId: The Id of the file or folder.
* bool isFolder: Whether or not the object is a folder.
* function success(): A callback to be executed after a successful operation.
* function error(evt { error[string] }): A callback to be executed after an unsuccessful operation.

### void createFolder(args)
Creates a new folder in the specified parent folder. Args is a dictionary with the following:

* string name: The name of your new folder.
* int parentFolderId: The parent folder in which your folder will be created. Leave blank to specify the top level directory.
* function success(): A callback to be executed after a successful operation.
* function error(evt { error[string] }): A callback to be executed after an unsuccessful operation.


## Sharing Methods

### void publicShare(args)
Share publicly. Args is a dictionary with the following:

* int objectId: The Id of the file or folder.
* bool isFolder: Whether or not the object is a folder.
* string password [optional]: The password that users will need to specify to access the file or folder.
* string[] emailAddresses: An array of the people that should be contacted about the shared file or folder.
* string message: The message to use in the email.
* function success(): A callback to be executed after a successful operation.
* function error(evt { error[string] }): A callback to be executed after an unsuccessful operation.

### void privateShare(args)
Share privately. Args is a dictionary with the following:

* int objectId: The Id of the file or folder.
* bool isFolder: Whether or not the object is a folder.
* string[] emailAddresses: An array of the people that should be contacted about the shared file or folder.
* string message: The message to use in the email.
* bool notifyWhenViewed: Controls if you receive notifications when the file or folder is viewed.
* function success(): A callback to be executed after a successful operation.
* function error(evt { error[string] }): A callback to be executed after an unsuccessful operation.

### void publicUnshare(args)
Reverses the action of "publicShare". Args is a dictionary with the following:

* int objectId: The Id of the file or folder.
* bool isFolder: Whether or not the object is a folder.
* function success(): A callback to be executed after a successful operation.
* function error(evt { error[string] }): A callback to be executed after an unsuccessful operation.


## Comments Methods

### void getComments(args)
Gets the comments for the specified object. Args is a dictionary with the following:

* int objectId: The Id of the file or folder.
* bool isFolder: Whether or not the object is a folder.
* function success(evt { comments[[Ti.Box.Comment][][]] }): A callback to be executed after a successful operation.
* function error(evt { error[string] }): A callback to be executed after an unsuccessful operation.

### void addComment(args)
Adds a comment to the object. Args is a dictionary with the following:

* int objectId: The Id of the file or folder.
* bool isFolder: Whether or not the object is a folder.
* string message: The comment that you wish to make.
* function success(): A callback to be executed after a successful operation. You will probably want to refresh your list of comments by calling "getComments" so that the new comment is displayed.
* function error(evt { error[string] }): A callback to be executed after an unsuccessful operation.

### void deleteComment(args)
Deletes a comment. Args is a dictionary with the following:

* int commentId: The Id of the comment.
* function success(): A callback to be executed after a successful operation.
* function error(evt { error[string] }): A callback to be executed after an unsuccessful operation.


## Updates Methods

### void getUpdates(args)
Deletes a comment. Args is a dictionary with the following:

* date sinceTime: The time of the last update, specified as a JavaScript [Date][] object.
* function success(evt { updates[[Ti.Box.Update][][]] }): A callback to be executed after a successful operation.
* function error(evt { error[string] }): A callback to be executed after an unsuccessful operation.


## Properties

### [Ti.Box.User][] user [read-only]
The currently logged in [Ti.Box.User][].

### string apiKey
The API Key for your application, which can be retrieved from https://www.box.net/developers/services


## Constants

### Ti.Box.UPDATE_TYPE_SENT
### Ti.Box.UPDATE_TYPE_DOWNLOADED
### Ti.Box.UPDATE_TYPE_COMMENTEDON
### Ti.Box.UPDATE_TYPE_MOVED
### Ti.Box.UPDATE_TYPE_UPDATED
### Ti.Box.UPDATE_TYPE_ADDED
### Ti.Box.UPDATE_TYPE_PREVIEWED
### Ti.Box.UPDATE_TYPE_DOWNLOADEDANDPREVIEWED
### Ti.Box.UPDATE_TYPE_COPIED
### Ti.Box.UPDATE_TYPE_LOCKED
### Ti.Box.UPDATE_TYPE_UNLOCKED
### Ti.Box.UPDATE_TYPE_ASSIGNEDTASK
### Ti.Box.UPDATE_TYPE_RESPONDEDTOTASK


## Usage
See example.


## Author

Dawson Toth

## Module History

View the [change log](changelog.html) for this module.

## Feedback and Support

Please direct all questions, feedback, and concerns to [info@appcelerator.com](mailto:info@appcelerator.com?subject=Android%20Box%20Module).

## License
Copyright(c) 2010-2013 by Appcelerator, Inc. All Rights Reserved. Please see the LICENSE file included in the distribution for further details.


[Ti.Box.User]: user.html
[Ti.Box.Comment]: comment.html
[Ti.Box.Update]: update.html
[Ti.Box.Folder]: folder.html
[Ti.UI.WebView]: http://developer.appcelerator.com/apidoc/mobile/latest/Titanium.UI.WebView-object
[Ti.Box.LoginView]: loginview.html
[Date]: http://www.w3schools.com/jsref/jsref_obj_date.asp