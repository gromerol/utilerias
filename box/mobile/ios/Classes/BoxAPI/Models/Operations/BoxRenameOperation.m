
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

#import "BoxRenameOperation.h"

@implementation BoxRenameOperation

@synthesize targetID = _targetID;
@synthesize targetType = _targetType;
@synthesize destName = _destName;
@synthesize authToken = _authToken;

+ (BoxRenameOperation *)operationForTargetID:(int)targetID
								  targetType:(NSString *)targetType
							 destinationName:(NSString *)destName
								   authToken:(NSString *)authToken
									delegate:(id <BoxOperationDelegate>)delegate;
{
	return [[[BoxRenameOperation alloc] initForTargetID:targetID
											 targetType:targetType
										destinationName:destName
											  authToken:authToken
											   delegate:delegate] autorelease];
}

- (id)initForTargetID:(int)targetID
		   targetType:(NSString *)targetType
	  destinationName:(NSString *)destName
			authToken:(NSString *)authToken
			 delegate:(id <BoxOperationDelegate>)delegate;
{
	if ((self = [super initForType:BoxOperationTypeRename delegate:delegate])) {
		self.targetType = targetType;
		self.targetID = targetID;
		self.destName = destName;
		self.authToken = authToken;
	}

	return self;
}

- (void)dealloc {
	[super dealloc];
}

- (NSString *)successCode {
	return @"s_rename_node";
}

- (NSURL *)url {
	return [NSURL URLWithString:[BoxRESTApiFactory renameUrlStringForAuthToken:self.authToken 
																	targetType:self.targetType 
																	  targetID:self.targetID 
																	   newName:self.destName]];
}

@end
