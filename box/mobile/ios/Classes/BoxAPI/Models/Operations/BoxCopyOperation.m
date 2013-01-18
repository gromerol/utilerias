
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

#import "BoxCopyOperation.h"
#import "BoxRESTApiFactory.h"

@implementation BoxCopyOperation

@synthesize authToken = _authToken;
@synthesize targetType = _targetType;
@synthesize targetId = _targetId;
@synthesize destinationId = _destinationId;

+ (BoxCopyOperation *)operationForTargetId:(int)targetId
								targetType:(NSString *)targetType
							 destinationId:(int)destinationId
								 authToken:(NSString *)authToken
								  delegate:(id<BoxOperationDelegate>)delegate
{
	return [[[BoxCopyOperation alloc] initForTargetId:targetId
										   targetType:targetType
										destinationId:destinationId
											authToken:authToken
											 delegate:delegate] autorelease];
}

- (id)initForTargetId:(int)targetId
		   targetType:(NSString *)targetType
		destinationId:(int)destinationId
			authToken:(NSString *)authToken
			 delegate:(id <BoxOperationDelegate>)delegate
{
	if ((self = [super initForType:BoxOperationTypeMove delegate:delegate])) {
		self.targetId = targetId;
		self.targetType = targetType;
		self.destinationId = destinationId;
		self.authToken = authToken;
	}

	return self;
}

- (NSURL *)url {
	return [NSURL URLWithString:[BoxRESTApiFactory copyUrlStringForAuthToken:self.authToken 
																  targetType:self.targetType 
																	targetId:self.targetId 
															   destinationId:self.destinationId]];
}

- (NSString *)successCode {
	return @"s_copy_node";
}

@end
