/**
 * Ti.Box2d Module
 * Copyright (c) 2011-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiBox2dRevJointProxy.hh"
#import "TiUtils.h"

@implementation TiBox2dRevJointProxy

-(id)initWithJoint:(b2RevoluteJoint*)joint_ pageContext:(id<TiEvaluator>)context
{
	if ((self = [super _initWithPageContext:context]))
	{
		joint = joint_;
        lock = [[NSRecursiveLock alloc] init];
	}
	return self;
}

-(void)dealloc
{
    RELEASE_TO_NIL(lock);
	[super dealloc];
}

-(b2Joint*)joint
{
    return joint;
}

-(void)setMotorSpeed:(id)args
{
    [lock lock];
    
    ENSURE_SINGLE_ARG(args,NSNumber);
    
    CGFloat speed = [TiUtils floatValue:args];
    joint->SetMotorSpeed(speed);
    
    [lock unlock];
}

-(void)setMaxMotorTorque:(id)args
{
    [lock lock];
    
    ENSURE_SINGLE_ARG(args,NSNumber);
    
    CGFloat t = [TiUtils floatValue:args];
    joint->SetMaxMotorTorque(t);
    
    [lock unlock];
}

-(id)getJointAngle:(id)args
{
    float angle = joint->GetJointAngle();
    return NUMFLOAT(angle);
}

-(id)getJointSpeed:(id)args
{
    float speed = joint->GetJointSpeed();
    return NUMFLOAT(speed);
}



@end
