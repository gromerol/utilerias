/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2011 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiViewProxy.h"
#import "TiFacebookModule.h"
#import "TiFacebookLoginButton.h"

@interface TiFacebookLoginButtonProxy : TiViewProxy {

	TiFacebookModule *module;
}

-(id)_initWithPageContext:(id<TiEvaluator>)context_ args:(id)args module:(TiFacebookModule*)module_;

@property(nonatomic,readonly) TiFacebookModule *_module;

-(void)internalSetWidth:(id)width;
-(void)internalSetHeight:(id)height;

@end
