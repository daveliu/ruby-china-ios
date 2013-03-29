//
//  TopicsController.m
//  RubyChina
//
//  Created by dave on 3/22/13.
//  Copyright (c) 2013 dave. All rights reserved.
//

#import "TopicsController.h"
#import "AppDelegate.h"
#import "Topic.h"
#import "NSDate+TimeAgo.h"
#import "TopicController.h"
#import "TopicCell.h"
#import <SVPullToRefresh.h>
#import "NodesController.h"

@interface TopicsController ()

@end

@implementation TopicsController

@synthesize topics = _topics;
@synthesize currentPage;
@synthesize node;

- (void)getRemoteData {
    MKNetworkOperation *currentOp = nil;
    
    if (!self.node) {
       currentOp =  [ApplicationDelegate.remoteEngine topics:[NSNumber numberWithInt:1] ];
    }else{
       currentOp =  [ApplicationDelegate.remoteEngine node:self.node.ID];
    }

    
    [currentOp onCompletion:^(MKNetworkOperation* completedRequest) {
        DLog(@"%@", completedRequest);        
        NSArray *response = [completedRequest responseJSON];

        NSMutableArray *ary =  [[NSMutableArray alloc] init] ;
        [response  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Topic *topic = [Topic initWithDictionary:obj];
            [ary addObject:topic];
        }];

        self.topics = ary;
        
    } onError:^(NSError* error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力啊"];
    }];
}

- (void)getOldRemoteData {
    
    if (!self.currentPage){
        self.currentPage = [NSNumber numberWithInt:2];
    }else{
        self.currentPage  = [NSNumber numberWithInt:[self.currentPage intValue] + 1];
    }
        
    MKNetworkOperation *currentOp =  [ApplicationDelegate.remoteEngine topics:self.currentPage ];
    
    
    [currentOp onCompletion:^(MKNetworkOperation* completedRequest) {
        DLog(@"%@", completedRequest);
        NSArray *response = [completedRequest responseJSON];
        
        NSMutableArray *ary =  [[NSMutableArray alloc] init] ;
        [response  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Topic *topic = [Topic initWithDictionary:obj];
            [ary addObject:topic];
        }];
        NSMutableArray *dataCopy = [self.topics mutableCopy];
        [dataCopy addObjectsFromArray:ary];
        self.topics = [NSArray arrayWithArray:dataCopy];
        
    } onError:^(NSError* error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力啊"];
    }];
}

- (void) setTopics:(NSMutableArray *)data {
    if (![_topics isEqualToArray:data]){
        _topics = [data mutableCopy];
        [self.tableView reloadData];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.title = @"社区";
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    if (!self.topics) {
        [self getRemoteData];
    }
    
    __weak TopicsController *weakSelf = self;
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakSelf getRemoteData];            
            [weakSelf.tableView.pullToRefreshView stopAnimating];
        });        
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        
        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakSelf getOldRemoteData];
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
        });
    }];
    
    UIButton *rightButton = [[UIButton alloc] init];
    
    [rightButton setImage:[UIImage imageNamed:@"new_message.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(selectNode:)
          forControlEvents:UIControlEventTouchUpInside];
    [rightButton setFrame:CGRectMake(0, 0, 49, 30)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton] ;
        
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.tableView.separatorColor = [UIColor colorWithRed:211.0/255 green:211.0/255 blue:211.0/255 alpha:0.2];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(triggerPull:) name:@"createTopic" object:nil];
}

- (void)triggerPull: (NSNotification *)notification
{
    [self.tableView triggerPullToRefresh];
}

- (void)selectNode: (UIBarButtonItem* )sender {
    NodesController *controller = [[NodesController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    controller.newTopic = YES;
    controller.title = @"选择节点";
    
    UIButton *backButton = [[UIButton alloc] init];    
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back:)
         forControlEvents:UIControlEventTouchUpInside];
    [backButton setFrame:CGRectMake(0, 0, 49, 30)];
    
    controller.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton] ;
    [self.navigationController pushViewController:controller animated:YES];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.topics count];
}


NSString * const CellIdentifier = @"Cell";

- (TopicCell *)tableView:(UITableView *)tableView preparedTopicCellForIndexPath:(NSIndexPath *)indexPath
{
	TopicCell *cell =  nil;
    // reuse does not work for variable height
    cell = (TopicCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // legacy, as of iOS 6 this always returns a cell
    if (!cell)
    {
        cell = [[TopicCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    Topic *topic = [self.topics objectAtIndex:indexPath.row];
    [cell setTopic:topic];
	
	return cell;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = nil;
    
    cell = (TopicCell *)[self tableView:tableView preparedTopicCellForIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#define CELL_WIDTH 320.0f
#define CELL_PADDING 10.0f
#define HEADSHOT_WIDTH 30.0f
#define TEXT_STATUS_PADDING 10.0f
#define TIME_LABEL_HEIGHT 14.0f
#define FONT_SIZE 18.0f
#define TIME_FONT_SIZE 14.0f

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 70.0f;
    CGFloat backgroundViewWidth = CELL_WIDTH - 3 * CELL_PADDING - HEADSHOT_WIDTH;
    
    Topic *topic = [self.topics objectAtIndex:indexPath.row];
    
    NSString *textToDisplay = topic.title;
    CGSize constraint = CGSizeMake(backgroundViewWidth - 2 * TEXT_STATUS_PADDING, 20000.0f);
    CGSize size = [textToDisplay sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    height = size.height;
    height = height + HEADSHOT_WIDTH + 2 * (CELL_PADDING ) + 10;
    height = MAX(height , 70.0f);
    
    return height;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Topic *topic = [self.topics objectAtIndex:indexPath.row];
    
    TopicController *topicController = [[TopicController alloc] init];
    topicController.topic = topic;
    topicController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:topicController animated:YES];
    
}


- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
