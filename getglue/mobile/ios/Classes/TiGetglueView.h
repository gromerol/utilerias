/**
 * Ti.Getglue Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiUIView.h"
#import "GetGlueWidget.h"

@interface TiGetglueView : TiUIView {

    GetGlueWidgetView* widget;

}

-(void)createView;
@end
