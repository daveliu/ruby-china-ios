//
//  Preferences.h
//  RubyChina
//
//  Created by dave on 3/21/13.
//  Copyright (c) 2013 dave. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface Preferences : NSObject {
    
}

+ (NSString *) privateToken;
+ (void)setPrivateToken:(NSString *)value;

+ (NSString *) login;
+ (void) setLogin: (NSString *)value;

+ (NSString *) avatarUrl;
+ (void) setAvatarUrl: (NSString *)value;


@end
