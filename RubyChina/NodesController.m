//
//  NodesController.m
//  RubyChina
//
//  Created by dave on 3/25/13.
//  Copyright (c) 2013 dave. All rights reserved.
//

#import "NodesController.h"
#import "AppDelegate.h"
#import "RemoteEngine.h"
#import "Node.h"
#import "TopicsController.h"
#import "NewTopicController.h"

@interface NodesController ()

@end

@implementation NodesController

@synthesize nodes;
@synthesize newTopic;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"节点";
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.tableView.separatorColor = [UIColor colorWithRed:211.0/255 green:211.0/255 blue:211.0/255 alpha:0.2];
    
    if (!self.nodes) {
        [self getRemoteData];
    }
}



- (void)getRemoteData {
    MKNetworkOperation *currentOp =  [ApplicationDelegate.remoteEngine nodes];
    
    [currentOp onCompletion:^(MKNetworkOperation* completedRequest) {
        DLog(@"%@", completedRequest);
        NSArray *response = [completedRequest responseJSON];
        
        NSMutableArray *ary =  [[NSMutableArray alloc] init] ;
        [response  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Node *node = [Node initWithDictionary:obj];
            [ary addObject:node];
        }];
        
        self.nodes = ary;
        [self.tableView reloadData];        
        
    } onError:^(NSError* error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力啊"];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.nodes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    Node *node = [self.nodes objectAtIndex:indexPath.row];
    cell.textLabel.text = node.name;
    
    cell.textLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:20.0f];
    cell.textLabel.textColor = [UIColor colorWithRed:50.0/255 green:70.0/255 blue:95.0/255 alpha:1];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Node *node = [self.nodes objectAtIndex:indexPath.row];
    
    if (self.newTopic) {
        NewTopicController *controller = [[NewTopicController alloc] init];
        controller.node = node;
        controller.title = [NSString stringWithFormat:@"发帖：%@", node.name ];
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        TopicsController *topicsController = [[TopicsController alloc] init];
        topicsController.node = node;
        
        UIButton *backButton = [[UIButton alloc] init];
        
        [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(back:)
             forControlEvents:UIControlEventTouchUpInside];
        [backButton setFrame:CGRectMake(0, 0, 49, 30)];
        
        topicsController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton] ;
        topicsController.title = node.name;
        
        [self.navigationController pushViewController:topicsController animated:YES];
    }

    
}

- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
