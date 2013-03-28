//
//  RCTopic.m
//  ruby-china
//
//  Created by NSRails autogen on 12/10/2012.
//  Copyright (c) 2012 jason. All rights reserved.
//

#import "Topic.h"
#import "User.h"
#import "Node.h"
#import "Reply.h"

@implementation Topic


+(Topic *) initWithDictionary:(NSDictionary *)obj{
    Topic *topic = [[Topic alloc] init];
    
    topic.ID = [obj objectForKey:@"id"];
    topic.bodyHtml = [obj objectForKey:@"body_html"];
    topic.title = [obj objectForKey:@"title"];
    topic.repliesCount = [obj objectForKey:@"replies_count"];
        
    NSString *dateStr =  [obj objectForKey:@"created_at"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'+08:00'"];
    topic.createdAt = [dateFormat dateFromString:dateStr];
    
    topic.creatorAvatar = [[obj objectForKey:@"user"] objectForKey:@"avatar_url"];
    topic.creatorLogin = [[obj objectForKey:@"user"] objectForKey:@"login"];
    
    return topic;
}

@end
