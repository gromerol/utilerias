
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

#import "BoxMoveOperation.h"


@implementation BoxMoveOperation

@synthesize itemID = _itemID;
@synthesize itemType = _itemType;
@synthesize destFolderID = _destFolderID;
@synthesize authToken = _authToken;

+ (BoxMoveOperation *)operationForItemID:(int)_itemID
								itemType:(NSString *)_itemType
					 destinationFolderID:(int)_destFolderID
							   authToken:(NSString *)authToken
								delegate:(id<BoxOperationDelegate>)delegate
{
	return [[[BoxMoveOperation alloc] initForItemID:_itemID
										   itemType:_itemType
								destinationFolderID:_destFolderID
										  authToken:authToken
										   delegate:delegate] autorelease];
}

- (id)initForItemID:(int)itemID
		   itemType:(NSString *)itemType
destinationFolderID:(int)destFolderID
		  authToken:(NSString *)authToken
		   delegate:(id<BoxOperationDelegate>)delegate
{
	if (self = [super initForType:BoxOperationTypeMove delegate:delegate]) {
		self.itemID = itemID;
		self.itemType = itemType;
		self.destFolderID = destFolderID;
		self.authToken = authToken;
	}
	
	return self;
}

- (void)dealloc {
	self.itemType = nil;
	self.authToken = nil;

	[super dealloc];
}

- (NSURL *)url {
	return [NSURL URLWithString:[BoxRESTApiFactory moveURLStringForAuthToken:self.authToken
																  targetType:self.itemType
																	targetID:self.itemID
															   destinationID:self.destFolderID]];
}

- (NSString *)successCode {
	return @"s_move_node";
}

@end
