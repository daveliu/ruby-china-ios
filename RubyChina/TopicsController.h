//
//  TopicsController.h
//  RubyChina
//
//  Created by dave on 3/22/13.
//  Copyright (c) 2013 dave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Node.h"

@interface TopicsController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy, readwrite)  NSMutableArray *topics;
@property (nonatomic, copy)  NSNumber *currentPage;
@property (nonatomic, strong)  Node *node;

@end
