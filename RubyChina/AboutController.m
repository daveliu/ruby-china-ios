//
//  AboutController.m
//  RubyChina
//
//  Created by dave on 3/25/13.
//  Copyright (c) 2013 dave. All rights reserved.
//

#import "AboutController.h"
#import "DTCoreText.h"

@interface AboutController ()

@end

@implementation AboutController


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"关于";
    
    DTAttributedLabel *label = [[DTAttributedLabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    
    
    // example for setting a willFlushCallback, that gets called before elements are written to the generated attributed string
	void (^callBackBlock)(DTHTMLElement *element) = ^(DTHTMLElement *element) {
		// if an element is larger than twice the font size put it in it's own block
		if (element.displayStyle == DTHTMLElementDisplayStyleInline && element.textAttachment.displaySize.height > 2.0 * element.fontDescriptor.pointSize)
		{
			element.displayStyle = DTHTMLElementDisplayStyleBlock;
		}
	};
    
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:1.0], NSTextSizeMultiplierDocumentOption, [NSValue valueWithCGSize:CGSizeMake(100, 100)], DTMaxImageSize,
                                    @"Times New Roman", DTDefaultFontFamily,
                                    22.0f, DTDefaultFontSize,
                                    @"purple", DTDefaultLinkColor,
                                    @"red", DTDefaultLinkColor,
                                    callBackBlock, DTWillFlushBlockCallBack,
                                    nil];
	
    NSString *str = @"Thanks http://ruby-china.com <br/> This app is  open source by  MIT license <br/> Welcome fork http://";
    
	NSData *data = [str  dataUsingEncoding:NSUTF8StringEncoding];
    
	NSAttributedString *string = [[NSAttributedString alloc] initWithHTMLData:data options:options documentAttributes:NULL];
    
    [label setAttributedString:string];
    
}

@end
