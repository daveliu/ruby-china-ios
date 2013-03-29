//
//  RCReply.m
//  ruby-china
//
//  Created by NSRails autogen on 12/10/2012.
//  Copyright (c) 2012 jason. All rights reserved.
//

#import "Reply.h"

#import "User.h"
#import "Topic.h"

@implementation Reply
@synthesize user, topicId, body, bodyHtml, creatorAvatar, creatorLogin;


+(Reply *) initWithDictionary:(NSDictionary *)obj{
    Reply *reply = [[Reply alloc] init];
    
    reply.ID = [obj objectForKey:@"id"];
    reply.bodyHtml = [obj objectForKey:@"body_html"];
    
    NSString *dateStr =  [obj objectForKey:@"created_at"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'+08:00'"];
    reply.createdAt = [dateFormat dateFromString:dateStr];
    
    reply.creatorAvatar = [[obj objectForKey:@"user"] objectForKey:@"avatar_url"];
    reply.creatorLogin = [[obj objectForKey:@"user"] objectForKey:@"login"];
    
    return reply;
}

@end
