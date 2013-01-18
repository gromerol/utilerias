/**
 * Ti.Box Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiBoxModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

@implementation TiBoxModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"82b11bc0-0f31-4407-b7b4-b82beb93f6e0";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"ti.box";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
	
	NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
	
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup 

-(void)dealloc
{
	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma Public APIs

@synthesize apiKey;
-(void)setApiKey:(NSString*)value
{
    [BoxRESTApiFactory changeBoxAPIKey:value];
}

# pragma mark Login and Registration Methods / Properties

@synthesize user;
-(TiBoxUser*)user
{
	return [[[TiBoxUser alloc] initWithBoxUser:[BoxUser savedUser]] autorelease];
}

-(void)logout:(id)args
{
	[BoxUser clearSavedUser];
}

-(void)registerUser:(id)args
{
	ENSURE_SINGLE_ARG(args,NSDictionary);
    
    TiBoxRegisterDelegate* del = [[TiBoxRegisterDelegate alloc]
                                  initWithProxy:self 
                                  success:[args objectForKey:@"success"] 
                                  error:[args objectForKey:@"error"]];
    
    BoxRegisterOperation* op = [[BoxRegisterOperation alloc] 
                                initForLogin:[args objectForKey:@"username"] 
                                password:[args objectForKey:@"password"] 
                                delegate:del];
    [op start];
}

-(void)login:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);
	ENSURE_SINGLE_ARG(args,NSDictionary);
    
    if (loginSuccessCallback != nil)
        [loginSuccessCallback release];
	loginSuccessCallback = [[args objectForKey:@"success"] retain];
    
    if (loginErrorCallback != nil)
        [loginErrorCallback release];
    loginErrorCallback = [[args objectForKey:@"error"] retain];
    
    TiBoxLoginViewProxy* loginView = [args objectForKey:@"view"];
    
    if (loginBuilder != nil)
        RELEASE_TO_NIL(loginBuilder);
    
    loginBuilder = [[BoxLoginBuilder alloc] initWithWebview:loginView.webView delegate:self];
    [loginBuilder startLoginProcess];
}

-(void)doLoginAction {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	[loginBuilder startLoginProcess];
    [pool release];
}

- (void)loginCompletedWithUser:(BoxUser *)val
{
    [val save];
	if (loginSuccessCallback != nil){
		[self _fireEventToListener:@"success" withObject:[NSMutableDictionary dictionary] listener:loginSuccessCallback thisObject:nil];
        [loginSuccessCallback release];
        loginSuccessCallback = nil;
	}
    RELEASE_TO_NIL(loginErrorCallback);
}

- (void)loginFailedWithError:(BoxLoginBuilderResponseType)response
{
	if (loginErrorCallback != nil){
		NSMutableDictionary *event = [NSMutableDictionary dictionary];
        
        switch (response) {
            default:
            case BoxLoginBuilderResponseTypeFailed:
                [event setObject:@"Please check your username and password and try again." forKey:@"error"];
                break;
        }
        
		[self _fireEventToListener:@"error" withObject:event listener:loginErrorCallback thisObject:nil];
        
        [loginErrorCallback release];
        loginErrorCallback = nil;
	}
    RELEASE_TO_NIL(loginSuccessCallback);
}

- (void)startActivityIndicator
{
	// Loading... we don't use this method, but being a delegate requires it be here.
}

- (void)stopActivityIndicator
{
	// Finished... we don't use this method, but being a delegate requires it be here.
}

#pragma mark -
#pragma mark Uploading and Downloading Methods

-(TiBoxFolder*)retrieveFolder:(id)args
{
    ENSURE_SINGLE_ARG_OR_NIL(args, NSNumber);
    if (args == nil) {
        args = [NSNumber numberWithInt:0];
    }
    
    BoxUser* userModel = [BoxUser savedUser];
	BoxFolderDownloadResponseType responseType = 0;
	BoxFolder* folderModel = [BoxFolderXMLBuilder folderForId:args token:userModel.authToken responsePointer:&responseType basePathOrNil:nil];
    
    switch ( responseType) {
        case boxFolderDownloadResponseTypeFolderSuccessfullyRetrieved:
            return [[TiBoxFolder alloc] initWithBoxFolder:folderModel];
        case boxFolderDownloadResponseTypeFolderNotLoggedIn:
            return [[TiBoxFolder alloc] initWithError:@"You must be logged in to retrieve this folder!"];
        case boxFolderDownloadResponseTypeFolderFetchError:
        default:
            return [[TiBoxFolder alloc] initWithError:@"We were not able to find that folder on the server!"];
    }
}

-(void)download:(id)args
{
	ENSURE_SINGLE_ARG(args,NSDictionary);
    int objectId = [[args objectForKey:@"objectId"] intValue];
    BoxUser* userModel = [BoxUser savedUser];
    NSURL* toURL = [TiUtils toURL:[args objectForKey:@"fileURL"] proxy:self];
    
    TiBoxSimpleDelegate* del = [[TiBoxSimpleDelegate alloc]
                                initWithProxy:self
                                success:[args objectForKey:@"success"]
                                error:[args objectForKey:@"error"]];
    del.type = @"download";
    BoxDownloadOperation* op = [[BoxDownloadOperation alloc]
                                initForFileID:objectId
                                localPath:[toURL path]
                                authToken:userModel.authToken
                                delegate:del];
    [op start];
}

-(void)upload:(id)args
{
    /*
     * parentID [int]
     * fileURL [string]: The URL to the file you would like to upload
     */
    
	ENSURE_SINGLE_ARG(args,NSDictionary);
    BoxUser* userModel = [BoxUser savedUser];
    int targetFolderId = [[args objectForKey:@"parentId"] intValue];
    NSURL* fromURL = [TiUtils toURL:[args objectForKey:@"fileURL"] proxy:self];
    
    NSError* error = nil;
    NSURLResponse* response = nil;
    NSURLRequest* fileUrlRequest = [[NSURLRequest alloc] initWithURL:fromURL];
    NSData* fileData = [NSURLConnection 
                        sendSynchronousRequest:fileUrlRequest
                        returningResponse:&response
                        error:&error];
    
    if (error == nil) {
        TiBoxSimpleDelegate* del = [[TiBoxSimpleDelegate alloc]
                                    initWithProxy:self
                                    success:[args objectForKey:@"success"]
                                    error:[args objectForKey:@"error"]];
        del.type = @"upload";
        BoxUploadOperation* op = [[BoxUploadOperation alloc]
                                  initForUser:userModel
                                  targetFolderId:targetFolderId
                                  data:fileData
                                  fileName: [fromURL lastPathComponent]
                                  contentType:[response MIMEType]
                                  shouldShare:NO
                                  message:nil
                                  emails:nil
                                  delegate:del];
        [op start];
    }
    else {
        if ([args objectForKey:@"error"] != nil) {
            NSMutableDictionary *event = [NSMutableDictionary dictionary];
            [event setObject:@"Unable to read the file you selected." forKey:@"error"];
            [self _fireEventToListener:@"error" withObject:event listener:[args objectForKey:@"error"] thisObject:nil];
        }
    }
    [fileUrlRequest release];
}

