/**
 * Ti.Box Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiProxy.h"
#import "BoxUser.h"

@interface TiBoxUser : TiProxy {
    BoxUser* _user;
    NSString* _error;
}

-(id)initWithBoxUser:(BoxUser*)value;
-(id)initWithError:(NSString*)value;

@property (readonly) NSString *error;

@property (retain) NSString *authToken;

@property (retain) NSString *userName;
@property (retain) NSString *email;

@property (retain) NSNumber *accessId;
@property (retain) NSNumber *userId;

@property (retain) NSNumber *maxUploadSize;
@property (retain) NSNumber *storageQuota;
@property (retain) NSNumber *storageUsed;

@property (readonly) BOOL loggedIn;

@end
