/**
 * Ti.Bump Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiModule.h"
#import "BumpAPI.h"
#import "BumpAPIUI.h"

@interface TiBumpModule : TiModule<BumpAPIDelegate> 
{
	BumpAPI *bump;
    BumpAPIUI *bumpUI;
}

@end
