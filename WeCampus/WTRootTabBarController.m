//
//  WTRootTabBarController.m
//  WeTongji
//
//  Created by 王 紫川 on 12-11-13.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "WTRootTabBarController.h"

@interface WTRootTabBarController ()

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
    UIImage *bgImage = [UIImage imageNamed:@"tab_bg"];
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
    
    static NSArray *buttonNames;
    if(!buttonNames)
    {
        buttonNames = @[
                        NSLocalizedString(@"主页", nil),
                        NSLocalizedString(@"消息", nil),
                        NSLocalizedString(@"日程", nil),
                        NSLocalizedString(@"搜索", nil),
                        NSLocalizedString(@"我", nil)
                        ];
    }
    
	for (int i = 0; i < viewCount; i++) {
		UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
		btn.tag = i;
		[btn addTarget:self action:@selector(didClickTabBarButton:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(64 * i, 0, 64, self.tabBarBgImageView.frame.size.height - 10);
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 64, 30)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:146 / 255.0 green:146 / 255.0  blue:146 / 255.0  alpha:1];
        label.text = buttonNames[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        label.highlightedTextColor = [UIColor colorWithRed:19 / 255.0 green:199 / 255.0 blue:175/255.0 alpha:1];
        label.tag = 100;
        [btn addSubview:label];
        
        UIImage *normalStateImage = nil;
        UIImage *selectStateImage = nil;
		switch (i) {
            case WTRootTabBarViewControllerHome: {
                normalStateImage = [UIImage imageNamed:@"home_un"];
                selectStateImage = [UIImage imageNamed:@"home_sl"];
                break;
            }
            case WTRootTabBarViewControllerMessage: {
                normalStateImage = [UIImage imageNamed:@"message_un"];
                selectStateImage = [UIImage imageNamed:@"message_sl"];
                break;
            }
            case WTRootTabBarViewControllerNow: {
                normalStateImage = [UIImage imageNamed:@"calendar_un"];
                selectStateImage = [UIImage imageNamed:@"calendar_sl"];
                break;
            }
            case WTRootTabBarViewControllerSearch: {
                normalStateImage = [UIImage imageNamed:@"search_un"];
                selectStateImage = [UIImage imageNamed:@"search_sl"];
                break;
            }
            case WTRootTabBarViewControllerMe: {
                normalStateImage = [UIImage imageNamed:@"person_un"];
                selectStateImage = [UIImage imageNamed:@"person_sl"];
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
    self.tabBar.hidden = YES;
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
    

    self.selectedIndex = button.tag;
    
       
    [self setTabBarButtonSelected:button.tag];
}

- (void)setTabBarButtonSelected:(WTRootTabBarViewControllerName)controllerName {
    for (UIButton* btn in self.buttonArray) {
        UILabel *label = (UILabel *)[btn viewWithTag:100];
        [label setHighlighted:NO];
        btn.selected = NO;
    }
    UIButton *button = self.buttonArray[controllerName];
    UILabel *label = (UILabel *)[button viewWithTag:100];
    [label setHighlighted:YES];
    button.selected = YES;
}

#pragma mark - WTLoginViewControllerDelegate

- (void)loginViewControllerDidDismiss {
    
}

@end
