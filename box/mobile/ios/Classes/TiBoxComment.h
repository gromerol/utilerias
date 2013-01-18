/**
 * Ti.Box Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiProxy.h"
#import "BoxComment.h"

@interface TiBoxComment : TiProxy {
    NSNumber* _commentId;
    NSString* _message;
    NSDate* _createdAt;
    NSString* _userName;
    NSNumber* _userId;
    NSURL* _avatarURL;
    NSArray* _replyComments;
}

-(id)initWithBoxComment:(BoxComment*)comment;

@property (retain, nonatomic) NSNumber *commentId;
@property (retain, nonatomic) NSString *message;
@property (retain, nonatomic) NSDate *createdAt;
@property (retain, nonatomic) NSString *userName;
@property (retain, nonatomic) NSNumber *userId;
@property (retain, nonatomic) NSURL *avatarURL;
@property (retain, nonatomic) NSArray *replyComments;

@end