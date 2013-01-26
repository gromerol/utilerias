/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2013 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiModule.h"
#import "Facebook.h"

@protocol TiFacebookStateListener
@required
-(void)login;
-(void)logout;
@end


@interface TiFacebookModule : TiModule <FBRequestDelegate, FBDialogDelegate, FBSessionDelegate>
{
	Facebook *facebook;
	BOOL loggedIn;
	NSString *uid;
	NSString *url;
	NSString *appid;
	NSArray *permissions;
	NSMutableArray *stateListeners;
    BOOL forceDialogAuth;
}

@property(nonatomic,readonly) Facebook *facebook;
@property(nonatomic,readonly) NSNumber *BUTTON_STYLE_NORMAL;
@property(nonatomic,readonly) NSNumber *BUTTON_STYLE_WIDE;

-(BOOL)isLoggedIn;
-(void)addListener:(id<TiFacebookStateListener>)listener;
-(void)removeListener:(id<TiFacebookStateListener>)listener;

-(void)authorize:(id)args;
-(void)reauthorize:(id)args;
-(void)logout:(id)args;


@end

// Legacy class is now a subclass for backwards and cross compatibility.
// TODO: Depricate this class.
@interface FacebookModule : TiFacebookModule

@end