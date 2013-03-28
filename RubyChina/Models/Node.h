//
//  RCNode.h
//  ruby-china
//
//  Created by NSRails autogen on 12/10/2012.
//  Copyright (c) 2012 jason. All rights reserved.
//


@class User;

@interface Node : NSObject

@property (nonatomic, strong) User *followers;
@property (nonatomic, strong) NSString *name, *summary;
@property (nonatomic, strong) NSNumber *sort, *topicsCount;
@property (nonatomic, strong) NSNumber *ID;


+ (Node *) initWithDictionary:(NSDictionary *)dict;

@end
