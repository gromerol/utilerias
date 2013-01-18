/**
 * Ti.Box Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiBoxLoginView.h"
#import "TiUtils.h"

@implementation TiBoxLoginView

@synthesize webView;
-(UIWebView*)webView
{
    if (webView == nil) {
        webView = [[[UIWebView alloc] initWithFrame:self.bounds] retain];
        webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return webView;
}

-(void)createView
{
    [self addSubview:self.webView];
}

-(void)frameSizeChanged:(CGRect)frame bounds:(CGRect)bounds
{
    [TiUtils setView:self.webView positionRect:bounds];
}

-(void)dealloc
{
    RELEASE_TO_NIL(webView);
    [super dealloc];
}

@end
