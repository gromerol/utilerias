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
 
 ---
 
 Some of this code is based on http://github.com/facebook/facebook-iphone-sdk/blob/master/src/FBDialog.m by Facebook
 
*/

#import "GetGlueWidget.h"

@implementation GluePopup

@synthesize widget;

BOOL ggIsPad() {
	#ifdef UI_USER_INTERFACE_IDIOM
		return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
	#else
		return NO;
	#endif
}

- (id) init {
	CGRect rect = ggIsPad() ? CGRectMake(3, 23, 487, 760) : CGRectMake(3, 23, 314, 454);
	self = [super initWithFrame: rect];
	if (self != nil) {
		self.backgroundColor = [UIColor clearColor];
		[self setClipsToBounds:YES];
        
        
		loadingSpinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
		[self addSubview:loadingSpinner];
        
		webview = [[[UIWebView alloc] initWithFrame:CGRectMake(10, 47, rect.size.width-20, rect.size.height-72)] autorelease];
		webview.backgroundColor = [UIColor clearColor];
        webview.opaque = NO;
		webview.delegate = self;
		
		if(ggIsPad()){
		for (id subview in webview.subviews)
			if ([[subview class] isSubclassOfClass: [UIScrollView class]])
				((UIScrollView *)subview).scrollEnabled = NO;
		}
		
		[self addSubview:webview];
		
		
		closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		[closeBtn setImage:[UIImage imageNamed:@"modules/ti.getglue/getglue_close.png"] forState:UIControlStateNormal];
		closeBtn.frame = CGRectMake(rect.size.width-45, 11, 35, 35);
		[closeBtn addTarget:self action:@selector(closePopup:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:closeBtn];
		
		[self setSizeForOrientation:NO];
	}
	return self;
}


-(void) dealloc {
	webview.delegate = nil;
    [webview stopLoading];
    [super dealloc];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
	
	// window
	CGContextSaveGState(context);
		CGContextSetShadow(context, CGSizeMake(0, 0), 20);
		CGContextSetRGBFillColor(context, 0.87f, 0.87f, 0.87f, 1.0f);
		
		CGRect drawrect = CGRectInset(rect, 10, 10);
		
		CGFloat radius = 10.0;	
		CGFloat minx = CGRectGetMinX(drawrect), midx = CGRectGetMidX(drawrect), maxx = CGRectGetMaxX(drawrect);
		CGFloat miny = CGRectGetMinY(drawrect), midy = CGRectGetMidY(drawrect), maxy = CGRectGetMaxY(drawrect);	
		CGContextMoveToPoint(context, minx, midy);
		CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
		CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
		CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
		CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
		CGContextClosePath(context);
		CGContextDrawPath(context, kCGPathFill);
	CGContextRestoreGState(context);
	
	// logo
	CGContextSaveGState(context);
		[[UIImage imageNamed:@"modules/ti.getglue/getglue_logo.png"] drawInRect: CGRectMake(20, 19, 72, 18)];
	CGContextRestoreGState(context);
	
	CGContextSaveGState(context);
		CGContextSetLineWidth(context, 1);
	
		// Top lines
		CGContextSetRGBStrokeColor(context, 0.68f,0.68f,0.68f,1.0f);
		CGContextMoveToPoint(context, minx, miny+35.5);
		CGContextAddLineToPoint(context, maxx, miny+35.5);
		CGContextStrokePath(context);
		CGContextMoveToPoint(context, minx, maxy-14.5);
		CGContextAddLineToPoint(context, maxx, maxy-14.5);
		CGContextStrokePath(context);
	
		// Bottom lines
		CGContextSetRGBStrokeColor(context, 1.0f,1.0f,1.0f,1.0f);		
		CGContextMoveToPoint(context, minx, miny+36.5);
		CGContextAddLineToPoint(context, maxx, miny+36.5);
		CGContextStrokePath(context);
		CGContextMoveToPoint(context, minx, maxy-13.5);
		CGContextAddLineToPoint(context, maxx, maxy-13.5);
		CGContextStrokePath(context);
	CGContextRestoreGState(context);
	
}

- (IBAction) closePopup:(id) sender {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(cleanup)];
	overlay.alpha = 0;
	self.alpha = 0;
	[UIView commitAnimations];
}

- (void)cleanup {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceOrientationDidChangeNotification" object:nil];
	[self removeFromSuperview];
	[overlay removeFromSuperview];
}


- (CGAffineTransform)transformForOrientation {
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	if (orientation == UIInterfaceOrientationLandscapeLeft) {
		return CGAffineTransformMakeRotation(M_PI*1.5);
	} else if (orientation == UIInterfaceOrientationLandscapeRight) {
		return CGAffineTransformMakeRotation(M_PI/2);
	} else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
		return CGAffineTransformMakeRotation(-M_PI);
	} else {
		return CGAffineTransformIdentity;
	}
}

