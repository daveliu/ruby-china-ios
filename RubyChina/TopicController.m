//
//  TopicController.m
//  RubyChina
//
//  Created by dave on 3/23/13.
//  Copyright (c) 2013 dave. All rights reserved.
//

#import "TopicController.h"
#import "AppDelegate.h"
#import "Reply.h"
#import "DTCoreText.h"
#import "ReplyCell.h"
#import "TopicCell.h"
#import "NSDate+TimeAgo.h"
#import "Preferences.h"


@interface TopicController ()

@end

@implementation TopicController

@synthesize topic;
@synthesize replies = _replies;


-(id)init
{
	self = [super init];
	if(self){
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardWillShow:)
													 name:UIKeyboardWillShowNotification
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardWillHide:)
													 name:UIKeyboardWillHideNotification
												   object:nil];
	}
	
	return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"社区";
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    if (!self.replies) {
        [self getRemoteData];
    }
    
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.tableView.separatorColor = [UIColor colorWithRed:211.0/255 green:211.0/255 blue:211.0/255 alpha:0.2];
    
    UIButton *backButton = [[UIButton alloc] init];
    
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back:)
         forControlEvents:UIControlEventTouchUpInside];
    [backButton setFrame:CGRectMake(0, 0, 49, 30)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton] ;
    
    
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignTextView:)];
//    [tap setDelegate:self];
//    [self.view addGestureRecognizer:tap];
    
    UIPanGestureRecognizer * swip = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(resignTextViewSwip:)];
//     [swip setDirection:UISwipeGestureRecognizerDirectionDown];
    [swip setDelegate:self];
  //  [swip setNumberOfTouchesRequired:1];
    swip.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:swip];


}


-(void)addTextView{
    //----------add the input box for reply
    
        containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.tableView.frame.size.height - 40, 320, 40)];
    
        textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(6, 3, 240, 40)];
        textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
    	textView.minNumberOfLines = 1;
    	textView.maxNumberOfLines = 6;
        textView.animateHeightChange = NO;
    	textView.returnKeyType = UIReturnKeyGo; //just as an example
    	textView.font = [UIFont systemFontOfSize:15.0f];
    	textView.delegate = self;
        textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
        textView.backgroundColor = [UIColor whiteColor];
    
        [self.view addSubview:containerView];
    
        UIImage *rawEntryBackground = [UIImage imageNamed:@"MessageEntryInputField.png"];
        UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
        UIImageView *entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
        entryImageView.frame = CGRectMake(5, 0, 248, 40);
        entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
        UIImage *rawBackground = [UIImage imageNamed:@"MessageEntryBackground.png"];
        UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
        imageView.frame = CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height);
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
        textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    //
    //    // view hierachy
        [containerView addSubview:imageView];
        [containerView addSubview:textView];
        [containerView addSubview:entryImageView];
    //
        UIImage *sendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
        UIImage *selectedSendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    //
    	UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    	doneBtn.frame = CGRectMake(containerView.frame.size.width - 69, 8, 63, 27);
        doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    	[doneBtn setTitle:@"回复" forState:UIControlStateNormal];
    
        [doneBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
        doneBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
        doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
        [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    	[doneBtn addTarget:self action:@selector(submitReply) forControlEvents:UIControlEventTouchUpInside];
        [doneBtn setBackgroundImage:sendBtnBackground forState:UIControlStateNormal];
        [doneBtn setBackgroundImage:selectedSendBtnBackground forState:UIControlStateSelected];
    	[containerView addSubview:doneBtn];
        containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (![textView isFirstResponder]) {
        CGRect newFrame = containerView.frame;
        newFrame.origin.x = 0;
        newFrame.origin.y = self.tableView.contentOffset.y+(self.tableView.frame.size.height-newFrame.size.height);
        containerView.frame = newFrame;
    }

}

- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) setReplies:(NSMutableArray *)data {
    if (![_replies isEqualToArray:data]){
        _replies = [data mutableCopy];
        [self.tableView reloadData];
    }
}

- (void)submitReply{
    MKNetworkOperation *currentOp =  [ApplicationDelegate.remoteEngine  createReply:self.topic.ID body:textView.text];
    
    [currentOp onCompletion:^(MKNetworkOperation* completedRequest) {
        DLog(@"-------------------------%@", completedRequest);

        Reply *reply = [Reply initWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
                         textView.text, @"bodyHtml",
                        nil]];
        reply.creatorLogin = [Preferences login] ;
        reply.creatorAvatar = [Preferences avatarUrl] ;
        
        NSMutableArray *dataCopy = [self.replies mutableCopy];
        [dataCopy addObject:reply];
        self.replies = [NSArray arrayWithArray:dataCopy];
        
        [textView resignFirstResponder];        
        
    } onError:^(NSError* error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力啊"];
    }];
}



