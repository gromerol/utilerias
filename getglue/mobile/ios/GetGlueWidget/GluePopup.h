/*
 Copyright 2010 AdaptiveBlue Inc.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
*/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "GetGlueWidgetView.h"

@interface GluePopup : UIView <UIWebViewDelegate> {
	UIWebView* webview;
	UIButton* closeBtn;
	UIActivityIndicatorView* loadingSpinner;
	GetGlueWidgetView* widget;
	UIDeviceOrientation currentOrientation;
	UIView* overlay;
}

@property(nonatomic,assign) GetGlueWidgetView* widget;

- (void)showCheckinScreenWithParams: (NSString*) params;
- (void)setSizeForOrientation: (BOOL) animate;

@end
