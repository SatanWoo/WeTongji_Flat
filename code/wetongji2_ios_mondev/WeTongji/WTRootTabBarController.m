//
//  WTRootTabBarController.m
//  WeTongji
//
//  Created by 王 紫川 on 12-11-13.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "WTRootTabBarController.h"
#import "WTRootNavigationController.h"
#import "WTLoginViewController.h"
#import "WTCoreDataManager.h"

@interface WTRootTabBarController () <WTLoginViewControllerDelegate>

@property (nonatomic, strong) UIImageView *tabBarBgImageView;
@property (nonatomic, strong) NSMutableArray *buttonArray;

@property (nonatomic, weak) UIButton *loginPendingButton;
 
@end

@implementation WTRootTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showCustomTabBar];
    [self adjustBuiltInTabBar];
    
    [self clickTabWithName:WTRootTabBarViewControllerHome];
    self.selectedViewController.view.superview.clipsToBounds = NO;
}

#pragma mark - UI methods

- (void)addCustomTabBarBg {
    UIImage *bgImage = [UIImage imageNamed:@"WTTabBarBg"];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    bgImageView.frame = CGRectMake(0, screenSize.height - bgImage.size.height, screenSize.width, bgImage.size.height);
    
    bgImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    self.tabBarBgImageView = bgImageView;
    self.tabBarBgImageView.userInteractionEnabled = YES;
    
    [self.view addSubview:bgImageView];
}

- (void)addCustomTabBarButtons {
    int viewCount = self.viewControllers.count;
	self.buttonArray = [NSMutableArray arrayWithCapacity:viewCount];
	for (int i = 0; i < viewCount; i++) {
		UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
		btn.tag = i;
		[btn addTarget:self action:@selector(didClickTabBarButton:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(64 * i, 0, 64, self.tabBarBgImageView.frame.size.height + 4);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 64, 24)];
        label.text = @"test";
        label.textAlignment = NSTextAlignmentCenter;
        [btn addSubview:label];
        
        UIImage *normalStateImage = nil;
        UIImage *selectStateImage = nil;
		switch (i) {
            case WTRootTabBarViewControllerHome: {
                normalStateImage = [UIImage imageNamed:@"WTTabBarButtonHome"];
                selectStateImage = [UIImage imageNamed:@"WTTabBarButtonHomeHl"];
                break;
            }
            case WTRootTabBarViewControllerMessage: {
                normalStateImage = [UIImage imageNamed:@"WTTabBarButtonNow"];
                selectStateImage = [UIImage imageNamed:@"WTTabBarButtonNowHl"];
                break;
            }
            case WTRootTabBarViewControllerNow: {
                normalStateImage = [UIImage imageNamed:@"WTTabBarButtonNow"];
                selectStateImage = [UIImage imageNamed:@"WTTabBarButtonNowHl"];
                break;
            }
            case WTRootTabBarViewControllerSearch: {
                normalStateImage = [UIImage imageNamed:@"WTTabBarButtonPowerSearch"];
                selectStateImage = [UIImage imageNamed:@"WTTabBarButtonPowerSearchHl"];
                break;
            }
            case WTRootTabBarViewControllerMe: {
                normalStateImage = [UIImage imageNamed:@"WTTabBarButtonMe"];
                selectStateImage = [UIImage imageNamed:@"WTTabBarButtonMeHl"];
                break;
            }
        }
        [btn setImage:normalStateImage forState:UIControlStateNormal];
        [btn setImage:selectStateImage forState:UIControlStateSelected];
        
		[self.buttonArray addObject:btn];
		[self.tabBarBgImageView addSubview:btn];
	}
}

- (void)setBuildInTabBarHeight:(CGFloat)height {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    for(UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UITabBar class]]) {
            [view resetOriginY:screenSize.height - height];
            [view resetHeight:height];
        } else if (view != self.tabBarBgImageView) {
            [view resetHeight:screenSize.height - height];
        }
    }
}

- (void)adjustBuiltInTabBar {
    self.tabBar.hidden = YES;
    [self setBuildInTabBarHeight:self.tabBarBgImageView.frame.size.height - 1];
}

- (void)showCustomTabBar {
    [self addCustomTabBarBg];
    [self addCustomTabBarButtons];
    ((UIButton *)self.buttonArray[0]).selected = YES;
}

#pragma mark - Public methods

- (void)clickTabWithName:(WTRootTabBarViewControllerName)name {
    [self didClickTabBarButton:self.buttonArray[name]];
}

- (void)hideTabBar {
    [self setBuildInTabBarHeight:0];
    self.tabBarBgImageView.hidden = YES;
}

- (void)showTabBar {
    [self adjustBuiltInTabBar];
    self.tabBarBgImageView.hidden = NO;
}

#pragma mark - Actions 

- (void)didClickTabBarButton:(UIButton *)button {
    if (self.selectedIndex == button.tag) {
        if ([self.selectedViewController isKindOfClass:[UINavigationController class]])
            [(UINavigationController *)self.selectedViewController popToRootViewControllerAnimated:YES];
        return;
    }
    
    WTRootNavigationController *viewController = self.viewControllers[button.tag];
    if ([viewController needUserLogin] && ![WTCoreDataManager sharedManager].currentUser) {
        WTLoginViewController *loginViewController = [WTLoginViewController showWithIntro:NO];
        loginViewController.delegate = self;
        self.loginPendingButton = button;
        return;
    }
    
    self.selectedIndex = button.tag;
    
    // |button.tag == 4| 时似乎系统有bug，用下面的方法折衷
    if (button.tag == 4) {
        UIViewController *lastViewController = [self.viewControllers lastObject];
        self.selectedViewController = lastViewController;
    }
    
    [self setTabBarButtonSelected:button.tag];
}

- (void)setTabBarButtonSelected:(WTRootTabBarViewControllerName)controllerName {
    for (UIButton* btn in self.buttonArray) {
        btn.selected = NO;
    }
    UIButton *button = self.buttonArray[controllerName];
    button.selected = YES;
}

#pragma mark - WTLoginViewControllerDelegate

- (void)loginViewControllerDidDismiss {
    if ([WTCoreDataManager sharedManager].currentUser) {
        [self didClickTabBarButton:self.loginPendingButton];
    }
    self.loginPendingButton = nil;
}

@end
