/**
 * Ti.Box Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import <Foundation/Foundation.h>
#import "TiProxy.h"
#import "BoxOperation.h"


@protocol TiBoxDelegate <BoxOperationDelegate>

-(id)initWithProxy:(TiProxy*)proxy success:(KrollCallback*)success error:(KrollCallback*)error;

@end
