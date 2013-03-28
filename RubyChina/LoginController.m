//
//  LoginController.m
//  RubyChina
//
//  Created by dave on 3/22/13.
//  Copyright (c) 2013 dave. All rights reserved.
//

#import "LoginController.h"
#import "Preferences.h"
#import "TopicsController.h"
#import "NSData+Base64.h"
#import "RemoteEngine.h"
#import "AppDelegate.h"

@interface LoginController ()

@end

@implementation LoginController

@synthesize loginButton;
@synthesize loginField;
@synthesize passwordField;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = @"";
    [[self navigationController] setNavigationBarHidden:YES];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
    
    
    UIImageView *logoView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    logoView.frame = CGRectMake(60, 60, 200, 60);
    [self.view addSubview:logoView];
    
    self.loginField = [[UITextField alloc] initWithFrame:CGRectMake(35, 150, 255, 40)];
    self.loginField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.loginField.font = [UIFont systemFontOfSize:18.0f];
    self.loginField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.loginField.borderStyle = UITextBorderStyleRoundedRect;
    self.loginField.placeholder = @"用户名";
    
    self.loginField.text = [Preferences login];
    self.loginField.tag = 1;
    self.loginField.delegate = self;
    [self.view addSubview:self.loginField];
    
    
    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(35, 200, 255, 40)];
    self.passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordField.font = [UIFont systemFontOfSize:18.0f];
    self.passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.passwordField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordField.placeholder = @"密码";
    self.passwordField.secureTextEntry = YES;
    self.passwordField.tag = 2;
    self.passwordField.delegate = self;
    [self.view addSubview:self.passwordField];
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginButton.frame = CGRectMake(35, 250, 255, 42);
    UIImage *bg = [[UIImage imageNamed:@"button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(6,6,6,6)];
    [self.loginButton setBackgroundImage:bg forState:UIControlStateNormal];
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginButton setBackgroundColor:[UIColor clearColor]];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(loginIsPressed:)
               forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:self.loginButton];
    
}


- (void) loginIsPressed:(UIButton *)sender{
    NSString *login = [self.loginField text];
    NSString *password = [self.passwordField text];    
    [Preferences setLogin:login];
    
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", login, password];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authHeader = [NSString stringWithFormat:@"Basic %@", [authData nsr_base64Encoding]];
    
    NSMutableDictionary *headerFields = [NSMutableDictionary dictionary];
    [headerFields setValue:authHeader forKey:@"Authorization"];
    
    RemoteEngine *remoteEngine = [[RemoteEngine alloc] initWithHostName:BaseDomain
                                            customHeaderFields:headerFields];
    
    MKNetworkOperation *currentOp =  [remoteEngine login:login password:password];
    
    
    [SVProgressHUD showWithStatus:@"正在登录..."];
    
    [currentOp onCompletion:^(MKNetworkOperation* completedRequest) {
        [SVProgressHUD dismiss];
        DLog(@"%@", completedRequest);
        NSDictionary *response = [completedRequest responseJSON];
                
        NSString *token = [response objectForKey:@"private_token"];
        [Preferences setPrivateToken:[NSString stringWithFormat:@"%@",token]];
        [Preferences setLogin:[response objectForKey:@"login"]];
        
        //get user avatar url
        MKNetworkOperation *currentOp =  [ApplicationDelegate.remoteEngine user:[Preferences login] ];
        
        [ApplicationDelegate.tabBarController dismissViewControllerAnimated:YES completion:^{}];
        
        [currentOp onCompletion:^(MKNetworkOperation* completedRequest) {
            DLog(@"%@", completedRequest);
            NSDictionary *response = [completedRequest responseJSON];
            [Preferences setAvatarUrl:[response objectForKey:@"avatar_url"]];
            
        } onError:^(NSError* error) {
            [SVProgressHUD showErrorWithStatus:@"网络不给力啊"];
        }];
    
        
    } onError:^(NSError* error) {
        [SVProgressHUD dismiss];
        DLog(@"%@", error);
        [SVProgressHUD showErrorWithStatus:@"用户名或密码错误"];
    }];
    
}



#pragma mark - UITextFieldDelegate

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    BOOL loginActive =  [self.loginField isFirstResponder] && ([touch view] != self.loginField);
    BOOL passwordActive =  [self.passwordField isFirstResponder] && ([touch view] != self.passwordField);
    if (loginActive || passwordActive) {
        [self.loginField resignFirstResponder];
        [self.passwordField resignFirstResponder];
        [self animateView:0];
    }
    [super touchesBegan:touches withEvent:event];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSUInteger tag = [textField tag];
    [self animateView:tag];
}

// Textfield value changed, store the new value.
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self animateView:0];
    return YES;
}


- (void)animateView:(NSUInteger)tag
{
    CGRect rect = self.view.frame;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    if (tag > 0) {
        rect.origin.y = -120.0f;
    } else {
        rect.origin.y = 20.0f;
    }
    self.view.frame = rect;
    [UIView commitAnimations];
}



@end
