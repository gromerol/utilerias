
//
// Copyright 2011 Box.net, Inc.
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.
//

#import "BoxPrivateShareOperation.h"

@implementation BoxPrivateShareOperation

@synthesize targetID = _targetID;
@synthesize targetType = _targetType;
@synthesize message = _message;
@synthesize emails = _emails;
@synthesize notify = _notify;
@synthesize authToken = _authToken;

+ (BoxPrivateShareOperation *)operationForTargetID:(int)targetID
										targetType:(NSString *)targetType
										   message:(NSString *)message
											emails:(NSArray *)emails
											notify:(BOOL)notify
										 authToken:(NSString *)authToken
										  delegate:(id<BoxOperationDelegate>)delegate
{
	return [[[BoxPrivateShareOperation alloc] initForTargetID:targetID
												   targetType:targetType
													  message:message
													   emails:emails
													   notify:notify
													authToken:authToken
													 delegate:delegate] autorelease];
}

- (id)initForTargetID:(int)targetID
		   targetType:(NSString *)targetType
			  message:(NSString *)message
			   emails:(NSArray *)emails
			   notify:(BOOL)notify
			authToken:(NSString *)authToken
			 delegate:(id<BoxOperationDelegate>)delegate
{
	if (self = [super initForType:BoxOperationTypePrivateShare delegate:delegate]) {
		self.targetID = targetID;
		self.targetType = targetType;
		self.message = message;
		self.emails = emails;
		self.notify = notify;
		self.authToken = authToken;
	}

	return self;
}

- (void)dealloc {
	self.targetType = nil;
	self.message = nil;
	self.emails = nil;
	self.authToken = nil;

	[super dealloc];
}

- (NSURL *)url {
	return [NSURL URLWithString:[BoxRESTApiFactory privateShareURLStringForAuthToken:self.authToken 
																			targetID:self.targetID
																		  targetType:self.targetType
																			 message:self.message
																			  emails:self.emails
																			  notify:self.notify]];
}

- (NSString *)successCode {
	return @"private_share_ok";
}

@end