- (BOOL)shouldRotateToOrientation:(UIDeviceOrientation)orientation {
	if (orientation == currentOrientation) {
		return NO;
	} else {
		return orientation == UIDeviceOrientationLandscapeLeft
		|| orientation == UIDeviceOrientationLandscapeRight
		|| orientation == UIDeviceOrientationPortrait
		|| orientation == UIDeviceOrientationPortraitUpsideDown;
	}
}

- (void)setSizeForOrientation: (BOOL) animate {
	UIDeviceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	currentOrientation = orientation;
	
	CGRect screenFrame = [UIScreen mainScreen].applicationFrame;
	CGPoint center = CGPointMake(
								 screenFrame.origin.x + ceil(screenFrame.size.width/2),
								 screenFrame.origin.y + ceil(screenFrame.size.height/2));
	if (animate) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:[UIApplication sharedApplication].statusBarOrientationAnimationDuration];
	}
	
	self.transform = [self transformForOrientation];
	CGRect newSize;
	if (UIInterfaceOrientationIsLandscape(orientation)) {
		newSize = ggIsPad() ? CGRectMake(3, 23, 487, 760) : CGRectMake(3, 23, 300, 314);
		self.frame = newSize;
		if(ggIsPad()){ center.x -= 0.5; }
		self.center = center;
		webview.frame = CGRectMake(10, 47, newSize.size.height-20, newSize.size.width-72);
		closeBtn.frame = CGRectMake(newSize.size.height-45, 11, 35, 35);
	} else {
		newSize = ggIsPad() ? CGRectMake(3, 23, 760, 487) : CGRectMake(3, 23, 314, 454);
		self.frame = newSize;
		if(ggIsPad()){ center.y -= 0.5; }
		self.center = center;
		webview.frame = CGRectMake(10, 47, newSize.size.width-20, newSize.size.height-72);
		closeBtn.frame = CGRectMake(newSize.size.width-45, 11, 35, 35);
	}
	loadingSpinner.center = webview.center;
	
	if (animate) {
		[UIView commitAnimations];
	}
	[self setNeedsDisplay];
	
}

- (void)orientationDidChange:(void*)object {
	if ([self shouldRotateToOrientation:[UIApplication sharedApplication].statusBarOrientation]) {
		[self setSizeForOrientation:YES];
	}
}

- (void)phase2 {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.15];
	self.transform = [self transformForOrientation];
	[UIView commitAnimations];
}

-(void)showCheckinScreenWithParams: (NSString*) params {
	UIWindow* window = [UIApplication sharedApplication].keyWindow;
	if (!window) {
		window = [[UIApplication sharedApplication].windows objectAtIndex:0];
	}
	
	overlay = [[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
	overlay.alpha = 0;
	overlay.backgroundColor = [UIColor blackColor];
	[window addSubview: overlay];
	
	
	[window addSubview:self];
	
	
	self.transform = CGAffineTransformScale([self transformForOrientation], 0.001, 0.001);
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.2];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(phase2)];
	overlay.alpha = 0.25;
	self.transform = CGAffineTransformScale([self transformForOrientation], 1.1, 1.1);
	[UIView commitAnimations];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(orientationDidChange:)
												 name:@"UIDeviceOrientationDidChangeNotification" object:nil];
	
	[loadingSpinner startAnimating];
	[webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString: [NSString stringWithFormat: @"http://%@/widget/checkin?style=%@&app=mobileWidget_%@&%@", GETGLUE_POPUP_HOST, ggIsPad() ? @"tablet" : @"mobile",  GETGLUE_WIDGET_VERSION, params]]]];	
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	
	[loadingSpinner stopAnimating];
	[loadingSpinner setHidden:YES];
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
	NSURL *url = request.URL;
	NSString *urlString = url.absoluteString;
	//NSLog(urlString);
	if ([urlString hasPrefix:@"getglue://userDidCheckin"]) {
		NSString *params = url.query;
		[self.widget didPerformCheckinForUser:params]; 	
		return NO;
	} if ([urlString rangeOfString:@"getglue.com/widget/"].location == NSNotFound && 
		  [urlString rangeOfString:@"getglue.com/signup/"].location == NSNotFound && 
		  [urlString rangeOfString:@"getglue.com/verifyService/"].location == NSNotFound && 
		  [urlString rangeOfString:@"facebook.com/"].location == NSNotFound && 
		  [urlString rangeOfString:@"twitter.com/"].location == NSNotFound ) {
		NSLog(@"external URL detected");
		BOOL launchInSafari = true;
		if([self.widget.delegate respondsToSelector:@selector(widget:shouldLaunchURL:)]) {
			launchInSafari = [self.widget.delegate widget:self.widget shouldLaunchURL:url];
		}
		if(launchInSafari){
			NSLog(@"launching safari");
			[[UIApplication sharedApplication] openURL:url];
		}
		return NO;
	} else {
		return YES;
	}
}

@end