- (void)getRemoteData {
    
    MKNetworkOperation *currentOp =  [ApplicationDelegate.remoteEngine topic:self.topic.ID];
    
    [currentOp onCompletion:^(MKNetworkOperation* completedRequest) {
        DLog(@"-------------------------%@", completedRequest);
        NSDictionary *response = [completedRequest responseJSON];
        
        self.topic.bodyHtml = [response objectForKey:@"body_html"];
        
        NSArray *repliesAry = [response objectForKey:@"replies"];
        NSMutableArray *ary =  [[NSMutableArray alloc] init] ;
        
        [repliesAry  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Reply *reply = [Reply initWithDictionary:obj];
            [ary addObject:reply];
        }];
        
        self.replies = ary;
        
    } onError:^(NSError* error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力啊"];
    }];
    
    // add the reply input view
    [self addTextView];    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numRows = 0;
    
    if (section == 0) {
        numRows = 1;
    } else{
        numRows = [self.replies count];
    }
    
    return numRows;
    
}


// identifier for cell reuse
NSString * const AttributedTextCellReuseIdentifier = @"AttributedTextCellReuseIdentifier";
NSString * const AttributedTextTopicCellReuseIdentifier = @"AttributedTextTopicCellReuseIdentifier";

#define CELL_WIDTH 320.0f
#define CELL_PADDING 10.0f
#define HEADSHOT_WIDTH 30.0f
#define TEXT_STATUS_PADDING 10.0f
#define TIME_LABEL_HEIGHT 16.0f
#define FONT_SIZE 18.0f
#define TIME_FONT_SIZE 14.0f
#define AUTHOR_VIEW_TAG 1
#define STATUS_VIEW_TAG 2
#define TEXT_VIEW_TAG 3
#define REPLY_VIEW_TAG 4
#define TIME_VIEW_TAG 5
#define TIMEICON_VIEW_TAG 6
#define REPLYICON_VIEW_TAG 7

- (void)configureCell:(ReplyCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    Reply *reply = [self.replies objectAtIndex:indexPath.row];		
	
//	[cell setHTMLString:reply.bodyHtml];
	
	cell.attributedTextContextView.shouldDrawImages = YES;
    
    cell.attributedTextContextView.backgroundColor = [UIColor clearColor];
    
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
                                    20.0f, DTDefaultFontSize,
                                    @"purple", DTDefaultLinkColor,
                                    @"red", DTDefaultLinkColor,
                                    callBackBlock, DTWillFlushBlockCallBack,
                                    nil];
	
	NSData *data = [reply.bodyHtml  dataUsingEncoding:NSUTF8StringEncoding];
    
	NSAttributedString *string = [[NSAttributedString alloc] initWithHTMLData:data options:options documentAttributes:NULL];
    
    [cell setAttributedString:string];

}


- (void)configureTopicCell:(TopicCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
		
	cell.attributedTextContextView.shouldDrawImages = YES;
    
    cell.attributedTextContextView.backgroundColor = [UIColor clearColor];
    
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
	
	NSData *data = [self.topic.bodyHtml  dataUsingEncoding:NSUTF8StringEncoding];
    
	NSAttributedString *string = [[NSAttributedString alloc] initWithHTMLData:data options:options documentAttributes:NULL];
    
    [cell setAttributedString:string];
    [cell setTopic:self.topic];
    
}



- (ReplyCell *)tableView:(UITableView *)tableView preparedCellForIndexPath:(NSIndexPath *)indexPath
{	
	ReplyCell *cell =  nil;
    // reuse does not work for variable height
    cell = (ReplyCell *)[tableView dequeueReusableCellWithIdentifier:AttributedTextCellReuseIdentifier];
    
    // legacy, as of iOS 6 this always returns a cell
    if (!cell)
    {
        cell = [[ReplyCell alloc] initWithReuseIdentifier:AttributedTextCellReuseIdentifier];
    }    
    
	[self configureCell:cell forIndexPath:indexPath];
	
	return cell;
}

