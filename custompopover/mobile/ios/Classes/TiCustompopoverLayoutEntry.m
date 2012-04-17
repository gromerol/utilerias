/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2012 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiCustompopoverLayoutEntry.h"

static TiCustompopoverLayoutEntry * blessedLayout = nil;

@implementation TiCustompopoverLayoutEntry

@synthesize borderArrowUp, borderArrowLeft, borderArrowRight;
@synthesize borderArrowDown, borderBackground, borderMargins;

@synthesize arrowOverlap;

-(CGFloat) arrowBase
{
	if (borderArrowUp == nil) {
		return 0.0;
	}
	return [borderArrowUp size].width;
}

-(CGFloat) arrowHeight
{
	if (borderArrowUp == nil) {
		return 0.0;
	}
	return [borderArrowUp size].height - arrowOverlap;	
}

//TODO: This is fine only in a single-JS-context setup.
+(TiCustompopoverLayoutEntry *)layoutForKey:(NSString *)unused;
{
	return blessedLayout;
}

+(void)registerLayout:(TiCustompopoverLayoutEntry *)layout forKey:(NSString *)unused;
{
	[blessedLayout autorelease];
	blessedLayout = [layout retain];
}

@end
