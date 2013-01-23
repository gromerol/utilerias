/**
 * Ti.Columns Module
 * Copyright (c) 2011-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiColumnsTextView.h"
#import "TiUtils.h"
#import "AKOCustomFontLabel.h"
#import "NSString+BundleExtensions.h"
#import "UIFont+CoreTextExtensions.h"

@interface TiColumnsTextView ()

@property (nonatomic) CGFloat previousScale;
@property (nonatomic) CGFloat fontSize;
@property (nonatomic) CGFloat maxSize;
@property (nonatomic) CGFloat minSize;
@property (nonatomic) int pCols;
@property (nonatomic) int lCols;
@property (nonatomic) int currentPage;
@end


@implementation TiColumnsTextView

@synthesize fontSize, previousScale, minSize, maxSize, pCols, lCols, currentPage;

-(id)init
{
    if (self = [super init]) {
		self.maxSize = 48.0;
		self.minSize = 12.0;
		self.pCols = 3;
		self.lCols = 4;
		self.currentPage = 0;
		multiPageView = [self multiPageView];
    }
    return self;
}

-(void)dealloc {
	RELEASE_TO_NIL(multiPageView);
	// RELEASE_TO_NIL(pageTitle);
	[super dealloc];
}

// @TODO:
//-(AKOCustomFontLabel *)pageTitle
//{
//	if(!pageTitle)
//	{
//		pageTitle = [[AKOCustomFontLabel alloc] init];
//		pageTitle.text = @"Title";
//	}
//	return pageTitle;
//}

-(AKOMultiPageTextView *)multiPageView
{
	if(multiPageView == nil)
	{
		multiPageView = [[AKOMultiPageTextView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
		multiPageView.delegate = self;
		multiPageView.dataSource = self;
		//	multiPageView.columnInset = CGPointMake(50, 30);
		multiPageView.text = @"";
		multiPageView.font = [UIFont fontWithName:@"Helvica" size:12.0];
		multiPageView.backgroundColor = [UIColor whiteColor];
		
		UIPinchGestureRecognizer *pinchRecognizer = [
			[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(changeTextSize:)] autorelease];
		
		[self.multiPageView addGestureRecognizer:pinchRecognizer];
		[self addSubview:multiPageView];	
	}
	self.fontSize = multiPageView.font.pointSize;
	return multiPageView;
}

-(void)frameSizeChanged:(CGRect)frame bounds:(CGRect)bounds
{
	[super frameSizeChanged:frame bounds:bounds];
	UIInterfaceOrientation orientation = [TiUtils orientation];
	[multiPageView setColumnCount:UIInterfaceOrientationIsPortrait(orientation) ? self.pCols : self.lCols];
	[TiUtils setView:multiPageView positionRect:bounds];
}

-(void)setTextAlign_:(id)arg
{
	ENSURE_SINGLE_ARG(arg, NSString);
	
	CTTextAlignment textAlign;
	
	if([arg isEqualToString:@"left"])
		textAlign = kCTLeftTextAlignment;
	else
	if([arg isEqualToString:@"right"])
		textAlign = kCTRightTextAlignment;
	else
	if([arg isEqualToString:@"center"])
		textAlign = kCTCenterTextAlignment;
	else
	if([arg isEqualToString:@"justify"])
		textAlign = kCTJustifiedTextAlignment;
	else
		textAlign = kCTNaturalTextAlignment;
		
	[multiPageView setTextAlignment:textAlign];
	[multiPageView setNeedsDisplay];
}

-(void)setMaxFontSize_:(id)maxFontSize
{
	self.maxSize = [maxFontSize floatValue];
}

-(void)setMinFontSize_:(id)minFontSize
{
	ENSURE_SINGLE_ARG(minFontSize, NSNumber);
	self.minSize = [minFontSize floatValue];
}

-(void)setPortraitColumns_:(id)portraitColumns
{
	ENSURE_SINGLE_ARG(portraitColumns, NSNumber);
	self.pCols = [portraitColumns intValue];
}

-(void)setLandscapeColumns_:(id)landscapeColumns
{
	ENSURE_SINGLE_ARG(landscapeColumns, NSNumber);
	self.lCols = [landscapeColumns intValue];
}


-(void)setText_:(id)text
{
	ENSURE_SINGLE_ARG_OR_NIL(text, NSString);
	[multiPageView setText:text];
	[multiPageView setNeedsDisplay];
}

-(void)scrollTo:(int)page animated:(BOOL)animated
{
	if(!animated) animated = NO;
	[multiPageView scrollToPage:page animated:animated];
	self.currentPage = page;
}

-(void)setFont_:(id)font
{
	[multiPageView setFont:[[TiUtils fontValue:font] font]];
	[multiPageView setNeedsDisplay];
}

-(void)setCurrentPage_:(id)arg
{
	int page = [TiUtils intValue:arg];
	[multiPageView scrollToPage:page animated:NO];
	self.currentPage = page;
}

- (void)changeTextSize:(UIPinchGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        self.previousScale = recognizer.scale;
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        if (recognizer.scale > self.previousScale)
        {
            if (self.fontSize < self.maxSize)
            {
                self.fontSize += 0.25;
            }
        }
        else 
        {
            if (self.fontSize > self.minSize)
            {
                self.fontSize -= 0.25;
            }
        }
		
		self.multiPageView.font = [UIFont fontWithName:self.multiPageView.font.fontName size:self.fontSize];
        self.previousScale = recognizer.scale;
    }
}

-(void)columnsViewDidFinishScrolling:(id)page
{
	self.currentPage = [TiUtils intValue:page];
	if ([self.proxy _hasListeners:@"scroll"])
	{
		NSMutableDictionary *tiEvent = [NSMutableDictionary dictionary];
		[tiEvent setObject:page forKey:@"index"];
		[self.proxy fireEvent:@"scroll" withObject:tiEvent];
	}
}

-(int)getCurrentPage
{
	if(!self.currentPage)
		self.currentPage = 0;
	return self.currentPage;
}

/*
-(void)columnsViewIsStillScrolling:(id)page
{
	if ([self.proxy _hasListeners:@"scrolling"])
	{
		NSMutableDictionary *tiEvent = [NSMutableDictionary dictionary];
		[tiEvent setObject:page forKey:@"index"];
		[self.proxy fireEvent:@"scrolling" withObject:tiEvent];
	}
}

-(void)columnsViewDidStartScrolling:(id)page
{
	if ([self.proxy _hasListeners:@"scrolling"])
	{
		NSMutableDictionary *tiEvent = [NSMutableDictionary dictionary];
		[tiEvent setObject:page forKey:@"index"];
		[self.proxy fireEvent:@"startScrolling" withObject:tiEvent];
	}
}
*/
@end
