/**
 * Ti.Urbanairship Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiModule.h"

@interface TiUrbanairshipModule : TiModule
{
	BOOL initialized;
	BOOL autoResetBadge;
}

@property (readonly, nonatomic) BOOL notificationsEnabled;
@property (readwrite, nonatomic) BOOL autoResetBadge;

@end
