/**
 * Ti.Box Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiUIView.h"

@interface TiBoxLoginView : TiUIView {
    UIWebView* webView;
}

@property (nonatomic, readonly) UIWebView* webView;

-(void)createView;

@end
