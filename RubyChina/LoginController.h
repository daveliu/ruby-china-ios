//
//  LoginController.h
//  RubyChina
//
//  Created by dave on 3/22/13.
//  Copyright (c) 2013 dave. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoginController : UIViewController<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UITextField  *loginField;
@property (nonatomic, strong) UITextField  *passwordField;


- (void)animateView:(NSUInteger)tag;


@end

