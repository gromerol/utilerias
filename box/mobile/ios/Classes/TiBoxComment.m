/**
 * Ti.Box Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiBoxComment.h"

@implementation TiBoxComment

-(id)initWithBoxComment:(BoxComment *)comment
{
    if ((self = [super init]))
    {
        _commentId = comment.objectId;
        _message = comment.message;
        _createdAt = comment.createdAt;
        _userName = comment.userName;
        _userId = comment.userID;
        _avatarURL = comment.avatarURL;
        NSMutableArray* replies = [[NSMutableArray alloc] init];
        for (BoxComment* replyComment in comment.replyComments)
        {
            TiBoxComment* tiReplyComment = [[TiBoxComment alloc] initWithBoxComment:replyComment];
            [replies addObject:tiReplyComment];
        }
        _replyComments = replies;
    }
    return self;
}

@synthesize commentId = _commentId;
@synthesize message = _message;
@synthesize createdAt = _createdAt;
@synthesize userName = _userName;
@synthesize userId = _userId;
@synthesize avatarURL = _avatarURL;
@synthesize replyComments = _replyComments;

@end
