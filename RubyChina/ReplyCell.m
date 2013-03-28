//
//  ReplyCell.m
//  RubyChina
//
//  Created by dave on 3/24/13.
//  Copyright (c) 2013 dave. All rights reserved.
//

#import "ReplyCell.h"

@implementation ReplyCell


- (void)layoutSubviews
{
	[super layoutSubviews];
	
	if (!self.superview)
	{
		return;
	}

//    CGFloat neededContentHeight = [self requiredRowHeightInTableView:(UITableView *)self.superview];

	CGSize neededSize = [self.attributedTextContextView suggestedFrameSizeToFitEntireStringConstraintedToWidth: 320-40];
    
    // after the first call here the content view size is correct
    CGRect frame = CGRectMake(40, 30, self.contentView.bounds.size.width - 40, neededSize.height);
    self.attributedTextContextView.frame = frame;
}

@end