#pragma mark -
#pragma mark File and Folder Manipulation Methods

-(void)move:(id)args
{
	ENSURE_SINGLE_ARG(args,NSDictionary);
    int objectId = [[args objectForKey:@"objectId"] intValue];
    bool isFolder = [[args objectForKey:@"isFolder"] boolValue];
    int destinationFolderId = [[args objectForKey:@"destinationFolderId"] intValue];
    BoxUser* userModel = [BoxUser savedUser];
    
    TiBoxSimpleDelegate* del = [[TiBoxSimpleDelegate alloc]
                                initWithProxy:self
                                success:[args objectForKey:@"success"]
                                error:[args objectForKey:@"error"]];
    del.type = @"move";
    BoxMoveOperation* op = [[BoxMoveOperation alloc]
                            initForItemID:objectId
                            itemType:isFolder?@"folder":@"file"
                            destinationFolderID:destinationFolderId
                            authToken:userModel.authToken
                            delegate:del];
    [op start];
}

-(void)copy:(id)args
{
    ENSURE_SINGLE_ARG(args,NSDictionary);
    int objectId = [[args objectForKey:@"objectId"] intValue];
    bool isFolder = [[args objectForKey:@"isFolder"] boolValue];
    int destinationFolderId = [[args objectForKey:@"destinationFolderId"] intValue];
    BoxUser* userModel = [BoxUser savedUser];
    
    TiBoxSimpleDelegate* del = [[TiBoxSimpleDelegate alloc]
                                initWithProxy:self
                                success:[args objectForKey:@"success"]
                                error:[args objectForKey:@"error"]];
    del.type = @"copy";
    BoxCopyOperation* op = [[BoxCopyOperation alloc]
                            initForTargetId:objectId
                            targetType:isFolder?@"folder":@"file"
                            destinationId:destinationFolderId
                            authToken:userModel.authToken
                            delegate:del];
    [op start];
}

