/**
 * Ti.Box Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiBoxRegisterDelegate.h"


@implementation TiBoxRegisterDelegate

-(id)initWithProxy:(TiProxy*)proxy success:(KrollCallback*)success error:(KrollCallback*)error
{
    if ((self = [super init])) {
        _proxy = [proxy retain];
        _success = [success retain];
        _error = [error retain];
    }
    return self;
}

-(void)dealloc
{
	RELEASE_TO_NIL(_proxy);
	RELEASE_TO_NIL(_success);
	RELEASE_TO_NIL(_error);
	[super dealloc];
}

- (void)operation:(BoxOperation *)op didCompleteForPath:(NSString *)path response:(BoxOperationResponse)response {
    NSMutableDictionary *event = [NSMutableDictionary dictionary];
    if (op.error != nil)
    {
        switch ([op.error code]) {
            case BoxOperationResponseInvalidName:
                [event setObject:@"The username you specified is not valid!" forKey:@"error"];
                break;
            case BoxOperationResponseAlreadyRegistered:
                [event setObject:@"That username is already registered!" forKey:@"error"];
                break;
            case BoxOperationResponseInternalAPIError:
                [event setObject:@"An internal API error was encountered! Please try again later." forKey:@"error"];
                break;
            case BoxOperationResponseUnknownError:
            default:
                [event setObject:@"An unfamiliar error occured while registering you. Please try again later." forKey:@"error"];
                break;
        }
        if (_error != nil) {
            [_proxy _fireEventToListener:@"error" withObject:event listener:_error thisObject:nil];
        }
    }
    else {
        [((BoxRegisterOperation*)op).user save];
        if (_success != nil)
        {
            [_proxy _fireEventToListener:@"success" withObject:event listener:_success thisObject:nil];
        }
    }
    
    RELEASE_TO_NIL(_success);
    RELEASE_TO_NIL(_error);
}

@end
