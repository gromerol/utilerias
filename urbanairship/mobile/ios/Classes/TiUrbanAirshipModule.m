/**
 * Ti.Urbanairship Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiUrbanairshipModule.h"
#import "TiApp.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import "TiBlob.h"
#import "TiUIButtonBarProxy.h"

#import "UAInboxPushHandler.h"
#import "UAInboxUI.h"
#import "UAInboxNavUI.h"
#import "UAirship.h"
#import "UAInbox.h"
#import "UAInboxMessageList.h"
#import "UAPush.h"

@implementation TiUrbanairshipModule

@synthesize options, autoResetBadge, notificationsEnabled;

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"d00fbe22-e01d-4ca5-b11b-133155320625";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"ti.urbanairship";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
	
	// Default is automatically reset badge
	autoResetBadge = YES;
	
	NSLog(@"[INFO] %@ loaded",self);
}

// This is called when the application receives the applicationWillResignActive message
-(void)suspend:(id)sender
{
	NSLog(@"[DEBUG] Urban Airship received suspend notification");

	// See MOD-165
	if (!initialized) {
		NSLog(@"[DEBUG] Ignoring notification -- not initialized yet");
		return;
	}
	
	UAInbox *inbox = [UAInbox shared];
	if (inbox != nil && inbox.messageList != nil && inbox.messageList.unreadCount >= 0) {
		[[UIApplication sharedApplication] setApplicationIconBadgeNumber:inbox.messageList.unreadCount];
	}
}

// This is called when the application receives the applicationDidBecomeActive message
-(void)resumed:(id)sender
{
	// See MOD-165
	if (!initialized) {
		NSLog(@"[DEBUG] Ignoring notification -- not initialized yet");
		return;
	}
	
	// [MOD-238] Automatically reset badge count on resume
    [self handleAutoBadgeReset];
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
	[UAirship land];
	// you *must* call the superclass
	[super shutdown:sender];
}

- (void)failIfSimulator {
    if ([[[UIDevice currentDevice] model] rangeOfString:@"Simulator"].location != NSNotFound) {
		NSLog(@"[ERROR] You can see UAInbox in the simulator, but you will not be able to receive push notifications");
    }
}

-(void)initializeIfNeeded
{
    if (initialized) {
        // Do nothin'
        return;
    }
	
	// SUPER WARNING!!!!!!
	// This initialization method MUST be run on the UI thread. The setup of UAInboxUI and UAInboxNavUI must occur
	// on the UI thread or else it will not draw properly. A perfect symptom of this is that the navigation bar in 
	// the navigation controller draws transparent and the leftbarbutton doesn't render on first display. I spent
	// a good amount of time trying to figure out why this was occurring until I realized that this method was being
	// called by a newly added method that was not being run on the UI thread.
	// The following ENSURE_CONSISTENCY macro verifies that any calls in the future will be caught immediately!
	ENSURE_CONSISTENCY([NSThread isMainThread]);
	
	[self failIfSimulator];

	NSLog(@"[DEBUG] Urban Airship starting init");
	
	id launchOptions = [[TiApp app] launchOptions];
	
	// Set the takeoff options, which includes both the launch options from the
	// command line as well as the user's options for Urban Airship
    NSMutableDictionary *takeOffOptions = [[[NSMutableDictionary alloc] init] autorelease];
    // Adding support for the AirshipConfig.plist file as part of the upgrade to 1.3.2 [MOD-804]
    // The options property is now optional
    if (options != nil) {
        [takeOffOptions setValue:options forKey:UAirshipTakeOffOptionsAirshipConfigKey];
    }
	[takeOffOptions setValue:launchOptions forKey:UAirshipTakeOffOptionsLaunchOptionsKey];
	
    // Create Airship singleton that's used to talk to Urban Airhship servers.
    [UAirship takeOff:takeOffOptions];

	// [MOD-238] Automatically reset badge count at startup
    [self handleAutoBadgeReset];
	
    // Config Inbox behaviour before UAInboxPushHandler since it may need it
    // when launching from notification
	
	// Default inbox style is modal
	[UAInbox useCustomUI:[UAInboxUI class]];
	[UAInbox shared].pushHandler.delegate = [UAInboxUI shared];

	// Get the root view controller from the app
	[UAInboxUI shared].inboxParentController = [[TiApp app] controller];
	[UAInboxUI shared].useOverlay = NO;
	
	// Get the launch options from the app startup
    [UAInboxPushHandler handleLaunchOptions:launchOptions];
	
	if([[UAInbox shared].pushHandler hasLaunchMessage]) {
		[UAInboxUI loadLaunchMessage];
	}    

	initialized = YES;
    [self updateUAServer];

	NSLog(@"inited");
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

-(void)registerDevice:(id)arg
{	
	ENSURE_UI_THREAD_1_ARG(arg);
	
	[self initializeIfNeeded];
	
    // Passing the options in this method is being deprecated, but for now we will continue to support
    // them by setting the property values on the module object
	NSData* token = [arg objectAtIndex:0];
    if ([arg count] > 1) {
        NSLog(@"[WARN] Passing options to registerDevice has been DEPRECATED. Use 'tags' and 'alias' properties");
        id opts = [arg objectAtIndex:1];
        if (opts != nil)
        {
            ENSURE_DICT(opts);
            [self setValuesForKeysWithDictionary:opts];
        }
    }

    
    // NOTE: We are not using the UA registerForRemoteNotificationTypes method since we rely on the developer
    // calling the Ti.Network.registerForRemoteNotifications method. The following call will generate an
    // error message in the log from UA about missing notification types.    
    //    [[UAPush shared] registerDeviceToken:token];
    // For now we can use the following call to register the device token. I have made a request to Urban Airship
    // to continue support for registering a device token without using their UAPush registration mechanism.
    // We could consider switching over to the UAPush mechanism but that would mean a change to existing user
    // applications. Perhaps we could switch over with a new API and start deprecating the current method.
    [[UAPush shared] registerDeviceToken:token withExtraInfo:nil];
}
	
// [MOD-214] Add unregisterDevice method
-(void)unregisterDevice:(id)arg
{
	if (initialized) {
        [UAPush shared].pushEnabled = NO;
	}
}

-(void)displayInbox:(id)args
{
	ENSURE_UI_THREAD_1_ARG(args);
	
	[self initializeIfNeeded];		

	// User can control whether we animate or not with this argument
	BOOL animated = [TiUtils boolValue:@"animated" properties:args def:YES];

	UIViewController* viewController = [[TiApp app] controller];
	[UAInbox displayInbox:viewController animated:animated];
}

-(void)hideInbox:(id)arg
{
	ENSURE_UI_THREAD_1_ARG(arg);
	
	[self initializeIfNeeded];
	
	[UAInbox quitInbox];
}

-(void)handleNotification:(id)arg
{
	// The only argument to this method is the userInfo dictionary received from
	// the remote notification
	
	ENSURE_UI_THREAD_1_ARG(arg);	
	
	[self initializeIfNeeded];
	
	id userInfo = [arg objectAtIndex:0];
	ENSURE_DICT(userInfo);
	
	NSLog(@"[DEBUG] Urban Airship received notification");
	
	[UAInboxPushHandler handleNotification:userInfo];
    
	// [MOD-238] Reset badge after push received
    [self handleAutoBadgeReset];
}

-(BOOL)notificationsEnabled
{
    return [[UIApplication sharedApplication] enabledRemoteNotificationTypes] != UIRemoteNotificationTypeNone;
}

-(BOOL)isFlying
{
    // We are "flying" if we are initialized AND notifications are currently enabled on the application
    return initialized && [self notificationsEnabled];
}

-(void)updateUAServer
{
    if (initialized) {
        [[UAPush shared] updateRegistration];
    }
}

-(void)handleAutoBadgeReset
{
    if (autoResetBadge) {
        [[UAPush shared] resetBadge];
        [self updateUAServer];
    }
}

#pragma mark Badge

// [MOD-208] and [MOD-228] -- support badge management

-(void)setAutoBadge:(id)value
{
	NSInteger autoBadge = [TiUtils boolValue:value def:NO];
	
    [UAPush shared].autobadgeEnabled = autoBadge;
    
    [self updateUAServer];
}

-(BOOL)getAutoBadge
{
    return [UAPush shared].autobadgeEnabled;
}

-(void)setBadgeNumber:(id)value
{
	NSInteger badgeNumber = [TiUtils intValue:value def:0];
	
	[[UAPush shared] setBadgeNumber:badgeNumber];
    
    [self updateUAServer]; 
}

-(void)resetBadge:(id)args
{
	[[UAPush shared] resetBadge];
    
    [self updateUAServer];
}

-(void)setTags:(id)value
{
    ENSURE_ARRAY(value);

    [UAPush shared].tags = value;

    [self updateUAServer];
}

-(NSArray*)getTags
{
    return [UAPush shared].tags;
}

-(void)setAlias:(id)value
{
    NSString* alias = [TiUtils stringValue:value];
           
    [UAPush shared].alias = alias;
    
    [self updateUAServer]; 
}

-(NSString*)getAlias
{
    return [UAPush shared].alias;
}

-(NSString*)getUsername
{
    return [UAUser defaultUser].username;
}

@end

