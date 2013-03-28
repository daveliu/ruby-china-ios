//
//  Preferences.m
//  RubyChina
//
//  Created by dave on 3/21/13.
//  Copyright (c) 2013 dave. All rights reserved.
//

#import "Preferences.h"


@implementation Preferences

+ (NSString *) privateToken {
    return [[self userDefatuls] stringForKey:@"private_token"];
}
+ (void)setPrivateToken:(NSString *)value {
    [self setValue:value forKey:@"private_token"];
}


+ (NSString *) avatarUrl {
    return [[self userDefatuls] stringForKey:@"avatar_url"];
}
+ (void)setAvatarUrl:(NSString *)value{
    [self setValue:value forKey:@"avatar_url"];
}

+ (NSString *) login {
    return [[self userDefatuls] stringForKey:@"login"];
}
+ (void) setLogin: (NSString *)value {
    [self setValue:value forKey:@"login"];
}

+ (NSString *) password {
    return [[self userDefatuls] stringForKey:@"password"];
}
+ (void) setPassword:(NSString *)value {
    [self setValue:value forKey:@"password"];
}

#pragma mark - Private
+ (NSUserDefaults *) userDefatuls {
    return [NSUserDefaults standardUserDefaults];
}

+ (void) setValue:(id) value forKey:(NSString *) key {
    [[self userDefatuls] setValue:value forKey:key];
    [[self userDefatuls] synchronize];
}


@end
