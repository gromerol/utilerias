/**
 * Ti.Box2d Module
 * Copyright (c) 2011-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiBox2dModule.hh"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import "TiBox2dWorldProxy.hh"

@implementation TiBox2dModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"A391B0DB-94F5-4820-9972-F7D7843545A6";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"ti.box2d";
}

#pragma mark box2d

-(id)createWorld:(id)args
{
	TiViewProxy *viewproxy = [args objectAtIndex:0];
	TiBox2dWorldProxy *proxy = [[TiBox2dWorldProxy alloc] initWithViewProxy:viewproxy pageContext:[self executionContext]];
	return [proxy autorelease];
}

-(id)REV_JOINT
{
    return NUMINT(1);
}

-(id)STATIC_BODY
{

    return @"static";
}

-(id)DYNAMIC_BODY
{
 	return @"dynamic";
}

-(id)KINEMATIC_BODY
{
 	return @"kinematic";
}

@end
