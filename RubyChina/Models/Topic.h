//
//  RCTopic.h
//  ruby-china
//
//  Created by NSRails autogen on 12/10/2012.
//  Copyright (c) 2012 jason. All rights reserved.
//

#import <Mantle.h>
#import "User.h"


@interface Topic  :   NSObject  //MTLModel <MTLJSONSerializing>


@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, copy) NSString *title, *body, *bodyHtml, *nodeName, *lastReplyUserLogin;
@property (nonatomic, copy) NSNumber *repliesCount, *lastReplyUserId, *nodeId, *hits;
@property (nonatomic, strong) NSMutableArray *replies;
@property (nonatomic, strong) User *creator;
@property (nonatomic, strong) NSDate *repliedAt;
@property (nonatomic, strong) NSDate *createdAt;

@property (nonatomic, strong) NSString *creatorAvatar;
@property (nonatomic, strong) NSString *creatorLogin;


+ (Topic *) initWithDictionary:(NSDictionary *)dict;





@end
