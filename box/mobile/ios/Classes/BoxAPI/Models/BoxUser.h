
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

/*
 * The BoxUser handles both transport of user information as well as saving, loading and clearing user information locally. 
 * The model contains only the user's name and the login auth token, not the password, because the password should never be stored locally.
 * The auth token is the only piece of information that needs to be used in communications with the server. 
 *
 * The first time the user wants to upload a file to box they should login by using the BoxLoginModelXMLBuilder to populate a UserModel. The
 * application should then save the relevant UserModel information by calling the saveUserInformation method. When the application needs
 * to upload a file or perform another operation for this user again it should allocate a BoxUser and then call -populateFromSavedDictionary
 * to get the saved values back into the Model;
 */

@interface BoxUser : NSObject {
	NSString *_authToken;

	NSString *_userName;
	NSString *_email;
	
	NSNumber *_accessId;
	NSNumber *_userId;
	
	NSNumber *_maxUploadSize;
	NSNumber *_storageQuota;
	NSNumber *_storageUsed;
}

@property (retain) NSString *authToken;

@property (retain) NSString *userName;
@property (retain) NSString *email;

@property (retain) NSNumber *accessId;
@property (retain) NSNumber *userId;

@property (retain) NSNumber *maxUploadSize;
@property (retain) NSNumber *storageQuota;
@property (retain) NSNumber *storageUsed;

@property (readonly) BOOL loggedIn;

+ (BoxUser *)userWithAttributes:(NSDictionary *)attributes;

+ (BoxUser *)savedUser;
+ (BOOL)clearSavedUser;

- (NSDictionary *)attributesDictionary;
- (NSArray *)attributeNames;

- (BOOL)save;
- (void)clear;
- (BOOL)loadFromDisk;

@end
