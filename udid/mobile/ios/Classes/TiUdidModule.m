/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "TiUdidModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

@implementation TiUdidModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"b685aa22-3809-474c-860c-483fe3074a5f";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"ti.udid";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
	
	NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
	
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup 

-(void)dealloc
{
	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma Public APIs

-(id)oldUDID
{
    NSString* uid;
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(uniqueIdentifier)]) {
                
    	uid = [[UIDevice currentDevice] uniqueIdentifier];
        
    	if (uid) {
            NSLog(@"Old UDID found");
            NSLog(uid);
	        return uid;
        } else {
            return @"";
        }
        
    } else {
        return @"";
    }
    
}

@end