-(void)rename:(id)args
{
    ENSURE_SINGLE_ARG(args,NSDictionary);
    int objectId = [[args objectForKey:@"objectId"] intValue];
    bool isFolder = [[args objectForKey:@"isFolder"] boolValue];
    NSString* newName = [args objectForKey:@"newName"];
    BoxUser* userModel = [BoxUser savedUser];
    
    TiBoxSimpleDelegate* del = [[TiBoxSimpleDelegate alloc]
                                initWithProxy:self
                                success:[args objectForKey:@"success"]
                                error:[args objectForKey:@"error"]];
    del.type = @"rename";
    BoxRenameOperation* op = [[BoxRenameOperation alloc]
                              initForTargetID:objectId
                              targetType:isFolder?@"folder":@"file"
                              destinationName:newName
                              authToken:userModel.authToken
                              delegate:del];
    [op start];
}

-(void)remove:(id)args
{
    ENSURE_SINGLE_ARG(args,NSDictionary);
    int objectId = [[args objectForKey:@"objectId"] intValue];
    bool isFolder = [[args objectForKey:@"isFolder"] boolValue];
    BoxUser* userModel = [BoxUser savedUser];
    
    TiBoxSimpleDelegate* del = [[TiBoxSimpleDelegate alloc]
                                initWithProxy:self
                                success:[args objectForKey:@"success"]
                                error:[args objectForKey:@"error"]];
    del.type = @"delete";
    BoxDeleteOperation* op = [[BoxDeleteOperation alloc]
                              initForTargetId:objectId
                              targetType:isFolder?@"folder":@"file"
                              authToken:userModel.authToken
                              delegate:del];
    [op start];
}

-(void)createFolder:(id)args
{
    ENSURE_SINGLE_ARG(args,NSDictionary);
    NSString* name = [args objectForKey:@"name"]; 
    int parentFolderId = [[args objectForKey:@"parentFolderId"] intValue];
    BoxUser* userModel = [BoxUser savedUser];
    
    TiBoxSimpleDelegate* del = [[TiBoxSimpleDelegate alloc]
                                initWithProxy:self
                                success:[args objectForKey:@"success"]
                                error:[args objectForKey:@"error"]];
    del.type = @"create folder";
    BoxCreateFolderOperation* op = [[BoxCreateFolderOperation alloc]
                                    initForFolderName:name
                                    parentID:parentFolderId
                                    share:NO
                                    authToken:userModel.authToken
                                    delegate:del];
    [op start];
}

#pragma mark -
#pragma mark Sharing Methods

