//
//  WTDetailViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-4-18.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTDetailViewController.h"
#import "WTLikeButtonView.h"
#import "WTResourceFactory.h"
#import "UIApplication+WTAddition.h"
#import "RDActivityViewController.h"
 
@interface WTDetailViewController () <RDActivityViewControllerDelegate>

@property (nonatomic, weak) WTLikeButtonView *likeButtonContainerView;

@end

@implementation WTDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self configureNavigationBar];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WTRootBgUnit"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.likeButtonContainerView configureViewWithObject:[self targetObject]];
}

#pragma mark - UI methods

#pragma mark Configure navigation bar

- (void)configureNavigationBarBackButton {
    UIBarButtonItem *backBarButtonItem = nil;
    if (self.backBarButtonText)
        backBarButtonItem = [WTResourceFactory createBackBarButtonWithText:self.backBarButtonText target:self action:@selector(didClickBackButton:)];
    else
        backBarButtonItem = [WTResourceFactory createLogoBackBarButtonWithTarget:self action:@selector(didClickBackButton:)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
}

- (void)configureNavigationBarRightButtons {
//    UIButton *commentButton = [[UIButton alloc] init];
//    commentButton.showsTouchWhenHighlighted = YES;
//    commentButton.adjustsImageWhenHighlighted = NO;
//    UIImage *commentImage = [UIImage imageNamed:@"WTCommentButton"];
//    [commentButton setBackgroundImage:commentImage forState:UIControlStateNormal];
//    [commentButton resetSize:commentImage.size];
//    [commentButton addTarget:self action:@selector(didClickCommentButton:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *barCommentButton = [[UIBarButtonItem alloc] initWithCustomView:commentButton];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 110.0f, 44.0f)];
    [toolbar setBackgroundImage:[UIImage imageNamed:@"WTTransparentImage"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:5];
    
//    [buttons addObject:barCommentButton];
//    [buttons addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
    
    if ([self showMoreNavigationBarButton]) {
        
        UIButton *moreButton = [[UIButton alloc] init];
        moreButton.showsTouchWhenHighlighted = YES;
        moreButton.adjustsImageWhenHighlighted = NO;
        UIImage *moreImage = [UIImage imageNamed:@"WTMoreButton"];
        [moreButton resetSize:moreImage.size];
        [moreButton setBackgroundImage:moreImage forState:UIControlStateNormal];
        [moreButton addTarget:self action:@selector(didClickMoreButton:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *barMoreButton = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
        
        [buttons addObject:barMoreButton];
        [buttons addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
    } else {
        [toolbar resetWidth:56.0f];
    }
    
    if ([self showLikeNavigationBarButton]) {
        
        WTLikeButtonView *likeButtonContainerView = [WTLikeButtonView createLikeButtonViewWithObject:[self targetObject]];
        self.likeButtonContainerView = likeButtonContainerView;
        UIBarButtonItem *barLikeButton = [[UIBarButtonItem alloc] initWithCustomView:likeButtonContainerView];
        
        [buttons addObject:barLikeButton];
    }
    
    [toolbar setItems:buttons animated:NO];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:toolbar];
}

- (void)configureNavigationBar {
    [self configureNavigationBarBackButton];
    [self configureNavigationBarRightButtons];
}

#pragma mark - Actions

- (void)didClickBackButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Methods to overwrite

- (void)didClickCommentButton:(UIButton *)sender {
    
}

- (void)didClickMoreButton:(UIButton *)sender {
    RDActivityViewController *vc = [[RDActivityViewController alloc] initWithDelegate:self];
    vc.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll];
    [[UIApplication sharedApplication].rootTabBarController presentViewController:vc animated:YES completion:nil];
}

- (LikeableObject *)targetObject {
    return nil;
}

- (BOOL)showMoreNavigationBarButton {
    if ([UIDevice currentDevice].systemVersion.floatValue >= 6.0)
        return YES;
    else
        return NO;
}

- (BOOL)showLikeNavigationBarButton {
    return YES;
}

- (NSArray *)imageArrayToShare {
    return nil;
}

- (NSString *)textToShare {
    return nil;
}

#pragma mark - RDActivityViewControllerDelegate

- (NSArray *)activityViewController:(NSArray *)activityViewController itemsForActivityType:(NSString *)activityType {
    NSString *textToShare = [self textToShare];
    NSArray *imagesToShare = [self imageArrayToShare];
    NSMutableArray *result = [NSMutableArray array];
    if ([activityType isEqualToString:UIActivityTypePostToWeibo]) {
        [result addObject:[WTDetailViewController cutTextForWeibo:textToShare]];
        if (imagesToShare.count > 0)
            [result addObject:imagesToShare[0]];
    } else {
        [result addObject:textToShare];
        [imagesToShare enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [result addObject:obj];
        }];
    }
    return result;
}

#pragma mark - Weibo

#define WEIBO_TEXT_MAX_LENGTH   140

+ (NSString *)cutTextForWeibo:(NSString *)text {
    int i, n = [text length], l = 0, a = 0, b = 0;
    unichar c;
    for(i = 0; i < n; i++) {
        c = [text characterAtIndex:i];
        if (isblank(c))
            b++;
        else if (isascii(c))
            a++;
        else
            l++;
        
        int textLength = ceilf((float)(l * 2 + a + b) / 2.0f);
        if (textLength > WEIBO_TEXT_MAX_LENGTH)
            break;
    }
    
    if (i == n) {
        return text;
    } else {
        return [NSString stringWithFormat:@"%@...", [text substringToIndex:i - 3]];
    }
}

@end
