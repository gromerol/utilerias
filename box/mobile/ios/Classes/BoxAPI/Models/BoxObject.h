
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
 * The BoxObjectModel is the base class for box files and folders. It contains information common to both and some utility methods that the folder and file
 * subclasses override.
 * BoxFileModels and FolderModels are most easily populated from the server by calling the functions in the BoxFolderXMLBuilder class. The properties can then
 * be accessed.
 * Some of these properties will be nil if the user has not populated them either through API calls or on the main box site.
 */
@interface BoxObject : NSObject {
	NSNumber *_objectId;
	NSString *_objectName;
	NSString *_objectDescription;
	NSString *_userId;
	bool _isShared;
	NSString *_sharedLink;
	NSString *_permissions;
	NSNumber *_objectSize;
	NSDate *_objectCreatedTime;
	NSDate *_objectUpdatedTime;
	NSIndexPath *_objectPath;
}
@property (retain) NSNumber *objectId;
@property (retain) NSString *objectName;
@property (retain) NSString *objectDescription;
@property (retain) NSString *userId;
@property bool isShared;
@property (retain) NSString *sharedLink;
@property (retain) NSString *permissions;
@property (retain) NSNumber *objectSize;
@property (retain) NSDate *objectCreatedTime;
@property (retain) NSDate *objectUpdatedTime;
@property (retain) NSIndexPath *objectPath;

- (id)initWithDictionary:(NSDictionary *)values;
- (void)setValuesWithDictionary:(NSDictionary *)values;
- (NSString *)objectToString;
- (NSMutableDictionary *)getValuesInDictionaryForm;
- (void)releaseAndNilValues;

@end
