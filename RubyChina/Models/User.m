//
//  RCUser.m
//  ruby-china
//
//  Created by NSRails autogen on 12/10/2012.
//  Copyright (c) 2012 jason. All rights reserved.
//

#import "User.h"
#import "Topic.h"
#import "Reply.h"
#import "Node.h"

static UIImage *defaultAvatarImage;

@implementation User
@synthesize email, name, twitter, location, bio, website, avatarUrl,githubUrl, tagline, login;

static User *_currentUser;

+(User *) initWithDictionary:(NSDictionary *)obj{
    User *user = [[User alloc] init];
    
    user.avatarUrl = [obj objectForKey:@"avatar_url"];
    user.login = [obj objectForKey:@"login"];
    user.name = [obj objectForKey:@"name"];
    user.email = [obj objectForKey:@"email"];
    user.githubUrl = [obj objectForKey:@"github_url"];
    user.bio = [obj objectForKey:@"bio"];
    
    return user;
}

+ (User *) currentUser {
    return _currentUser;
}



@end
