//
//  TopicCell.h
//  RubyChina
//
//  Created by dave on 3/25/13.
//  Copyright (c) 2013 dave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTAttributedTextCell.h"
#import "Topic.h"

@interface TopicCell : DTAttributedTextCell

@property (nonatomic, strong) Topic *topic;


@property (nonatomic, readonly) UILabel *titleLabel ;
@property (nonatomic, readonly) UILabel *timeLabel ;
@property (nonatomic, readonly) UILabel *repliesLabel ;
@property (nonatomic, readonly) UIImageView *authorView ;

@end
