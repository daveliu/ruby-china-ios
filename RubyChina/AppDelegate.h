//
//  AppDelegate.h
//  RubyChina
//
//  Created by dave on 3/21/13.
//  Copyright (c) 2013 dave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemoteEngine.h"

#define ApplicationDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) RemoteEngine *remoteEngine;
@property (strong, nonatomic) UINavigationController *navController;

@property (strong, nonatomic) UITabBarController *tabBarController;

@end