- (TopicCell *)tableView:(UITableView *)tableView preparedTopicCellForIndexPath:(NSIndexPath *)indexPath
{
	TopicCell *cell =  nil;
    // reuse does not work for variable height
    cell = (TopicCell *)[tableView dequeueReusableCellWithIdentifier:AttributedTextTopicCellReuseIdentifier];
    
    // legacy, as of iOS 6 this always returns a cell
    if (!cell)
    {
        cell = [[TopicCell alloc] initWithReuseIdentifier:AttributedTextTopicCellReuseIdentifier];
    }
    
	[self configureTopicCell:cell forIndexPath:indexPath];
	
	return cell;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        cell = (TopicCell *)[self tableView:tableView preparedTopicCellForIndexPath:indexPath];
        
        
    }else{
        cell = (ReplyCell *)[self tableView:tableView preparedCellForIndexPath:indexPath];
        
        Reply *reply = [self.replies objectAtIndex:indexPath.row];
        
        //setup author view
        UIImageView *authorView = (UIImageView *)[cell.contentView viewWithTag:AUTHOR_VIEW_TAG];
        if (!authorView) {
            authorView = [[UIImageView alloc] initWithFrame:CGRectMake(CELL_PADDING, CELL_PADDING, HEADSHOT_WIDTH, HEADSHOT_WIDTH)];
            authorView.tag = AUTHOR_VIEW_TAG;
            authorView.layer.cornerRadius = 15.0f;
            authorView.layer.masksToBounds = YES;
            
            [cell.contentView addSubview:authorView];
        }
        authorView.frame = CGRectMake(CELL_PADDING, CELL_PADDING , HEADSHOT_WIDTH, HEADSHOT_WIDTH);
        [authorView setImageWithURL:[NSURL URLWithString:reply.creatorAvatar ]
                   placeholderImage:[UIImage imageNamed:@"avatar.png"]];
        
        //setup time view
        UILabel *timeLabel = (UILabel *)[cell.contentView viewWithTag:TIME_VIEW_TAG];
        if (!timeLabel) {
            timeLabel = [[UILabel alloc] init];
            timeLabel.tag = TIME_VIEW_TAG;            
            timeLabel.font = [UIFont systemFontOfSize:TIME_FONT_SIZE];
            timeLabel.textColor = [UIColor grayColor];
            timeLabel.backgroundColor = [UIColor clearColor];
            timeLabel.frame = CGRectMake(50, CELL_PADDING + 5, 200, TIME_LABEL_HEIGHT);            
            [cell.contentView addSubview:timeLabel];
        }
        timeLabel.text =  [NSString stringWithFormat:@"%@ • %@", reply.creatorLogin, [reply.createdAt timeAgo]] ;        

    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 60.0f;

    if (indexPath.section == 0) {
        TopicCell *cell = (TopicCell *)[self tableView:tableView preparedTopicCellForIndexPath:indexPath];
        
        CGSize neededSize = [cell.attributedTextContextView suggestedFrameSizeToFitEntireStringConstraintedToWidth: 320-20];
        
        CGFloat backgroundViewWidth = CELL_WIDTH - 2 * CELL_PADDING;
        
        CGSize constraint = CGSizeMake(backgroundViewWidth - 2 * TEXT_STATUS_PADDING, 20000.0f);
        CGSize size = [self.topic.title sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        
        return MAX( size.height + 40 + neededSize.height + 10, 90.0f);
    } else {
        ReplyCell *cell = (ReplyCell *)[self tableView:tableView preparedCellForIndexPath:indexPath];
        
        CGSize neededSize = [cell.attributedTextContextView suggestedFrameSizeToFitEntireStringConstraintedToWidth: 320-40];
        
        if (indexPath.row == [self.replies count] -1) {
           return neededSize.height + 30 + containerView.frame.size.height;
        }else{
           return MAX( neededSize.height + 30, 60.0f);
        }

    }

    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

#pragma mark -  growingTextView
-(void)resignTextView:(UITapGestureRecognizer *)recognizer
{
	[textView resignFirstResponder];
}

-(void)resignTextViewSwip:(UIGestureRecognizer *)recognizer
{
//    UISwipeGestureRecognizerDirectionDown
    NSLog(@"xxxfdsfsdfsdfsdfsdfsdfsdfsd");
	[textView resignFirstResponder];
}



//Code from Brett Schumann
-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
	// get a rect for the textView frame
	CGRect containerFrame = containerView.frame;
//    containerFrame.origin.y = self.tableView.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);

    containerFrame.origin.y = self.tableView.contentOffset.y+(self.tableView.frame.size.height-containerFrame.size.height) - keyboardBounds.size.height;
    
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	
	// set views with new info
	containerView.frame = containerFrame;
	
	// commit animations
	[UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	
	
    // get a rect for the textView frame
	CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.tableView.contentOffset.y+(self.tableView.frame.size.height-containerFrame.size.height);
	
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
	// set views with new info
	containerView.frame = containerFrame;
	
	// commit animations
	[UIView commitAnimations];
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
	CGRect r = containerView.frame;
    r.size.height -= diff;
//    r.origin.y += diff;
    r.origin.y += diff + 40;
	containerView.frame = r;
}

//-(void)growingTextView:(HPGrowingTextView *)growingTextView didChangeHeight:(float)height{
//    textView.animateHeightChange = false;
//}


@end
