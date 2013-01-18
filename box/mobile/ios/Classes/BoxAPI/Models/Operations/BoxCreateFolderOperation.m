
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

#import "BoxCreateFolderOperation.h"

@implementation BoxCreateFolderOperation

@synthesize name = _name;
@synthesize parentID = _parentID;
@synthesize share = _share;
@synthesize authToken = _authToken;
@synthesize folderID = _folderID;

+ (BoxCreateFolderOperation *)operationForFolderName:(NSString *)name
											parentID:(int)parentID
											   share:(BOOL)share
										   authToken:(NSString *)authToken
											delegate:(id<BoxOperationDelegate>)delegate
{
	return [[[BoxCreateFolderOperation alloc] initForFolderName:name
													   parentID:parentID
														  share:share
													  authToken:authToken 
													   delegate:delegate] autorelease];
}

- (id)initForFolderName:(NSString *)name
			   parentID:(int)parentID
				  share:(BOOL)share
			  authToken:(NSString *)authToken
			   delegate:(id<BoxOperationDelegate>)delegate
{
	if (self = [super initForType:BoxOperationTypeCreateFolder delegate:delegate]) {		
		self.name = name;
		self.parentID = parentID;
		self.share = share;
		self.authToken = authToken;
		self.summary = [NSString stringWithFormat:@"Creating folder \"%@\"…", name];
		self.folderID = -1;
	}

	return self;
}

- (void)dealloc {
	self.name = nil;
	self.authToken = nil;

	[super dealloc];
}

- (NSURL *)url {
	return [NSURL URLWithString:[BoxRESTApiFactory createFolderUrlStringForAuthToken:self.authToken
																			parentId:self.parentID
																				name:self.name
																			   share:self.share]];
}

- (NSString *)successCode {
	return @"create_ok";
}

- (NSArray *)resultKeysOfInterest {
	return [NSArray arrayWithObjects:@"status", @"folder_id", nil];
}

- (void)processResult:(NSDictionary *)result {
	self.folderID = [[result valueForKey:@"folder_id"] intValue];

	[super processResult:result];
}

- (void)processErrorCode:(NSString *)status {
	if ([status isEqualToString:@"no_parent"]) {
		[self setResponseType:BoxOperationResponseUnknownFolderID];
	} else {
		[super processErrorCode:status];
	}
}

@end
