/**
 * Ti.Box2d Module
 * Copyright (c) 2011-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiProxy.h"
#import "TiViewProxy.h"
#import "TiBox2dWorldProxy.hh"

#import <Box2D/Box2D.h>

@interface TiBox2dBodyProxy : TiProxy 
{	
@public
	b2Body *body;
    NSLock *lock;
	TiViewProxy *viewproxy;

}

-(id)initWithBody:(b2Body*)body viewproxy:(TiViewProxy*)vp pageContext:(id<TiEvaluator>)context;
-(TiViewProxy*)viewproxy;
-(b2Body*)body;

@end
