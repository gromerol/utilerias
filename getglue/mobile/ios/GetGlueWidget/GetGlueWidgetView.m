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

#import "GetGlueWidget.h"

@implementation GetGlueWidgetView

@synthesize delegate, objectKey, source;

- (id) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self != nil) {
		[self doPostInit];
	}
	return self;
}

-(void) doPostInit {
	source = @"";
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 64, 74);
	webview = [[[UIWebView alloc] initWithFrame:self.bounds] autorelease];
	webview.delegate = self;
	webview.opaque = NO;
	webview.backgroundColor = [UIColor clearColor];
	[self addSubview:webview];
}

-(id)initWithCoder:(NSCoder*)coder 
{
	[super initWithCoder: coder];
	[self doPostInit];
	return self;
}

-(void)setObjectKey: (NSString*) newObjectKey {    
	if (objectKey != newObjectKey) {
		[objectKey release];
		objectKey = [newObjectKey copy];
		[webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString: [NSString stringWithFormat: @"http://%@/html/checkinMobile.html?objectId=%@#%@", GETGLUE_WIDGET_HOST, objectKey,source]]]];	
	}
}

-(void)setSource: (NSString*) newSource {    
	if (source != newSource) {
		[source release];
		source = (NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)newSource, NULL, CFSTR("'\"?=&+<>;:-"), kCFStringEncodingUTF8);
		if(objectKey) {
			[webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString: [NSString stringWithFormat: @"http://%@/html/checkinMobile.html?objectId=%@#%@", GETGLUE_WIDGET_HOST, objectKey,source]]]];
		}
	}
}

- (void)didPerformCheckinForUser:(NSString*)username  {
	[webview stringByEvaluatingJavaScriptFromString:@"getglue.updateCount(1,true)"]; 
	if([self.delegate respondsToSelector:@selector(widget:didPerformCheckinForUser:)]) {
		[self.delegate widget:self didPerformCheckinForUser:username];
	}
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
	NSURL *url = request.URL;
	NSString *urlString = url.absoluteString;
	if ([urlString hasPrefix:@"getglue://newCount"]) {
		NSString *params = url.query;
		if([self.delegate respondsToSelector:@selector(widget:didRecieveNewCheckinCount:)]) {
			[self.delegate widget:self didRecieveNewCheckinCount:[params intValue]];
		}
		return NO;
	} if ([urlString hasPrefix:@"getglue://checkin"]) {
		NSString *params = url.query;
		
		GluePopup* popup = [[[GluePopup alloc] init] autorelease];
		popup.widget = self.self;
		[popup showCheckinScreenWithParams:params];
		return NO;
	}
	return YES;
}

@end
