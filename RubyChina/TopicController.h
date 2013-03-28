//
//  TopicController.h
//  RubyChina
//
//  Created by dave on 3/23/13.
//  Copyright (c) 2013 dave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Topic.h"
#import "HPGrowingTextView.h"
#import <DTCoreText.h>

@interface TopicController : UITableViewController <UITableViewDataSource, UITableViewDelegate, HPGrowingTextViewDelegate, DTAttributedTextContentViewDelegate>{
	UIView *containerView;
    HPGrowingTextView *textView;
}


@property (nonatomic, retain) Topic* topic;
@property (nonatomic, copy, readwrite)  NSMutableArray *replies;

-(void)resignTextView;

@end

