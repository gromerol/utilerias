/**
 * Ti.Bump Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiBumpModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import "TiBlob.h"
#import "TiApp.h"
#import "TiViewProxy.h"

@implementation TiBumpModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"72636713-45bb-4754-ac97-608532e52889";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"ti.bump";
}

-(void)startup
{
	[super startup];
}

-(void)dealloc
{
	if (bump!=nil)
	{
		[bump performSelectorOnMainThread:@selector(disconnect) withObject:nil waitUntilDone:NO];
		RELEASE_TO_NIL(bump);
	}
    RELEASE_TO_NIL(bumpUI);
	[super dealloc];
}

#pragma Public APIs

-(void)connect:(id)args
{
	ENSURE_UI_THREAD(connect,args);
	ENSURE_SINGLE_ARG(args,NSDictionary);
	
	RELEASE_TO_NIL(bump);
	
	NSString* apiKey = [TiUtils stringValue:@"apikey" properties:args];
	NSString* username = [TiUtils stringValue:@"username" properties:args];
	NSString* message = [TiUtils stringValue:@"message" properties:args];
	
	id parentView = [args valueForKey:@"view"];
	
	bump = [BumpAPI sharedInstance];
	[bump configAPIKey:apiKey];
    [bump configDelegate:self];
	[bump configUserName:username];
	[bump configActionMessage:message];
    
    RELEASE_TO_NIL(bumpUI);
    bumpUI = [[BumpAPIUI alloc] init];
    [bumpUI setBumpAPIObject:[BumpAPI sharedInstance]];
	
	if (parentView!=nil && [parentView isKindOfClass:[TiViewProxy class]])
	{
		[bumpUI setParentView:[(TiViewProxy*)parentView view]];
	}
    else {
        [bumpUI setParentView:[TiApp app].window];
    }
	
    [bump configUIDelegate:bumpUI];
    
    [bump requestSession];
	
	[self fireEvent:@"ready"];
}

-(void)sendMessage:(id)args
{
	ENSURE_UI_THREAD(sendMessage,args);
	ENSURE_SINGLE_ARG(args,NSString);
	
	if (bump!=nil)
	{
		NSData *chunk = [args dataUsingEncoding:NSUTF8StringEncoding];
        [bump sendData:chunk];
	}
	else 
	{
		NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:@"Not Connected",@"message",nil];
		[self fireEvent:@"error" withObject:event];
	}
}

-(void)disconnect:(id)args
{
	ENSURE_UI_THREAD(disconnect,args);
	
	if (bump!=nil)
	{
        [bump endSession];
		RELEASE_TO_NIL(bump);
	}
    RELEASE_TO_NIL(bumpUI);
}

#pragma mark Delegate methods

/**
 Successfully started a Bump session with another device.
 @param		otherBumper		Let's you know how the other device identifies itself
 Can also be accessed later via the otherBumper method on the API
 */
- (void) bumpSessionStartedWith:(Bumper *)otherBumper
{
    NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:[otherBumper userName],@"username",nil];
	[self fireEvent:@"connected" withObject:event];
}

/**
 There was an error while trying to start the session these reasons are helpful and let you know
 what's going on
 @param		reason			Why the session failed to start
 */
- (void) bumpSessionFailedToStart:(BumpSessionStartFailedReason)reason
{
    NSString *message = @"UNKNOWN";
	
	switch (reason)
	{
		case FAIL_NONE:
		{
			message = @"FAIL_NONE";
			break;
		}
		case FAIL_USER_CANCELED:
		{
			message = @"FAIL_USER_CANCELED";
			NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:message,@"message",nil];
			[self fireEvent:@"cancel" withObject:event];
			return;
		}
		case FAIL_NETWORK_UNAVAILABLE:
		{
			message = @"FAIL_NETWORK_UNAVAILABLE";
			break;
		}
		case FAIL_INVALID_AUTHORIZATION:
		{
			message = @"FAIL_INVALID_AUTHORIZATION";
			break;
		}
	}
	
	NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:message,@"message",nil];
	[self fireEvent:@"error" withObject:event];
}

/**
 The bump session was ended, reason tells you wheter it was expected or not
 @param		reason			Why the session ended. Could be either expected or unexpected.
 */
- (void) bumpSessionEnded:(BumpSessionEndReason)reason
{
    NSString *message = @"UNKNOWN";
	
	switch(reason)
	{
		case END_USER_QUIT:
		{
			message = @"END_USER_QUIT";
			break;
		}
		case END_LOST_NET:
		{
			message = @"END_LOST_NET";
			break;
		}
		case END_OTHER_USER_QUIT:
		{
			message = @"END_OTHER_USER_QUIT";
			break;
		}
		case END_OTHER_USER_LOST:
		{
			message = @"END_OTHER_USER_LOST";
			break;
		}
	}
	NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:message,@"message",nil];
	[self fireEvent:@"disconnected" withObject:event];
}

/**
 The symmetrical call to sendData on the API. When the other device conneced via Bump calls sendData
 this device get's this call back
 @param		reason			Data sent by the other device.
 */
- (void) bumpDataReceived:(NSData *)chunk
{
    TiBlob *blob = [[[TiBlob alloc] initWithData:chunk mimetype:@"text/plain"] autorelease];
	NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:blob,@"data",nil];
	[self fireEvent:@"data" withObject:event];
}

@end
