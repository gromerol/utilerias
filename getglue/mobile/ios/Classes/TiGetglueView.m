/**
 * Ti.Getglue Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiGetglueView.h"
#import "TiGetglueModule.h"

#import "TiUtils.h"

@implementation TiGetglueView

-(void)dealloc
{
	// Release objects and memory allocated by the view
	RELEASE_TO_NIL(widget);
	
	[super dealloc];
}

-(void)initializeState
{
	// This method is called right after allocating the view and
	// is useful for initializing anything specific to the view
	
    [[self proxy] internalSetWidth:NUMINT(64)];
	[[self proxy] internalSetHeight:NUMINT(74)];
    
	[super initializeState];
}

-(NSString*)getValidSource
{
	// Get the value of the proxy's source property
	NSString* source = [self.proxy valueForKey:@"source"];
	if (source == nil) {
		// Get the value of the module's source property
		source = [[TiGetglueModule sharedInstance] valueForKey:@"source"];
	}
	
	if (source != nil) {
		// Make sure we have a value URL
		NSURL *url = [NSURL URLWithString:source];
		if (url == nil) {
			NSLog(@"[WARNING] Ti.GetGlue: Invalid source, source must be a URL or user ID, you specified: '%@'. Source is being ignored...", source);
			source = @"";
		}
	} else {
		source = @"";
	}
	
	NSLog(@"[INFO] Source is '%@'", source);
		  
	return source;
}

-(void)createView
{
	widget = [[[GetGlueWidgetView alloc] initWithFrame:CGRectMake(0, 0, 64, 74)] autorelease];
	widget.source = [self getValidSource]; // When setting a custom source, always set it before objectKey
	widget.objectKey = [TiUtils stringValue:[self.proxy valueForKey:@"objectKey"]]; // Setting objectKey will start the webview loading
	[self addSubview:widget];
}

-(void)frameSizeChanged:(CGRect)frame bounds:(CGRect)bounds
{
	// You must implement this method for your view to be sized correctly.
	// This method is called each time the frame / bounds / center changes
	// within Titanium. 
    
	if (widget != nil) {
		
		// You must call the special method 'setView:positionRect' against
		// the TiUtils helper class. This method will correctly layout your
		// child view within the correct layout boundaries of the new bounds
		// of your view.
		
		[TiUtils setView:widget positionRect:bounds];
	}
}

@end
