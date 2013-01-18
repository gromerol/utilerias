/**
 * Ti.Box Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiBoxFolder.h"
#import "TiUtils.h"

@implementation TiBoxFolder

-(id)initWithBoxFolder:(BoxFolder *)value
{
    if ((self = [super init]))
    {
        folder = [value retain];
        _error = nil;
        inFolder = [[[NSMutableArray alloc] init] retain];
        for (BoxObject* obj in folder.objectsInFolder) {
            if ([obj isKindOfClass:[BoxFolder class]]) {
                [inFolder addObject: [[TiBoxFolder alloc] initWithBoxFolder: (BoxFolder*)obj]];
                folders += 1;
            }
            else {
                [inFolder addObject: [[TiBoxFile alloc] initWithBoxFile: (BoxFile*)obj]];
                files += 1;
            }
        }
    }
    return self;
}
-(id)initWithError:(NSString *)value
{
    if ((self = [super init]))
    {
        _error = value;
    }
    return self;
}

@synthesize isFolder;
-(NSNumber*)isFolder {
    return NUMBOOL(YES);
}

@synthesize isFile;
-(NSNumber*)isFile {
    return NUMBOOL(NO);
}

@synthesize error;
-(NSString*)error {
    return _error;
}

@synthesize objectsInFolder;
-(NSMutableArray*)objectsInFolder {
    return inFolder;
}

@synthesize fileCount;
-(NSNumber*)fileCount {
    return [NSNumber numberWithInt:files];
}

@synthesize folderCount;
-(NSNumber*)folderCount {
    return [NSNumber numberWithInt:folders];
}

@synthesize collaborations;
-(NSMutableArray*)collaborations {
    return folder.collaborations;
}

@synthesize isCollaborated;
-(NSNumber*)isCollaborated {
    return NUMBOOL(folder.isCollaborated);
}

@synthesize objectId;
-(NSNumber*)objectId {
    return folder.objectId;
}

@synthesize objectName;
-(NSString*)objectName {
    return folder.objectName;
}

@synthesize objectDescription;
-(NSString*)objectDescription {
    return folder.objectDescription;
}

@synthesize userId;
-(NSString*)userId {
    return folder.userId;
}

@synthesize isShared;
-(NSNumber*)isShared {
    return NUMBOOL(folder.isShared);
}

@synthesize sharedLink;
-(NSString*)sharedLink {
    return folder.sharedLink;
}

@synthesize permissions;
-(NSString*)permissions {
    return folder.permissions;
}

@synthesize objectSize;
-(NSNumber*)objectSize {
    return folder.objectSize;
}

@synthesize objectCreatedTime;
-(NSDate*)objectCreatedTime {
    return folder.objectCreatedTime;
}

@synthesize objectUpdatedTime;
-(NSDate*)objectUpdatedTime {
    return folder.objectUpdatedTime;
}

@end
