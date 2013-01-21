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

@protocol GetGlueWidgetDelegate;

@interface GetGlueWidgetView : UIView <UIWebViewDelegate> {
	id<GetGlueWidgetDelegate> delegate;
	UIWebView* webview;
	NSString* objectKey;
	NSString* source;
}

@property (nonatomic,assign) id<GetGlueWidgetDelegate> delegate;
@property (copy) NSString* objectKey;
@property (copy) NSString* source;

// private
- (void) doPostInit;
- (void)didPerformCheckinForUser:(NSString*)username;

@end

@protocol GetGlueWidgetDelegate <NSObject>
@optional
- (BOOL)widget:(GetGlueWidgetView*) widget shouldLaunchURL:(NSURL*) url;
- (void)widget:(GetGlueWidgetView*) widget didRecieveNewCheckinCount:(int) newCount;
- (void)widget:(GetGlueWidgetView*) widget didPerformCheckinForUser: (NSString*) username;
@end
