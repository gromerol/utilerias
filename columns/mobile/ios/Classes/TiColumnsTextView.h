/**
 * Ti.Columns Module
 * Copyright (c) 2011-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiUIView.h"
#import "AKOMultiColumnTextViewDataSource.h"
#import <CoreText/CoreText.h>
#import "AKOMultiPageTextView.h"
@class AKOMultiPageTextView;
@class AKOCustomFontLabel;


@interface TiColumnsTextView : TiUIView<AKOMultiColumnTextViewDataSource, AKOMultiPageTextViewDelegate> {
	@private
		AKOMultiPageTextView *multiPageView;
		// @TODO: 
		// AKOCustomFontLabel *pageTitle;
	int currentPage;
}

-(void)scrollTo:(int)page animated:(BOOL)animated;
-(int)getCurrentPage;
-(AKOMultiPageTextView *)multiPageView;

@end
