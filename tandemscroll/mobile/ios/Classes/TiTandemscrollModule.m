/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "TiTandemscrollModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

@implementation TiTandemscrollModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"f7f041db-989f-47c9-b009-7977a59497a2";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"ti.tandemscroll";
}

#pragma mark Cleanup 

-(void)dealloc
{
	// release any resources that have been retained by the module
    [scrollViews release];
	[super dealloc];
}

#pragma Public APIs

-(void)lockTogether:(id)args
{
    ENSURE_SINGLE_ARG(args, NSArray);
    
    RELEASE_TO_NIL(scrollViews);
    scrollViews = [[NSMutableArray alloc] initWithCapacity:[args count]];
    
    for (TiUIScrollViewProxy* proxy in args) {
        UIScrollView* scroll = [(TiUIScrollView*)proxy.view scrollView];
        scroll.delegate = self;
        [scrollViews addObject:scroll];
    }
}

#pragma UIScrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    controllingScrollView = scrollView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // We only care about scroll events from the view that is actually being dragged by the user.
    if (scrollView != controllingScrollView)
        return;
    
    for (UIScrollView* scroll in scrollViews) {
        // Skip the view that is actually scrolling,
        if (scroll == scrollView)
            continue;
        // Scroll proportionally.
        [scroll setContentOffset:CGPointMake(scrollView.contentOffset.x * scroll.contentSize.width / scrollView.contentSize.width,
                                             scrollView.contentOffset.y * scroll.contentSize.height / scrollView.contentSize.height) animated:NO];
    }
}

@end
