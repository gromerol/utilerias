/**
 * Ti.Box Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiProxy.h"
#import "TiBoxFile.h"
#import "BoxFolder.h"
#import "BoxFile.h"

@interface TiBoxFolder : TiProxy {
    BoxFolder* folder;
    NSString* _error;
    NSMutableArray* inFolder;
    int files;
    int folders;
}
    
-(id)initWithBoxFolder:(BoxFolder*)value;
-(id)initWithError:(NSString*)value;

@property (readonly) NSString *error;

#pragma mark Folder Specific
@property (readonly) NSNumber *isFile;
@property (readonly) NSNumber *isFolder;
@property (readonly) NSMutableArray *objectsInFolder;
@property (readonly) NSNumber *fileCount;
@property (readonly) NSNumber *folderCount;
@property (readonly) NSMutableArray *collaborations;
@property (readonly) NSNumber *isCollaborated;

#pragma mark Generic to Objects
@property (readonly) NSNumber *objectId;
@property (readonly) NSString *objectName;
@property (readonly) NSString *objectDescription;
@property (readonly) NSString *userId;
@property (readonly) NSNumber *isShared;
@property (readonly) NSString *sharedLink;
@property (readonly) NSString *permissions;
@property (readonly) NSNumber *objectSize;
@property (readonly) NSDate *objectCreatedTime;
@property (readonly) NSDate *objectUpdatedTime;

@end