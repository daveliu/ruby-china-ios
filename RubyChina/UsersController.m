//
//  UsersController.m
//  RubyChina
//
//  Created by dave on 3/25/13.
//  Copyright (c) 2013 dave. All rights reserved.
//

#import "UsersController.h"

#import "AppDelegate.h"
#import "User.h"
#import "Topic.h"
#import "TopicCell.h"
#import "Preferences.h"
#import "TopicController.h"
#import "LoginController.h"

@interface UsersController ()

@end

@implementation UsersController 

@synthesize user;
@synthesize topics;
@synthesize login;

- (void)viewDidLoad
{
    [super viewDidLoad];
            
    self.title = @"用户";
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.tableView.separatorColor = [UIColor colorWithRed:211.0/255 green:211.0/255 blue:211.0/255 alpha:0.2];
    
    if (!self.login) {
        self.login = [Preferences login];
    }
    
    if (!self.topics) {
        [self getRemoteData];
    }
}


- (void)getRemoteData {
    MKNetworkOperation *currentOp =  [ApplicationDelegate.remoteEngine user:self.login];
    
    [currentOp onCompletion:^(MKNetworkOperation* completedRequest) {
        NSDictionary *response = [completedRequest responseJSON];
        
        self.user = [User initWithDictionary:response];
        
        MKNetworkOperation *op =  [ApplicationDelegate.remoteEngine userTopics:[NSNumber numberWithInt:1] login:self.user.login];
        
        [op onCompletion:^(MKNetworkOperation* completedRequest) {
            NSArray *response = [completedRequest responseJSON];
            
            NSMutableArray *ary =  [[NSMutableArray alloc] init] ;
            [response  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                Topic *topic = [Topic initWithDictionary:obj];
                topic.creatorAvatar = self.user.avatarUrl;
                topic.creatorLogin = self.user.login;
                [ary addObject:topic];
            }];
            
            self.topics = ary;
            [self.tableView reloadData];
            
        } onError:^(NSError* error) {
            [SVProgressHUD showErrorWithStatus:@"网络不给力啊"];
        }];    
        
    } onError:^(NSError* error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力啊"];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numRows = 0;
    
    if (section == 0) {
        numRows = 1;
    } else{
        numRows = [self.topics count];
    }
    
    return numRows;
}

NSString * const TopicCellIdentifier = @"TopicCell";

- (TopicCell *)tableView:(UITableView *)tableView preparedCellForIndexPath:(NSIndexPath *)indexPath
{
	TopicCell *cell =  nil;
    // reuse does not work for variable height
    cell = (TopicCell *)[tableView dequeueReusableCellWithIdentifier:TopicCellIdentifier];
    
    // legacy, as of iOS 6 this always returns a cell
    if (!cell)
    {
        cell = [[TopicCell alloc] initWithReuseIdentifier:TopicCellIdentifier];
    }
    
    [cell setTopic:[self.topics objectAtIndex:indexPath.row]];    
	
	return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"UserCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        
   //     cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"deep.png"]];
        
        UIImageView *authorView = [[UIImageView alloc] init];
        authorView.layer.cornerRadius = 40.0f;
        authorView.layer.masksToBounds = YES;
        authorView.frame = CGRectMake(5, 5, 80, 80);
        [authorView setImageWithURL:[NSURL URLWithString: self.user.avatarUrl ]
                        placeholderImage:[UIImage imageNamed:@"avatar.png"]];
        
        [cell.contentView addSubview:authorView];
        
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = [UIFont systemFontOfSize:25.0];
        timeLabel.textColor = [UIColor blackColor];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.text =  self.user.login ;
        timeLabel.frame = CGRectMake(90, 25, 150, 50);
        
		[cell.contentView addSubview:timeLabel];
        
        UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [logoutBtn setTitle:@"退出" forState:UIControlStateNormal];
        [logoutBtn setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
        [logoutBtn addTarget:self action:@selector(logout)
             forControlEvents:UIControlEventTouchUpInside];
        [logoutBtn setFrame:CGRectMake(200, 25, 80, 40)];
        [logoutBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
        logoutBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
        
		[cell.contentView addSubview:logoutBtn];
        
        
        UILabel *bioLabel = [[UILabel alloc] init];
        bioLabel.font = [UIFont systemFontOfSize:16.0];
        bioLabel.textColor = [UIColor blackColor];
        bioLabel.backgroundColor = [UIColor clearColor];        
        bioLabel.text = self.user.bio;

        CGSize constraint = CGSizeMake(320 - 2 * 10, 20000.0f);
        
        CGFloat height = 0;
        CGSize size = [self.user.bio sizeWithFont:[UIFont systemFontOfSize:16.0] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        height = size.height;
        bioLabel.frame = CGRectMake(10, 100, 300, height);
        
        [cell.contentView addSubview:bioLabel];
        
    } else{
        cell = (TopicCell *)[self tableView:tableView preparedCellForIndexPath:indexPath];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}


-(void)logout{
    [Preferences setPrivateToken:NULL];
    [Preferences setLogin:NULL];
    [Preferences setAvatarUrl:NULL];
    
    LoginController *controller = [[LoginController alloc] init];
    [self.tabBarController presentViewController:controller animated:YES completion:^{} ];
}



#pragma mark - Table view delegate

#define CELL_WIDTH 320.0f
#define CELL_PADDING 10.0f
#define HEADSHOT_WIDTH 30.0f
#define TEXT_STATUS_PADDING 10.0f
#define TIME_LABEL_HEIGHT 14.0f
#define FONT_SIZE 18.0f
#define TIME_FONT_SIZE 14.0f

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    CGFloat height = 70.0f;
    
    if (indexPath.section == 0) {        
        CGSize constraint = CGSizeMake(320 - 2 * 10, 20000.0f);
        
        CGSize size = [self.user.bio sizeWithFont:[UIFont systemFontOfSize:16.0] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        height = size.height + 120.0f;
    }else{
        CGFloat backgroundViewWidth = CELL_WIDTH - 3 * CELL_PADDING - HEADSHOT_WIDTH;
        
        Topic *topic = [self.topics objectAtIndex:indexPath.row];
        
        NSString *textToDisplay = topic.title;
        CGSize constraint = CGSizeMake(backgroundViewWidth - 2 * TEXT_STATUS_PADDING, 20000.0f);
        CGSize size = [textToDisplay sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        height = size.height;
        height = height + HEADSHOT_WIDTH + 2 * (CELL_PADDING ) + 10;
        height = MAX(height , 70.0f);
    }
    
    
    return height;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
    }else{
        Topic *topic = [self.topics objectAtIndex:indexPath.row];
        
        TopicController *topicController = [[TopicController alloc] init];
        topicController.topic = topic;
        topicController.hidesBottomBarWhenPushed = YES;        
        [self.navigationController pushViewController:topicController animated:YES];
    }
    
}

@end
