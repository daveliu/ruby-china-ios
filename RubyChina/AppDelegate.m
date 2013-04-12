//
//  AppDelegate.m
//  RubyChina
//
//  Created by dave on 3/21/13.
//  Copyright (c) 2013 dave. All rights reserved.
//

#import "AppDelegate.h"
#import "RemoteEngine.h"
#import "LoginController.h"
#import "Preferences.h"
#import "TopicsController.h"
#import "NodesController.h"
#import "UsersController.h"
#import "AboutController.h"
#import "NSString+IsEmpty.h"


@implementation AppDelegate

@synthesize remoteEngine;
@synthesize navController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.remoteEngine = [[RemoteEngine alloc] initWithHostName:BaseDomain];
    [self.remoteEngine useCache];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navbar.png"] forBarMetrics:UIBarMetricsDefault];
    
    application.statusBarStyle = UIStatusBarStyleBlackOpaque;    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    TopicsController *topicsController = [[TopicsController alloc] init];
    topicsController.tabBarItem.title = @"社区";
    topicsController.tabBarItem.image = [UIImage imageNamed:@"tab1.png"];
    UINavigationController *navController0 = [[UINavigationController alloc] initWithRootViewController:topicsController];

    
    NodesController *nodesController = [[NodesController alloc] init];
    UINavigationController *navController1 = [[UINavigationController alloc] initWithRootViewController:nodesController];
    navController1.tabBarItem.title = @"节点";
    navController1.tabBarItem.image = [UIImage imageNamed:@"tab2.png"];
    
    UsersController *usersController = [[UsersController alloc] init];
    UINavigationController *navController2 = [[UINavigationController alloc] initWithRootViewController:usersController];
    navController2.tabBarItem.title = @"用户";
    navController2.tabBarItem.image = [UIImage imageNamed:@"tab3.png"];
    
    AboutController *aboutController = [[AboutController alloc] init];
    UINavigationController *navController3 = [[UINavigationController alloc] initWithRootViewController:aboutController];
    navController3.tabBarItem.title = @"关于";
    navController3.tabBarItem.image = [UIImage imageNamed:@"tab4.png"];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.tabBar.backgroundImage = [UIImage imageNamed:@"navbar"];
    self.tabBarController.tabBar.selectedImageTintColor = [UIColor lightGrayColor];
    self.tabBarController.viewControllers = @[navController0, navController1, navController2, navController3];
    self.window.rootViewController = self.tabBarController;
    
    
    NSString *token = [Preferences privateToken];
        
    if (!token && ![token isEmpty])  {
        LoginController *loginController = [[LoginController alloc] init];
        [self.tabBarController presentViewController:loginController animated:NO completion:^{
        }];
    }
        
    
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
