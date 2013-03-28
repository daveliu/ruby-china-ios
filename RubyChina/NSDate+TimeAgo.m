//
//  NSDate+TimeAgo.m
//  RubyChina
//
//  Created by dave on 3/23/13.
//  Copyright (c) 2013 dave. All rights reserved.
//

#import "NSDate+TimeAgo.h"

@implementation NSDate (TimeAgo)


- (NSString *)timeAgo {
    return [self coverTimeToString:NO];
}

- (NSString *) shortTimeAgo {
    return [self coverTimeToString:YES];
}

- (NSString *) coverTimeToString: (BOOL) isShort {
    NSString *dateString;
    
    
    // handle future date cases
    int days = [self daysFromNow];
    if (days > 200) {
        if (isShort) {
            dateString = [NSString stringWithFormat:@"%dd",days];
        }
        else {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd";
            dateString = [formatter stringFromDate:self];
        }
    }
    else if (days > 31) {
        if (isShort) {
            dateString = [NSString stringWithFormat:@"%dd",days];
        }
        else {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"MM月dd日";
            dateString = [formatter stringFromDate:self];
        }
    }
    else if (days == 0)  {
        if ([self hoursFromNow] == 0) {
            // if within 60 minutes print minutes
            NSInteger minutes = [self minutesFromNow];
            
            if (minutes == 0) {
                if (isShort) {
                    dateString = @"Now";
                }
                else {
                    dateString = @"刚刚";
                }
            }
            else {
                NSString *mark = isShort == YES ? @"m" : @"分钟前";
                dateString = [NSString stringWithFormat: @"%d%@", minutes,mark];
            }
        }
        else {
            // else print hours
            NSInteger hours = [self hoursFromNow];
            NSString *mark = isShort == YES ? @"h" : @"分钟前";
            dateString = [NSString stringWithFormat: @"%d%@", hours,mark];
        }
    }
    else if (days == 1) {
        dateString = isShort == YES ? @"1d" : @"昨天";
    }
    else if (days == 2) {
        dateString = isShort == YES ? @"2d" : @"两天前";
    }
    else {
        NSString *mark = isShort == YES ? @"d" : @"天前";
        dateString = [NSString stringWithFormat: @"%d%@", days,mark];
    }
    
    return dateString;
}



-(NSInteger) minutesFromNow {
    return ([self timeIntervalSinceNow] / 60) * -1;
}

-(NSInteger) hoursFromNow {
    return ([self timeIntervalSinceNow] / (60 * 60)) * -1;
}

-(NSInteger) daysFromNow{
    return ([self timeIntervalSinceNow] / ((60 * 60) * 24)) * -1;
}

-(NSInteger) monthsForNow {
    return round([self daysFromNow] / 30.5) * -1;
}


@end
