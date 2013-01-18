
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

#import <Foundation/Foundation.h>

#import "BoxAPIOperation.h"

@interface BoxCopyOperation : BoxAPIOperation {
	NSString *_authToken;
	NSString *_targetType;
	int _targetId;
	int _destinationId;
}

@property (retain) NSString *authToken;
@property (retain) NSString *targetType;
@property (assign) int targetId;
@property (assign) int destinationId;

+ (BoxCopyOperation *)operationForTargetId:(int)targetId
								targetType:(NSString *)targetType
							 destinationId:(int)destinationId
								 authToken:(NSString *)authToken
								  delegate:(id <BoxOperationDelegate>)delegate;

- (id)initForTargetId:(int)targetId
		   targetType:(NSString *)targetType
		destinationId:(int)destinationId
			authToken:(NSString *)authToken
			 delegate:(id <BoxOperationDelegate>)delegate;

@end
