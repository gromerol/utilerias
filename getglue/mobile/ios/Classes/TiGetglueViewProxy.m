/**
 * Ti.Getglue Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiGetglueViewProxy.h"
#import "TiGetglueView.h"

#import "TiUtils.h"

@implementation TiGetglueViewProxy

-(void)viewDidAttach
{
    [(TiGetglueView*)[self view] createView];
}

// NOTE: We have to override these to do nothing so that we can control the horizontal and vertical (literally)
-(void)setWidth:(id)arg
{
}

-(void)setHeight:(id)arg
{
}

// ... But we also need a way to set them internally from the view.
-(void)internalSetHeight:(id)arg
{
	[super setHeight:arg];
}

-(void)internalSetWidth:(id)arg
{
	[super setWidth:arg];
}


@end
