/**
 * Ti.Box Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiBoxUser.h"

@implementation TiBoxUser

-(id)initWithBoxUser:(BoxUser *)value
{
    if ((self = [super init]))
    {
        _user = [value retain];
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

@synthesize error = _error;

-(NSString*)authToken
{
    if (_user == nil)
        return nil;
    return _user.authToken;
}

-(NSString*)userName
{
    if (_user == nil)
        return nil;
    return _user.userName;
}
-(NSString*)email
{
    if (_user == nil)
        return nil;
    return _user.email;
}

-(NSNumber*)accessId
{
    if (_user == nil)
        return nil;
    return _user.accessId;
}
-(NSNumber*)userId
{
    if (_user == nil)
        return nil;
    return _user.userId;
}

-(NSNumber*)maxUploadSize
{
    if (_user == nil)
        return nil;
    return _user.maxUploadSize;
}
-(NSNumber*)storageQuota
{
    if (_user == nil)
        return nil;
    return _user.storageQuota;
}
-(NSNumber*)storageUsed
{
    if (_user == nil)
        return nil;
    return _user.storageUsed;
}

- (BOOL)loggedIn
{
	return _user != nil && _user.loggedIn;
}

@end
