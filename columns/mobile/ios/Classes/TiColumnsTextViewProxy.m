/**
 * Ti.Columns Module
 * Copyright (c) 2011-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiColumnsTextViewProxy.h"

@implementation TiColumnsTextViewProxy


-(TiColumnsTextView *)columnsView
{
	return (TiColumnsTextView *)[self view];
}

-(void)scrollToPage:(id)args
{
	ENSURE_UI_THREAD(scrollToPage, args);
	
	NSInteger index = [TiUtils intValue:[args objectAtIndex:0]];
	NSDictionary *options = [args count] > 1 ? [args objectAtIndex:1] : nil;
	
	BOOL animated = [TiUtils boolValue:@"animated" properties:options def:YES];	
	[[self columnsView] scrollTo:index animated:animated];
}

-(id)currentPage
{
	return [NSNumber numberWithInt:[[self columnsView] getCurrentPage]];
}

@end
