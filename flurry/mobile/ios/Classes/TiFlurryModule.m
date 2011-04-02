/**
 * Flurry Analytics Module. Flurry library is Copyright(c) 2010 by Flurry, Inc.
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "TiFlurryModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import "FlurryAPI.h"

@implementation TiFlurryModule

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
	
	NSLog(@"[INFO] Flurry Analytics Module loaded");
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
	
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma Public APIs

-(void)initialize:(id)args
{
	ENSURE_SINGLE_ARG(args,NSString);
	[FlurryAPI startSession:args];
	NSDictionary *dict = [NSDictionary dictionaryWithObject:NUMINT([FlurryAPI version]) forKey:@"version"];
	[TiUtils queueAnalytics:@"app.feature" name:@"ti.module.flurry" data:dict];
}

-(void)reportOnClose:(id)value
{
	ENSURE_SINGLE_ARG(value,NSObject);
	BOOL yn = [TiUtils boolValue:value];
	[FlurryAPI setSessionReportsOnCloseEnabled:yn];
}

-(void)logEvent:(id)args
{
	NSString *event = [args objectAtIndex:0];
	NSDictionary *props = nil;
	if ([args count] > 1)
	{
		props = [args objectAtIndex:1];
	}
	if (props==nil)
	{
		[FlurryAPI logEvent:event];
	}
	else 
	{
		[FlurryAPI logEvent:event withParameters:props];
	}
	[TiUtils queueAnalytics:@"app.user" name:event data:props];
}


@end
