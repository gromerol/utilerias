
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
#import "BoxHTTPRequestBuilders.h"

#define BoxOperationErrorDomain @"net.box.operationError"

#define BoxOperationErrorRecoveryUI @"net.box.operationError.recoveryUI"
#define BoxOperationErrorRecoveryAction @"net.box.operationError.recoveryAction"

#define BoxOperationErrorRecoverySelectFolderUI @"net.box.operationError.recoveryUI.selectFolder"
#define BoxOperationErrorRecoveryRenameToUI @"net.box.operationError.recoveryUI.renameTo"
#define BoxOperationErrorRecoveryRenameToAction @"net.box.operationError.recoveryAction.renameTo"
#define BoxOperationErrorRecoveryRootFilesAction @"net.box.operationError.recoveryAction.rootFiles"

#define BoxOperationErrorRecoveryCurrentItemName @"net.box.operationError.currentItemName"
#define BoxOperationErrorRecoveryCurrentItemNames @"net.box.operationError.currentItemNames"
#define BoxOperationErrorRecoveryCurrentItemPath @"net.box.operationError.currentItemPath"
#define BoxOperationErrorRecoveryRootPath @"net.box.operationError.rootPath"

#define BoxOperationErrorRecoveryAvailableDestinationFolderNames @"net.box.operationError.availableDestinationFolderNames"
#define BoxOperationErrorRecoveryDefaultValue @"net.box.operationError.defaultValue"


typedef enum _BoxOperationType {
	BoxOperationTypeUpload = 1,
	BoxOperationTypeDownload,
	BoxOperationTypeCreateFolder,
	BoxOperationTypeMove,
	BoxOperationTypeRename,
	BoxOperationTypeToggleSync,
	BoxOperationTypeDelete,
	BoxOperationTypeLogout,
	BoxOperationTypeLogin,
	BoxOperationTypeMakeUpdate,
	BoxOperationTypeFileInfoUpdate,
	BoxOperationTypeFolderUpdate,
	BoxOperationTypeGetTicket,
	BoxOperationTypeGetAuthToken,
	BoxOperationTypeGetComments,
	BoxOperationTypeAddComment,
	BoxOperationTypeDeleteComment,
	BoxOperationTypePublicShare,
	BoxOperationTypePublicUnshare,
	BoxOperationTypePrivateShare,
	BoxOperationTypeGetUpdates,
	BoxOperationSimpleHTTPRequest
} BoxOperationType;

typedef enum _BoxOperationResponse {
	BoxOperationResponseNone = 0,
	BoxOperationResponseSuccessful,
	BoxOperationResponseNotLoggedIn,
	BoxOperationResponseWrongPermissions,
	BoxOperationResponseInvalidName,
	BoxOperationResponseAlreadyRegistered,
	BoxOperationResponseDiskError,
	BoxOperationResponseProtectedWriteError,
	BoxOperationResponseUnknownFolderID,
	BoxOperationResponseUserCancelled,
	BoxOperationResponseSyncStateAlreadySet,
	BoxOperationResponseInternalAPIError,
	BoxOperationResponseFilenameInUse,
    BoxOperationResponseWrongNode,
	BoxOperationResponseUnknownError = 100
} BoxOperationResponse;

@class BoxOperation;

@protocol BoxOperationDelegate
@optional
- (void)operationQueueWillBegin;
- (void)operationQueueDidComplete;

- (void)operation:(BoxOperation *)op willBeginForPath:(NSString *)path;
- (void)operation:(BoxOperation *)op didProgressForPath:(NSString *)path completionRatio:(NSNumber *)ratio;
- (void)operation:(BoxOperation *)op didCompleteForPath:(NSString *)path response:(BoxOperationResponse)response;

@end


@interface BoxOperation : NSOperation {
	id _response;
	id <BoxOperationDelegate> _delegate;
	
	BoxOperationType _operationType;
	BoxOperationResponse _operationResponse;
	NSError *_error;
	
	NSString *_summary;
}

@property (retain) id response;
@property (retain) NSError *error;
@property (retain) NSString *summary;
@property (assign) id delegate;
@property (assign) BoxOperationType operationType;
@property (assign) BoxOperationResponse operationResponse;

- (id)initForType:(BoxOperationType)type delegate:(id <BoxOperationDelegate>)delegate;
- (void)setResponseType:(BoxOperationResponse)responseType;
- (void)setResponseType:(BoxOperationResponse)responseType message:(NSString *)msg;
- (NSString *)messageForResponseType:(BoxOperationResponse)responseType;

@end
