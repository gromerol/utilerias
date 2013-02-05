/**
 * Ti.Box2d Module
 * Copyright (c) 2011-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiProxy.h"
#import <Box2D/Box2D.h>

@interface TiBox2dRevJointProxy : TiProxy 
{	
@public
	b2RevoluteJoint *joint;
    NSRecursiveLock *lock;
}

-(id)initWithJoint:(b2RevoluteJoint*)joint pageContext:(id<TiEvaluator>)context;

@end