-(void)publicShare:(id)args
{
    ENSURE_SINGLE_ARG(args,NSDictionary);
    
    BoxUser* userModel = [BoxUser savedUser];
    int objectId = [[args objectForKey:@"objectId"] intValue];
    bool isFolder = [[args objectForKey:@"isFolder"] boolValue];
    NSString* password = [args objectForKey:@"password"];
    NSMutableArray* emailAddresses = [[NSMutableArray alloc] init];
    for (NSString* email in [args objectForKey:@"emailAddresses"]) {
        [emailAddresses addObject:email];
    }
    NSString* message = [args objectForKey:@"message"];
    
    TiBoxSimpleDelegate* del = [[TiBoxSimpleDelegate alloc]
                                initWithProxy:self
                                success:[args objectForKey:@"success"]
                                error:[args objectForKey:@"error"]];
    del.type = @"public share";
    BoxPublicShareOperation* op = [[BoxPublicShareOperation alloc]
                                   initForTargetID:objectId
                                   targetType:isFolder?@"folder":@"file"
                                   password:password
                                   message:message
                                   emails:emailAddresses
                                   authToken:userModel.authToken
                                   delegate:del];
    [op start];
}

-(void)privateShare:(id)args
{
    ENSURE_SINGLE_ARG(args,NSDictionary);
    
    BoxUser* userModel = [BoxUser savedUser];
    int objectId = [[args objectForKey:@"objectId"] intValue];
    bool isFolder = [[args objectForKey:@"isFolder"] boolValue];
    NSMutableArray* emailAddresses = [[NSMutableArray alloc] init];
    for (NSString* email in [args objectForKey:@"emailAddresses"]) {
        [emailAddresses addObject:email];
    }
    NSString* message = [args objectForKey:@"message"];
    bool notify = [[args objectForKey:@"notifyWhenViewed"] boolValue];
    
    TiBoxSimpleDelegate* del = [[TiBoxSimpleDelegate alloc]
                                initWithProxy:self
                                success:[args objectForKey:@"success"]
                                error:[args objectForKey:@"error"]];
    del.type = @"private share";
    BoxPrivateShareOperation* op = [[BoxPrivateShareOperation alloc]
                                    initForTargetID:objectId
                                    targetType:isFolder?@"folder":@"file"
                                    message:message
                                    emails:emailAddresses
                                    notify:notify
                                    authToken:userModel.authToken
                                    delegate:del];
    [op start];
}

-(void)publicUnshare:(id)args
{
    ENSURE_SINGLE_ARG(args,NSDictionary);
    
    BoxUser* userModel = [BoxUser savedUser];
    int objectId = [[args objectForKey:@"objectId"] intValue];
    bool isFolder = [[args objectForKey:@"isFolder"] boolValue];    
    
    TiBoxSimpleDelegate* del = [[TiBoxSimpleDelegate alloc]
                                initWithProxy:self
                                success:[args objectForKey:@"success"]
                                error:[args objectForKey:@"error"]];
    del.type = @"public unshare";
    BoxPublicUnshareOperation* op = [[BoxPublicUnshareOperation alloc]
                                     initForTargetID:objectId
                                     targetType:isFolder?@"folder":@"file"
                                     authToken:userModel.authToken
                                     delegate:del];
    [op start];
}

#pragma mark -
#pragma mark Comments Methods

-(void)getComments:(id)args
{
    ENSURE_SINGLE_ARG(args,NSDictionary);
    
    BoxUser* userModel = [BoxUser savedUser];
    int objectId = [[args objectForKey:@"objectId"] intValue];
    bool isFolder = [[args objectForKey:@"isFolder"] boolValue];     
    
    TiBoxGetCommentsDelegate* del = [[TiBoxGetCommentsDelegate alloc]
                                     initWithProxy:self
                                     success:[args objectForKey:@"success"]
                                     error:[args objectForKey:@"error"]];
    BoxGetCommentsOperation* op = [[BoxGetCommentsOperation alloc]
                                   initForTargetID:objectId
                                   targetType:isFolder?@"folder":@"file"
                                   authToken:userModel.authToken
                                   delegate:del];
    [op start];
}

