/**
 * Ti.Box Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiProxy.h"
#import "BoxFile.h"

@interface TiBoxFile : TiProxy {
    BoxFile* file;
    NSString* _error;
}

-(id)initWithBoxFile:(BoxFile*)value;
-(id)initWithError:(NSString*)value;

@property (readonly) NSString *error;

#pragma mark File Specific
@property (readonly) NSNumber *isFile;
@property (readonly) NSNumber *isFolder;
@property (readonly) NSString *smallThumbnailURL;
@property (readonly) NSString *largeThumbnailURL;
@property (readonly) NSString *largerThumbnailURL;
@property (readonly) NSString *previewThumbnailURL;
@property (readonly) NSString *sha1;


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
