/**
 * Ti.Box Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiProxy.h"
#import "BoxUpdate.h"
#import "BoxFolder.h"
#import "BoxFile.h"
#import "TiBoxFile.h"
#import "TiBoxFolder.h"

@interface TiBoxUpdate : TiProxy {
    NSNumber* _updateId;
    NSNumber* _userId;
    NSString* _userName;
    NSString* _userEmail;
    NSDate* _updateUpdatedTime;
    NSNumber* _folderId;
    NSString* _folderName;
    NSNumber* _isShared;
    NSString* _shareName;
    NSNumber* _ownerId;
    NSNumber* _collabAccess;
    NSNumber* _updateType;
    NSString* _update;
    NSMutableArray* _files;
    NSMutableArray* _folders;
}

-(id)initWithBoxUpdate:(BoxUpdate*)update;

@property (retain, nonatomic) NSNumber *updateId;
@property (retain, nonatomic) NSNumber *userId;
@property (retain, nonatomic) NSString *userName;
@property (retain, nonatomic) NSString *userEmail;
@property (retain, nonatomic) NSDate *updateUpdatedTime;
@property (retain, nonatomic) NSNumber *folderId;
@property (retain, nonatomic) NSString *folderName;
@property (retain, nonatomic) NSNumber *isShared;
@property (retain, nonatomic) NSString *shareName;
@property (retain, nonatomic) NSNumber *ownerId;
@property (retain, nonatomic) NSNumber *collabAccess;
@property (retain, nonatomic) NSNumber *updateType;
@property (retain, nonatomic) NSString *update;
@property (retain, nonatomic) NSArray *files;
@property (retain, nonatomic) NSArray *folders;

@end