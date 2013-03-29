//
//  NewTopicController.m
//  RubyChina
//
//  Created by dave on 3/27/13.
//  Copyright (c) 2013 dave. All rights reserved.
//

#import "NewTopicController.h"
#import "TopicsController.h"
#import "AppDelegate.h"

@interface NewTopicController ()

@end

@implementation NewTopicController
@synthesize titleTextView;
@synthesize bodyTextView;
@synthesize nodeButton;
@synthesize node;


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
//    [self.titleTextView becomeFirstResponder];
    
    //listen to the keyboard show notification
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWasShown:)
//                                                 name:UIKeyboardDidShowNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
//    self.title = @"发帖";
    
    
    //text view
    self.titleTextView = [[GCPlaceholderTextView alloc] init];
    self.titleTextView.delegate = self;
    self.titleTextView.font = [UIFont systemFontOfSize:16.0f];
    [self.view addSubview:self.titleTextView];
    self.titleTextView.frame = CGRectMake(5, 5, self.view.bounds.size.width, 50);
    
    self.bodyTextView = [[GCPlaceholderTextView alloc] init];
    self.bodyTextView.delegate = self;
    self.bodyTextView.font = [UIFont systemFontOfSize:16.0f];
    [self.view addSubview:self.bodyTextView];
    self.bodyTextView.frame = CGRectMake(5, 65, self.view.bounds.size.width, 200);
    
    self.titleTextView.placeholder = @"标题";
    
    self.bodyTextView.placeholder = @"正文";
        
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"style:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];

    [self.navigationItem.leftBarButtonItem setBackgroundImage:[[UIImage imageNamed:@"navbutton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonSystemItemDone target:self action:@selector(save:)];
    
    [self.navigationItem.rightBarButtonItem setBackgroundImage:[[UIImage imageNamed:@"navbutton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
}


- (void) cancel: (id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) save: (UIBarButtonItem* )sender {
    MKNetworkOperation *currentOp =  [ApplicationDelegate.remoteEngine  createTopic:self.titleTextView.text body:self.bodyTextView.text node_id:self.node.ID];
    
    [currentOp onCompletion:^(MKNetworkOperation* completedRequest) {
        DLog(@"-------------------------%@", completedRequest);
        [self.navigationController popToRootViewControllerAnimated:YES];
        [SVProgressHUD showSuccessWithStatus:@"发表成功"];

        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"createTopic" object:nil];
        
        
    } onError:^(NSError* error) {
        [SVProgressHUD showErrorWithStatus:@"error happen"];
    }];
}

@end
