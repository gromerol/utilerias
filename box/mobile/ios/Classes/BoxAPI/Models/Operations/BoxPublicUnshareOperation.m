
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

#import "BoxPublicUnshareOperation.h"

@implementation BoxPublicUnshareOperation

@synthesize targetID = _targetID;
@synthesize targetType = _targetType;
@synthesize authToken = _authToken;

+ (BoxPublicUnshareOperation *)operationForTargetID:(int)targetID
										 targetType:(NSString *)targetType
										  authToken:(NSString *)authToken
										   delegate:(id<BoxOperationDelegate>)delegate
{
	return [[[BoxPublicUnshareOperation alloc] initForTargetID:targetID
													targetType:targetType
													 authToken:authToken
													  delegate:delegate] autorelease];
}

- (id)initForTargetID:(int)targetID
		   targetType:(NSString *)targetType
			authToken:(NSString *)authToken
			 delegate:(id<BoxOperationDelegate>)delegate
{
	if (self = [super initForType:BoxOperationTypePublicShare delegate:delegate]) {
		self.targetID = targetID;
		self.targetType = targetType;
		self.authToken = authToken;
	}

	return self;
}

- (void)dealloc {
	self.targetType = nil;
	self.authToken = nil;

	[super dealloc];
}

- (NSURL *)url {
	return [NSURL URLWithString:[BoxRESTApiFactory publicUnshareURLStringForAuthToken:self.authToken
																			 targetID:self.targetID
																		   targetType:self.targetType]];
}

- (NSString *)successCode {
	return @"unshare_ok";
}

@end
