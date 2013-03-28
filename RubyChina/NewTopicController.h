//
//  NewTopicController.h
//  RubyChina
//
//  Created by dave on 3/27/13.
//  Copyright (c) 2013 dave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Node.h"
#import "GCPlaceholderTextView.h"

@interface NewTopicController : UIViewController

@property (nonatomic, strong) GCPlaceholderTextView *titleTextView;
@property (nonatomic, strong) GCPlaceholderTextView *bodyTextView;
@property (nonatomic, strong) UIButton *nodeButton;
@property (nonatomic, retain) Node *node;


@end
