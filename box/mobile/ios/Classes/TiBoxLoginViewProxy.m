/**
 * Ti.Box Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiBoxLoginViewProxy.h"
#import "TiUtils.h"

@implementation TiBoxLoginViewProxy

-(void)viewDidAttach
{
    [(TiBoxLoginView*)[self view] createView];
}

@synthesize webView;
-(UIWebView*)webView
{
    return ((TiBoxLoginView*)[self view]).webView;
}

@end
