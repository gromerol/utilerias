/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2012 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiCustompopoverPopover.h"
#import "TiCustompopoverLayoutEntry.h"
@implementation TiCustompopoverPopover


@end

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
#import <UIKit/UIPopoverBackgroundView.h>

@interface TiCustompopoverBackgroundView : UIPopoverBackgroundView

@end

@implementation TiCustompopoverBackgroundView
{
	UIImageView *arrowView;
	UIImageView *imageView;
	
	UIPopoverArrowDirection direction;
	CGFloat offset;
}

- (void)dealloc
{
	[arrowView release];
	[imageView release];
	[super dealloc];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	TiCustompopoverLayoutEntry * ourLayout = [TiCustompopoverLayoutEntry layoutForKey:nil];
	if (imageView == nil) {
		imageView = [[UIImageView alloc] initWithImage:[ourLayout borderBackground]];
		[self addSubview:imageView];
	}
	if (arrowView == nil) {
		arrowView = [[UIImageView alloc] initWithImage:[ourLayout borderArrowUp]];
		[self addSubview:arrowView];
	}
	
	CGRect imageFrame = [self bounds];
	CGRect arrowFrame = CGRectZero;
	UIImage * arrowImage;
	CGFloat arrowBase = [ourLayout arrowBase];
	CGFloat arrowHeight = [ourLayout arrowHeight];

	switch (self.arrowDirection) {
		case UIPopoverArrowDirectionUp:
			arrowImage = [ourLayout borderArrowUp];
			arrowFrame.size = [arrowImage size];
			[arrowView setImage:arrowImage];
			arrowFrame.origin.y=0;
			arrowFrame.origin.x=imageFrame.size.width/2 - arrowBase/2 + offset;
			
			imageFrame.origin.y += arrowHeight;
			imageFrame.size.height -= arrowHeight;
			break;
			
		case UIPopoverArrowDirectionDown:
			arrowImage = [ourLayout borderArrowDown];
			arrowFrame.size = [arrowImage size];
			[arrowView setImage:arrowImage];
			arrowFrame.origin.y=imageFrame.size.height - arrowFrame.size.height;
			arrowFrame.origin.x=imageFrame.size.width/2 - arrowBase/2 + offset;
			
			imageFrame.size.height -= arrowHeight;
			break;
			
		case UIPopoverArrowDirectionLeft:
			arrowImage = [ourLayout borderArrowLeft];
			arrowFrame.size = [arrowImage size];
			[arrowView setImage:arrowImage];
			arrowFrame.origin.x=0;
			arrowFrame.origin.y=imageFrame.size.height/2 - arrowBase/2 + offset;
			
			imageFrame.origin.x += arrowHeight;
			imageFrame.size.width -= arrowHeight;
			break;
			
		case UIPopoverArrowDirectionRight:
			arrowImage = [ourLayout borderArrowRight];
			arrowFrame.size = [arrowImage size];
			[arrowView setImage:arrowImage];
			arrowFrame.origin.x=imageFrame.size.width - arrowFrame.size.width;
			arrowFrame.origin.y=imageFrame.size.height/2 - arrowBase/2 + offset;
			
			imageFrame.size.width -= arrowHeight;
			break;
			
	}
	
	[arrowView setFrame:arrowFrame];
	[imageView setFrame:imageFrame];
}

- (CGFloat) arrowOffset {
	return offset;
}

- (void) setArrowOffset:(CGFloat)arrowOffset
{
	offset = arrowOffset;
	[self setNeedsLayout];
}

- (UIPopoverArrowDirection)arrowDirection
{
	return direction;
}

- (void)setArrowDirection:(UIPopoverArrowDirection)arrowDirection
{
	direction = arrowDirection;
	[self setNeedsLayout];
}

+ (CGFloat)arrowHeight
{
	return [[TiCustompopoverLayoutEntry layoutForKey:nil] arrowHeight];
}

+ (CGFloat)arrowBase
{
	return [[TiCustompopoverLayoutEntry layoutForKey:nil] arrowBase];
}

+ (UIEdgeInsets)contentViewInsets
{
	return [[TiCustompopoverLayoutEntry layoutForKey:nil] borderMargins];
}

@end

#endif
