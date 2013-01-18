/**
 * Ti.Box Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiBoxFile.h"
#import "TiUtils.h"

@implementation TiBoxFile

-(id)initWithBoxFile:(BoxFile *)value
{
    if ((self = [super init]))
    {
        file = [value retain];
        _error = nil;
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

@synthesize error;
-(NSString*)error {
    return _error;
}

@synthesize isFolder;
-(NSNumber*)isFolder {
    return NUMBOOL(NO);
}

@synthesize isFile;
-(NSNumber*)isFile {
    return NUMBOOL(YES);
}

@synthesize smallThumbnailURL;
-(NSString*)smallThumbnailURL {
    return file.smallThumbnailURL;
}

@synthesize largeThumbnailURL;
-(NSString*)largeThumbnailURL {
    return file.largeThumbnailURL;
}

@synthesize largerThumbnailURL;
-(NSString*)largerThumbnailURL {
    return file.largerThumbnailURL;
}

@synthesize previewThumbnailURL;
-(NSString*)previewThumbnailURL {
    return file.previewThumbnailURL;
}

@synthesize sha1;
-(NSString*)sha1 {
    return file.sha1;
}

@synthesize objectId;
-(NSNumber*)objectId {
    return file.objectId;
}

@synthesize objectName;
-(NSString*)objectName {
    return file.objectName;
}

@synthesize objectDescription;
-(NSString*)objectDescription {
    return file.objectDescription;
}

@synthesize userId;
-(NSString*)userId {
    return file.userId;
}

@synthesize isShared;
-(NSNumber*)isShared {
    return NUMBOOL(file.isShared);
}

@synthesize sharedLink;
-(NSString*)sharedLink {
    return file.sharedLink;
}

@synthesize permissions;
-(NSString*)permissions {
    return file.permissions;
}

@synthesize objectSize;
-(NSNumber*)objectSize {
    return file.objectSize;
}

@synthesize objectCreatedTime;
-(NSDate*)objectCreatedTime {
    return file.objectCreatedTime;
}

@synthesize objectUpdatedTime;
-(NSDate*)objectUpdatedTime {
    return file.objectUpdatedTime;
}

@end