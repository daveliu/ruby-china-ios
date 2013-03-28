//
//  NSString+IsEmpty.m
//  RubyChina
//
//  Created by dave on 3/28/13.
//  Copyright (c) 2013 dave. All rights reserved.
//

#import "NSString+IsEmpty.h"

@implementation NSString (IsEmpty)


    - (BOOL)isEmpty {
        NSCharacterSet *charSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimmed = [self stringByTrimmingCharactersInSet:charSet];
        return [trimmed isEqualToString:@""];
    }

@end
