/**
 * Titanium Tandem Scroll Module
 *
 * Appcelerator Titanium is Copyright (c) 2009-2012 by Appcelerator, Inc.
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
    for (TiUIScrollViewProxy* proxy in scrollViews) {
        [proxy forgetSelf];
    }
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
        [proxy rememberSelf];
        [(TiUIScrollView*)proxy.view scrollView].delegate = self;
        [scrollViews addObject:proxy];
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
    
    for (TiUIScrollViewProxy* proxy in scrollViews)
    {
        
        // Skip the view that is actually scrolling,
        UIScrollView* scroll = [(TiUIScrollView*)proxy.view scrollView];
        if (scroll == controllingScrollView)
        {
            CGPoint offset = [scrollView contentOffset];
            [proxy fireEvent:@"scroll" withObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                   NUMFLOAT(offset.x),@"x",
                                                   NUMFLOAT(offset.y),@"y",
                                                   NUMBOOL([scrollView isDecelerating]),@"decelerating",
                                                   NUMBOOL([scrollView isDragging]),@"dragging", nil]];
            continue;
        }
        
        // Scroll proportionally.
        [scroll setContentOffset:CGPointMake(scrollView.contentOffset.x * scroll.contentSize.width / scrollView.contentSize.width,
                                             scrollView.contentOffset.y * scroll.contentSize.height / scrollView.contentSize.height) animated:NO];
    }
}

@end
