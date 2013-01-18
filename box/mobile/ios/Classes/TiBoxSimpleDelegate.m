/**
 * Ti.Box Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiBoxSimpleDelegate.h"


@implementation TiBoxSimpleDelegate

-(id)initWithProxy:(TiProxy*)proxy success:(KrollCallback*)success error:(KrollCallback*)error
{
    if ((self = [super init])) {
        _proxy = [proxy retain];
        _success = [success retain];
        _error = [error retain];
    }
    return self;
}

@synthesize type = _type;

-(void)dealloc
{
	RELEASE_TO_NIL(_proxy);
	RELEASE_TO_NIL(_success);
	RELEASE_TO_NIL(_error);
    RELEASE_TO_NIL(_type);
	[super dealloc];
}

- (void)operation:(BoxOperation *)op didCompleteForPath:(NSString *)path response:(BoxOperationResponse)response {
    NSMutableDictionary *event = [NSMutableDictionary dictionary];
    
    if (op.operationResponse == BoxOperationResponseSuccessful) {
        if (_success != nil)
        {
            [_proxy _fireEventToListener:@"success" withObject:event listener:_success thisObject:nil];
        }
    }
    else {
        switch (op.operationResponse) {
            case BoxOperationResponseNotLoggedIn:
                [event setObject:@"You have to be logged in to do that!" forKey:@"error"];
                break;
            case BoxOperationResponseFilenameInUse:
                [event setObject:@"A file or folder already exists with that name!" forKey:@"error"];
                break;
            case BoxOperationResponseDiskError:
                [event setObject:[NSString stringWithFormat:@"Unable to %@ to that location!", _type] forKey:@"error"];
                break;
            case BoxOperationResponseWrongNode:
                [event setObject:[NSString stringWithFormat:@"That object cannot be %@d!", _type] forKey:@"error"];
                break;
            case BoxOperationResponseInternalAPIError:
                [event setObject:@"An internal API error was encountered! Please try again later." forKey:@"error"];
                break;
            case BoxOperationResponseUnknownError:
            default:
                if (op.error != nil && [op.error code] == 2) {
                    [event setObject:[NSString stringWithFormat:@"Unable to %@ to that location!", _type] forKey:@"error"];
                }
                else {
                    [event setObject:@"An unfamiliar error occured. Please try again later." forKey:@"error"];
                }
                break;
        }
        if (_error != nil) {
            [_proxy _fireEventToListener:@"error" withObject:event listener:_error thisObject:nil];
        }
    }

    RELEASE_TO_NIL(_success);
    RELEASE_TO_NIL(_error);
}

@end
