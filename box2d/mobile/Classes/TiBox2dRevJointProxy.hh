/**
 * Appcelerator Titanium Mobile Modules
 * Copyright (c) 2011 by Appcelerator, Inc. All Rights Reserved.
 * Proprietary and Confidential - This source code is not for redistribution
 */

#import "TiProxy.h"
#import <Box2D/Box2D.h>

@interface TiBox2dRevJointProxy : TiProxy 
{	
@public
	b2RevoluteJoint *joint;
    NSLock *lock;
}

-(id)initWithJoint:(b2RevoluteJoint*)joint pageContext:(id<TiEvaluator>)context;

@end
