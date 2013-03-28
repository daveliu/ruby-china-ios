//
//  RCReply.h
//  ruby-china
//
//  Created by NSRails autogen on 12/10/2012.
//  Copyright (c) 2012 jason. All rights reserved.
//

@class User;
@class Topic;

@interface Reply : NSObject

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSString *body, *bodyHtml;
@property (nonatomic, strong) NSNumber *topicId;
@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSDate *createdAt;

@property (nonatomic, strong) NSString *creatorAvatar;
@property (nonatomic, strong) NSString *creatorLogin;

+ (Reply *) initWithDictionary:(NSDictionary *)dict;

@end