-(void)addComment:(id)args
{
    ENSURE_SINGLE_ARG(args,NSDictionary);
    
    BoxUser* userModel = [BoxUser savedUser];
    int objectId = [[args objectForKey:@"objectId"] intValue];
    bool isFolder = [[args objectForKey:@"isFolder"] boolValue];
    NSString* message = [args objectForKey:@"message"];
    
    TiBoxSimpleDelegate* del = [[TiBoxSimpleDelegate alloc]
                                initWithProxy:self
                                success:[args objectForKey:@"success"]
                                error:[args objectForKey:@"error"]];
    del.type = @"add comment";
    BoxAddCommentsOperation* op = [[BoxAddCommentsOperation alloc]
                                   initForTargetID:objectId
                                   targetType:isFolder?@"folder":@"file"
                                   message:message
                                   authToken:userModel.authToken
                                   delegate:del];
    [op start];
}

-(void)deleteComment:(id)args
{
    ENSURE_SINGLE_ARG(args,NSDictionary);
    
    BoxUser* userModel = [BoxUser savedUser];
    int commentId = [[args objectForKey:@"commentId"] intValue];
    
    TiBoxSimpleDelegate* del = [[TiBoxSimpleDelegate alloc]
                                initWithProxy:self
                                success:[args objectForKey:@"success"]
                                error:[args objectForKey:@"error"]];
    del.type = @"delete comment";
    BoxDeleteCommentOperation* op = [[BoxDeleteCommentOperation alloc]
                                     initForCommentID:commentId
                                     authToken:userModel.authToken
                                     delegate:del];
    [op start];
}

#pragma mark -
#pragma mark Updates Methods

-(void)getUpdates:(id)args
{
    ENSURE_SINGLE_ARG(args,NSDictionary);
    
    BoxUser* userModel = [BoxUser savedUser];
    NSDate* time = [args objectForKey:@"sinceTime"];
    
    TiBoxGetUpdatesDelegate* del = [[TiBoxGetUpdatesDelegate alloc]
                                    initWithProxy:self
                                    success:[args objectForKey:@"success"]
                                    error:[args objectForKey:@"error"]];
    BoxGetUpdatesOperation* op = [[BoxGetUpdatesOperation alloc]
                                  initForStartTime:time
                                  authToken:userModel.authToken
                                  delegate:del];
    [op start];
}

MAKE_SYSTEM_PROP(UPDATE_TYPE_SENT, BoxUpdateTypeSent);
MAKE_SYSTEM_PROP(UPDATE_TYPE_DOWNLOADED, BoxUpdateTypeDownloaded);
MAKE_SYSTEM_PROP(UPDATE_TYPE_COMMENTEDON, BoxUpdateTypeCommentedOn);
MAKE_SYSTEM_PROP(UPDATE_TYPE_MOVED, BoxUpdateTypeMoved);
MAKE_SYSTEM_PROP(UPDATE_TYPE_UPDATED, BoxUpdateTypeUpdated);
MAKE_SYSTEM_PROP(UPDATE_TYPE_ADDED, BoxUpdateTypeAdded);
MAKE_SYSTEM_PROP(UPDATE_TYPE_PREVIEWED, BoxUpdateTypePreviewed);
MAKE_SYSTEM_PROP(UPDATE_TYPE_DOWNLOADEDANDPREVIEWED, BoxUpdateTypeDownloadedAndPreviewed);
MAKE_SYSTEM_PROP(UPDATE_TYPE_COPIED, BoxUpdateTypeCopied);
MAKE_SYSTEM_PROP(UPDATE_TYPE_LOCKED, BoxUpdateTypeLocked);
MAKE_SYSTEM_PROP(UPDATE_TYPE_UNLOCKED, BoxUpdateTypeUnlocked);
MAKE_SYSTEM_PROP(UPDATE_TYPE_ASSIGNEDTASK, BoxUpdateTypeAssignedTask);
MAKE_SYSTEM_PROP(UPDATE_TYPE_RESPONDEDTOTASK, BoxUpdateTypeRespondedToTask);

@end
