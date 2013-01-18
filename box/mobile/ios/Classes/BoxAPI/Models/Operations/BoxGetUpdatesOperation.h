
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

#import "BoxAPIOperation.h"

@interface BoxGetUpdatesOperation : BoxAPIOperation {
	NSDate *_updatesStart;
	NSString *_authToken;
	
	NSArray *_updates;
}

@property (retain) NSDate *updatesStart;
@property (retain) NSString *authToken;

@property (readonly) NSArray *updates;

+ (BoxGetUpdatesOperation *)operationForStartTime:(NSDate *)updatesStart
										authToken:(NSString *)authToken
										 delegate:(id <BoxOperationDelegate>)delegate;

- (id)initForStartTime:(NSDate *)updatesStart
			 authToken:(NSString *)authToken
			  delegate:(id <BoxOperationDelegate>)delegate;

@end
