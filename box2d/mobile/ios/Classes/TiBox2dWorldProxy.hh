/**
 * Ti.Box2d Module
 * Copyright (c) 2011-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiProxy.h"
#import "TiViewProxy.h"
#import <Box2D/Box2D.h>
#import "TiContactListener.h"

#define PTM_RATIO 16


@interface TiBox2dWorldProxy : TiProxy {

	b2Vec2 gravity;
	b2World *world;
	NSTimer *timer;
	TiViewProxy *surface;
	TiContactListener *contactListener;
	NSRecursiveLock *lock;
	BOOL _destroyed;
    NSMutableArray *bodies;
}

-(id)initWithViewProxy:(TiViewProxy*)view pageContext:(id<TiEvaluator>)pageContext;
-(b2World*)world;

@end
