
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
#import "BoxOperation.h"

@class BoxUser;

@interface BoxUploadOperation : BoxOperation {
    BoxUser *_user;
	int _folderId;
	NSData *_data;
	NSString *_fileName;
	NSString *_dataContentType;
	BOOL _shouldShare;
	NSString *_message;
	NSArray *_emails;
	
	BOOL _isExecuting;
	BOOL _isFinished;
}

@property (retain) BoxUser *user;
@property (assign) int folderId;
@property (retain) NSData *data;
@property (retain) NSString *fileName;
@property (retain) NSString *dataContentType;
@property (assign) BOOL shouldShare;
@property (retain) NSString *message;
@property (retain) NSArray *emails;

+ (BoxUploadOperation *)operationForUser:(BoxUser *)user
						  targetFolderId:(int)folderId
									data:(NSData *)data
								fileName:(NSString *)fileName
							 contentType:(NSString *)contentType
							 shouldShare:(BOOL)shouldShare
								 message:(NSString *)message
								  emails:(NSArray *)emails
								delegate:(id<BoxOperationDelegate>)delegate;

- (id)initForUser:(BoxUser *)user
   targetFolderId:(int)folderId
			 data:(NSData *)data
		 fileName:(NSString *)fileName
	  contentType:(NSString *)contentType
	  shouldShare:(BOOL)shouldShare
		  message:(NSString *)message
		   emails:(NSArray *)emails
		 delegate:(id<BoxOperationDelegate>)delegate;

@end
