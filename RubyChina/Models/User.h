//
//  RCUser.h
//  ruby-china
//
//  Created by NSRails autogen on 12/10/2012.
//  Copyright (c) 2012 jason. All rights reserved.
//


@class Topic;
@class Reply;
@class Node;

@interface User : NSObject

@property (nonatomic, strong) NSString *login,*email, *name, *location,*company, *twitter, *bio, *website, *githubUrl, *avatarUrl,*tagline;
@property (nonatomic, assign) BOOL emailPublic;


+ (UIImage *) defaultAvatarImage;

+ (BOOL) authorize: (NSString *) login password:(NSString *)password;

+ (User *) currentUser;
+ (void) checkLogin;

+ (User *) initWithDictionary:(NSDictionary *)dict;

@end
