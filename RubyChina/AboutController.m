//
//  AboutController.m
//  RubyChina
//
//  Created by dave on 3/25/13.
//  Copyright (c) 2013 dave. All rights reserved.
//

#import "AboutController.h"
#import <DTCoreText.h>

@interface AboutController ()

@end

@implementation AboutController


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"关于";
    
    DTAttributedTextView *label = [[DTAttributedTextView alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textDelegate = self;    
    
    
    // example for setting a willFlushCallback, that gets called before elements are written to the generated attributed string
	void (^callBackBlock)(DTHTMLElement *element) = ^(DTHTMLElement *element) {
		// if an element is larger than twice the font size put it in it's own block
		if (element.displayStyle == DTHTMLElementDisplayStyleInline && element.textAttachment.displaySize.height > 2.0 * element.fontDescriptor.pointSize)
		{
			element.displayStyle = DTHTMLElementDisplayStyleBlock;
		}
	};
    
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:1.0], NSTextSizeMultiplierDocumentOption, [NSValue valueWithCGSize:CGSizeMake(100, 100)], DTMaxImageSize,
                                    20.0f, DTDefaultFontSize,
                                    @"purple", DTDefaultLinkColor,
                                    @"red", DTDefaultLinkColor,
                                    [NSNumber numberWithBool:NO] , DTUseiOS6Attributes,
                                    nil];
	
    NSString *str = @"<p>Thanks <a href='http://ruby-china.org'>http://ruby-china.org</a> .</p>  <p>This app is  open source by  MIT license .</p > <p>Welcome fork <a href='https://github.com/daveliu/ruby-china-ios'>https://github.com/daveliu/ruby-china-ios</a> .</p>";
    
	NSData *data = [str  dataUsingEncoding:NSUTF8StringEncoding];
    
	NSAttributedString *string = [[NSAttributedString alloc] initWithHTMLData:data options:options documentAttributes:NULL];
    
    label.shouldDrawLinks = NO;
    //label.
    
    [label setAttributedString:string];
    
    [label setFrame:CGRectMake(5, 5, 300, 200)];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    [self.view addSubview:label];
    
}

#pragma mark Actions

- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttributedString:(NSAttributedString *)string frame:(CGRect)frame
{
	NSDictionary *attributes = [string attributesAtIndex:0 effectiveRange:NULL];
    
	NSURL *URL = [attributes objectForKey:DTLinkAttribute];
	NSString *identifier = [attributes objectForKey:DTGUIDAttribute];
    
    
	DTLinkButton *button = [[DTLinkButton alloc] initWithFrame:frame];
	button.URL = URL;
	button.GUID = identifier;
    
	// get image with normal link text
	UIImage *normalImage = [attributedTextContentView contentImageWithBounds:frame options:DTCoreTextLayoutFrameDrawingDefault];
	[button setImage:normalImage forState:UIControlStateNormal];
    
	// get image for highlighted link text
	UIImage *highlightImage = [attributedTextContentView contentImageWithBounds:frame options:DTCoreTextLayoutFrameDrawingDrawLinksHighlighted];
	[button setImage:highlightImage forState:UIControlStateHighlighted];
    
	// use normal push action for opening URL
	[button addTarget:self action:@selector(linkPushed:) forControlEvents:UIControlEventTouchUpInside];
    
    
	return button;
}


- (void)linkPushed:(DTLinkButton *)button
{
	NSURL *URL = button.URL;
    
	if ([[UIApplication sharedApplication] canOpenURL:[URL absoluteURL]])
	{
		[[UIApplication sharedApplication] openURL:[URL absoluteURL]];
	}
}


@end
