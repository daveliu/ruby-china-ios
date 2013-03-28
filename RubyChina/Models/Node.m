//
//  RCNode.m
//  ruby-china
//
//  Created by NSRails autogen on 12/10/2012.
//  Copyright (c) 2012 jason. All rights reserved.
//

#import "Node.h"

#import "User.h"

@implementation Node
@synthesize  followers, name, sort, topicsCount, summary;


+(Node *) initWithDictionary:(NSDictionary *)obj{
    Node *node = [[Node alloc] init];
    node.name = [obj objectForKey:@"name"];
    node.ID = [obj objectForKey:@"id"];
    
    return node;
}


@end
