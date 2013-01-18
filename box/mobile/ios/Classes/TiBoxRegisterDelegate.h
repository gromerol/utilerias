/**
 * Ti.Box Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import <Foundation/Foundation.h>
#import "TiBoxDelegate.h"
#import "BoxRegisterOperation.h"


@interface TiBoxRegisterDelegate : NSObject<TiBoxDelegate> {
    TiProxy* _proxy;
    KrollCallback* _success;
    KrollCallback* _error;
}

@end
