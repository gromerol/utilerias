/**
 * Ti.Box Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiModule.h"
#import "TiUIWebViewProxy.h"
#import "TiUIWebView.h"

#import "BoxUser.h"
#import "BoxOperation.h"
#import "BoxLoginBuilder.h"
#import "BoxFolderXMLBuilder.h"

#import "BoxRegisterOperation.h"
#import "BoxDownloadOperation.h"
#import "BoxUploadOperation.h"
#import "BoxMoveOperation.h"
#import "BoxCopyOperation.h"
#import "BoxRenameOperation.h"
#import "BoxDeleteOperation.h"
#import "BoxCreateFolderOperation.h"
#import "BoxPublicShareOperation.h"
#import "BoxPrivateShareOperation.h"
#import "BoxPublicUnshareOperation.h"
#import "BoxGetCommentsOperation.h"
#import "BoxAddCommentsOperation.h"
#import "BoxDeleteCommentOperation.h"
#import "BoxGetUpdatesOperation.h"

#import "TiBoxLoginViewProxy.h"
#import "TiBoxFolder.h"
#import "TiBoxUser.h"

#import "TiBoxRegisterDelegate.h"
#import "TiBoxSimpleDelegate.h"
#import "TiBoxGetCommentsDelegate.h"
#import "TiBoxGetUpdatesDelegate.h"

@interface TiBoxModule : TiModule <BoxLoginBuilderDelegate>
{
    BoxLoginBuilder *loginBuilder;
    KrollCallback* loginSuccessCallback;
    KrollCallback* loginErrorCallback;
}


@property (readonly, nonatomic) NSString* apiKey;
@property (readonly, nonatomic) TiBoxUser* user;

-(void)logout:(id)args;
-(void)login:(id)args;
-(void)registerUser:(id)args;

-(TiBoxFolder*)retrieveFolder:(id)args;
-(void)download:(id)args;
-(void)upload:(id)args;

-(void)move:(id)args;
-(void)copy:(id)args;
-(void)rename:(id)args;
-(void)remove:(id)args;
-(void)createFolder:(id)args;

-(void)publicShare:(id)args;
-(void)privateShare:(id)args;
-(void)publicUnshare:(id)args;

-(void)getComments:(id)args;
-(void)addComment:(id)args;
-(void)deleteComment:(id)args;

-(void)getUpdates:(id)args;
-(void)doLoginAction;

@property (readonly, nonatomic) NSNumber* UPDATE_TYPE_SENT;
@property (readonly, nonatomic) NSNumber* UPDATE_TYPE_DOWNLOADED;
@property (readonly, nonatomic) NSNumber* UPDATE_TYPE_COMMENTEDON;
@property (readonly, nonatomic) NSNumber* UPDATE_TYPE_MOVED;
@property (readonly, nonatomic) NSNumber* UPDATE_TYPE_UPDATED;
@property (readonly, nonatomic) NSNumber* UPDATE_TYPE_ADDED;
@property (readonly, nonatomic) NSNumber* UPDATE_TYPE_PREVIEWED;
@property (readonly, nonatomic) NSNumber* UPDATE_TYPE_DOWNLOADEDANDPREVIEWED;
@property (readonly, nonatomic) NSNumber* UPDATE_TYPE_COPIED;
@property (readonly, nonatomic) NSNumber* UPDATE_TYPE_LOCKED;
@property (readonly, nonatomic) NSNumber* UPDATE_TYPE_UNLOCKED;
@property (readonly, nonatomic) NSNumber* UPDATE_TYPE_ASSIGNEDTASK;
@property (readonly, nonatomic) NSNumber* UPDATE_TYPE_RESPONDEDTOTASK;

@end
