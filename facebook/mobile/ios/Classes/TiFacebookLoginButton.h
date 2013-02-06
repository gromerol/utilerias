/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2011 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiUIView.h"
#import "FBConnect/FBLoginButton.h"
#import "FacebookModule.h"

@interface TiFacebookLoginButton : TiUIView<TiFacebookStateListener> {

	FBLoginButton *button;
}

@end
