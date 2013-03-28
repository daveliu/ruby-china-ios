//
//  UsersController.h
//  RubyChina
//
//  Created by dave on 3/25/13.
//  Copyright (c) 2013 dave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"


@interface UsersController : UITableViewController <UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSString *login;
@property (nonatomic, copy, readwrite)  NSMutableArray *topics;



@end
