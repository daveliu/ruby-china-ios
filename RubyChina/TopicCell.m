//
//  TopicCell.m
//  RubyChina
//
//  Created by dave on 3/25/13.
//  Copyright (c) 2013 dave. All rights reserved.
//

#import "TopicCell.h"
#import "NSDate+TimeAgo.h"

@implementation TopicCell

@synthesize topic;
@synthesize titleLabel = _titleLabel;
@synthesize timeLabel = _timeLabel;
@synthesize authorView = _authorView;
@synthesize repliesLabel = _repliesLabel;


#define CELL_WIDTH 320.0f
#define CELL_PADDING 10.0f
#define HEADSHOT_WIDTH 30.0f
#define TEXT_STATUS_PADDING 10.0f
#define TIME_LABEL_HEIGHT 14.0f
#define FONT_SIZE 18.0f
#define TIME_FONT_SIZE 14.0f
#define AUTHOR_VIEW_TAG 1
#define STATUS_VIEW_TAG 2
#define TEXT_VIEW_TAG 3
#define REPLY_VIEW_TAG 4
#define TIME_VIEW_TAG 5
#define TIMEICON_VIEW_TAG 6
#define REPLYICON_VIEW_TAG 7

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	if (!self.superview)
	{
		return;
	}
    
    //setup title view    
    CGFloat backgroundViewWidth = CELL_WIDTH - 2 * CELL_PADDING;    

    NSString *textToDisplay = self.topic.title;
    self.titleLabel.text = textToDisplay;
    CGSize constraint = CGSizeMake(backgroundViewWidth - 2 * TEXT_STATUS_PADDING, 20000.0f);
    
    CGFloat height = 0;
    CGSize size = [textToDisplay sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    height = size.height;
    self.titleLabel.frame = CGRectMake(CELL_PADDING, CELL_PADDING, backgroundViewWidth, height);
    
    
    //setup author view
    self.authorView.frame = CGRectMake(CELL_PADDING, height + CELL_PADDING + 5, HEADSHOT_WIDTH, HEADSHOT_WIDTH);
    [self.authorView setImageWithURL:[NSURL URLWithString:self.topic.creatorAvatar ]
               placeholderImage:[UIImage imageNamed:@"avatar.png"]];
    
    
    //setup time view    
    self.timeLabel.text =  [NSString stringWithFormat:@"%@ • %@", self.topic.creatorLogin, [self.topic.createdAt timeAgo]] ;
    self.timeLabel.frame = CGRectMake(50, height + CELL_PADDING + 15, 150, TIME_LABEL_HEIGHT);
    
    //setup reply view
    self.repliesLabel.text = [NSString stringWithFormat:@"%@个回复", [self.topic.repliesCount stringValue]] ;
    self.repliesLabel.frame = CGRectMake(200, height + CELL_PADDING + 15, 80, TIME_LABEL_HEIGHT);
    
    if (!self.attributedString) {
        self.attributedTextContextView.frame = CGRectMake(0,0,0,0);
    } else{
        CGSize neededSize = [self.attributedTextContextView suggestedFrameSizeToFitEntireStringConstraintedToWidth: 320-20];
        
        // after the first call here the content view size is correct
        CGRect frame = CGRectMake(10, height + HEADSHOT_WIDTH + 15, self.contentView.bounds.size.width - 20, neededSize.height + height + HEADSHOT_WIDTH + 15);
        self.attributedTextContextView.frame = frame;
    }
    
}

- (UILabel *)titleLabel
{
	if (!_titleLabel)
	{
        _titleLabel = [[UILabel alloc] init];
        
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:FONT_SIZE];
        _titleLabel.textColor = [UIColor colorWithRed:50.0/255 green:70.0/255 blue:95.0/255 alpha:1];
				
		[self.contentView addSubview:_titleLabel];
	}
	
	return _titleLabel;
}


- (UIImageView *)authorView{
    if (!_authorView){
        _authorView = [[UIImageView alloc] init];
        _authorView.layer.cornerRadius = 15.0f;
        _authorView.layer.masksToBounds = YES;
        [self.contentView addSubview:_authorView];
    }

    return _authorView;
}

- (UILabel *)timeLabel
{
	if (!_timeLabel)
	{
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:TIME_FONT_SIZE];
        _timeLabel.textColor = [UIColor grayColor];
        _timeLabel.backgroundColor = [UIColor clearColor];
        
		[self.contentView addSubview:_timeLabel];
	}
	
	return _timeLabel;
}

- (UILabel *)repliesLabel
{
	if (!_repliesLabel)
	{
        _repliesLabel = [[UILabel alloc] init];        
        _repliesLabel.font = [UIFont systemFontOfSize:TIME_FONT_SIZE];
        _repliesLabel.textColor = [UIColor grayColor];
        _repliesLabel.backgroundColor = [UIColor clearColor];
        
		[self.contentView addSubview:_repliesLabel];
	}
	
	return _repliesLabel;
}

@end
