/**
 * Ti.Box Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiBoxUpdate.h"

@implementation TiBoxUpdate

-(id)initWithBoxUpdate:(BoxUpdate *)update
{
    if ((self = [super init]))
    {
        _updateId = update.updateId;
        _userId = update.userId;
        _userName = update.userName;
        _userEmail = update.userEmail;
        _updateUpdatedTime = update.updateUpdatedTime;
        _folderId = update.folderId;
        _folderName = update.folderName;
        _isShared = NUMBOOL(update.isShared);
        _shareName = update.shareName;
        _ownerId = update.ownerId;
        _collabAccess = NUMBOOL(update.collabAccess);
        _updateType = NUMINT(update.updateType);
        _update = [BoxUpdate stringForBoxUpdateType:update.updateType];
        _folders = [[[NSMutableArray alloc] init] retain];
        _files = [[[NSMutableArray alloc] init] retain];
        for (BoxObject* obj in update.boxObjects) {
            if ([obj isKindOfClass:[BoxFolder class]]) {
                [_folders addObject: [[TiBoxFolder alloc] initWithBoxFolder: (BoxFolder*)obj]];
            }
            else if ([obj isKindOfClass:[BoxFile class]]) {
                [_files addObject: [[TiBoxFile alloc] initWithBoxFile: (BoxFile*)obj]];
            }
            else {
                NSLog(@"[ERROR] Got back unexpected type in BoxObjects!");
            }
        }
    }
    return self;
}

-(void)dealloc
{
	RELEASE_TO_NIL(_update);
	RELEASE_TO_NIL(_folders);
	RELEASE_TO_NIL(_files);
	[super dealloc];
}

@synthesize updateId = _updateId;
@synthesize userId = _userId;
@synthesize userName = _userName;
@synthesize userEmail = _userEmail;
@synthesize updateUpdatedTime = _updateUpdatedTime;
@synthesize folderId = _folderId;
@synthesize folderName = _folderName;
@synthesize isShared = _isShared;
@synthesize shareName = _shareName;
@synthesize ownerId = _ownerId;
@synthesize collabAccess = _collabAccess;
@synthesize updateType = _updateType;
@synthesize update = _update;
@synthesize folders = _folders;
@synthesize files = _files;

@end
