/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2012 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TiCustompopoverLayoutEntry : NSObject
{
	UIImage * borderArrowUp;
	UIImage * borderArrowLeft;
	UIImage * borderArrowRight;
	UIImage * borderArrowDown;
	UIImage * borderBackground;
	UIEdgeInsets borderMargins;
	CGFloat arrowOverlap;
}

@property(nonatomic,retain)	UIImage * borderArrowUp;
@property(nonatomic,retain)	UIImage * borderArrowLeft;
@property(nonatomic,retain)	UIImage * borderArrowRight;
@property(nonatomic,retain)	UIImage * borderArrowDown;
@property(nonatomic,retain)	UIImage * borderBackground;
@property(nonatomic,assign)	UIEdgeInsets borderMargins;
@property(nonatomic,assign)	CGFloat arrowOverlap;

@property(nonatomic,readonly)	CGFloat arrowHeight;
@property(nonatomic,readonly)	CGFloat arrowBase;

/*
 *	Due to the one to one relationship that this imple
 */
+(TiCustompopoverLayoutEntry *)layoutForKey:(NSString *)unused;
+(void)registerLayout:(TiCustompopoverLayoutEntry *)layout forKey:(NSString *)unused;

@end