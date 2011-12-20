/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2011 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiProxy.h"
#import "TiUtils.h"

@interface TiUdpSocketProxy : TiProxy
{
    bool isServer;
    NSString* _hostName;
    NSData* _hostAddress;
    NSUInteger _port;
    CFHostRef _cfHost;
	CFSocketRef _cfSocket;
}

-(void)start:(id)args;
-(void)sendString:(id)args;
-(void)sendBytes:(id)args;
-(void)stop:(id)args;

@end