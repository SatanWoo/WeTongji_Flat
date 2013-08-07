//
//  WTNavigationController.m
//  WeTongji
//
//  Created by 王 紫川 on 12-12-18.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "WTRootNavigationController.h"
#import "WTRootTabBarController.h"
#import "UIApplication+WTAddition.h"
#import "UIImage+ScreenShoot.h"
#import "WTNotificationBarButton.h"
#import "WTInnerModalViewController.h"

#import "WTHomeViewController.h"

@interface WTRootNavigationController () <UINavigationControllerDelegate>

@property (nonatomic, strong) WTInnerModalViewController *innerModalViewController;
@property (nonatomic, strong) UIViewController<WTRootNavigationControllerDelegate> *sourceViewController;
@property (nonatomic, assign) CGPoint sourceScrollViewContentOffset;
@property (nonatomic, strong) NSMutableDictionary *sourceScollViewSubviewOriginYDict;

@property (nonatomic, strong) UIImageView *screenShootImageView;
@property (nonatomic, strong) UIView *screenShootContainerView;

@property (nonatomic, assign) WTDisableNavBarType currentWTDisableNavBarType;
@end

@implementation WTRootNavigationController

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
}

- (BOOL)needUserLogin {
    return NO;
}

#pragma mark - Logic methods

- (void)configureInnerModalCallBarButtonItem {
    switch (self.currentWTDisableNavBarType) {
        case WTDisableNavBarTypeLeft:
        {
            self.innerModalViewController.callBarButtonItem = self.sourceViewController.navigationItem.rightBarButtonItem;
        }
            break;
            
        case WTDisableNavBarTypeRight:
        {
            self.innerModalViewController.callBarButtonItem = self.sourceViewController.navigationItem.leftBarButtonItem;
        }
            break;
            
        default:
            break;
    }
}

- (void)disableNavBar {
    
    self.sourceViewController.navigationItem.titleView.userInteractionEnabled = NO;
    self.sourceViewController.navigationItem.titleView.alpha = 0.5f;
    
    switch (self.currentWTDisableNavBarType) {
        case WTDisableNavBarTypeLeft:
        {
            self.sourceViewController.navigationItem.leftBarButtonItem.enabled = NO;
            self.sourceViewController.navigationItem.leftBarButtonItem.customView.alpha = 0.5f;
        }
            break;
            
        case WTDisableNavBarTypeRight:
        {
            self.sourceViewController.navigationItem.rightBarButtonItem.enabled = NO;
            self.sourceViewController.navigationItem.rightBarButtonItem.customView.alpha = 0.5f;
        }
            break;
            
        default:
            break;
    }
}

- (void)enableNavBar {
    
    self.sourceViewController.navigationItem.titleView.userInteractionEnabled = YES;
    self.sourceViewController.navigationItem.titleView.alpha = 1.0f;
    
    switch (self.currentWTDisableNavBarType) {
        case WTDisableNavBarTypeLeft:
        {
            self.sourceViewController.navigationItem.leftBarButtonItem.enabled = YES;
            self.sourceViewController.navigationItem.leftBarButtonItem.customView.alpha = 1.0f;
        }
            break;
            
        case WTDisableNavBarTypeRight:
        {
            self.sourceViewController.navigationItem.rightBarButtonItem.enabled = YES;
            self.sourceViewController.navigationItem.rightBarButtonItem.customView.alpha = 1.0f;
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Public methods

- (void)showInnerModalViewController:(WTInnerModalViewController *)innerController
                sourceViewController:(UIViewController<WTRootNavigationControllerDelegate> *)sourceController
                   disableNavBarType:(WTDisableNavBarType)type {
    
    [self.screenShootContainerView resetOriginY:innerController.view.frame.size.height - 41.0f];
    [innerController.view addSubview:self.screenShootContainerView];
    
    UIScrollView *sourceScrollView = [sourceController sourceScrollView];
    self.sourceScrollViewContentOffset = sourceScrollView.contentOffset;
    
    NSMutableDictionary *sourceScollViewSubviewOriginYDict = [NSMutableDictionary dictionary];
    for (UIView *subview in sourceScrollView.subviews) {
        sourceScollViewSubviewOriginYDict[[NSString stringWithFormat:@"%p", subview]] = @(subview.frame.origin.y);
    }
    self.sourceScollViewSubviewOriginYDict = sourceScollViewSubviewOriginYDict;
    
    
    WTRootTabBarController *tabBarVC = [UIApplication sharedApplication].rootTabBarController;
    [tabBarVC hideTabBar];
    
    [innerController.view resetOriginY:-innerController.view.frame.size.height + 41.0f];
    [self.topViewController.view addSubview:innerController.view];
    
    self.innerModalViewController = innerController;
    self.sourceViewController = sourceController;
    
    self.currentWTDisableNavBarType = type;
    [self disableNavBar];
    [self configureInnerModalCallBarButtonItem];
    
    self.view.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.3f animations:^{
        [innerController.view resetOriginY:0];
    } completion:^(BOOL finished) {
        self.view.userInteractionEnabled = YES;
    }];
}

- (void)hideInnerModalViewController {
    self.view.userInteractionEnabled = NO;
    if ([self.sourceViewController respondsToSelector:@selector(willHideInnderModalViewController)])
        [self.sourceViewController willHideInnderModalViewController];
    if ([self.innerModalViewController respondsToSelector:@selector(willHideInnderModalViewController)])
        [self.innerModalViewController willHideInnderModalViewController];
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.innerModalViewController.view resetOriginY:-self.innerModalViewController.view.frame.size.height + 41.0f];
    } completion:^(BOOL finished) {
        self.view.userInteractionEnabled = YES;
        
        [self enableNavBar];
        self.currentWTDisableNavBarType = WTDisableNavBarTypeNone;
        
        if ([self.sourceViewController respondsToSelector:@selector(didHideInnderModalViewController)])
            [self.sourceViewController didHideInnderModalViewController];
        
        UIScrollView *sourceScrollView = [self.sourceViewController sourceScrollView];
        self.sourceViewController = nil;
        
        if ([self.innerModalViewController respondsToSelector:@selector(didHideInnderModalViewController)])
            [self.innerModalViewController didHideInnderModalViewController];
        [self.innerModalViewController.view removeFromSuperview];
        self.innerModalViewController = nil;
        
        // release screen shoot views
        [self.screenShootContainerView removeFromSuperview];
        self.screenShootImageView = nil;
        self.screenShootContainerView = nil;
        
        WTRootTabBarController *tabBarVC = [UIApplication sharedApplication].rootTabBarController;
        [tabBarVC showTabBar];
        
        sourceScrollView.contentOffset = self.sourceScrollViewContentOffset;
        for (UIView *subview in sourceScrollView.subviews) {
            NSNumber *originYNumber = self.sourceScollViewSubviewOriginYDict[[NSString stringWithFormat:@"%p", subview]];
            if (originYNumber)
                [subview resetOriginY:originYNumber.floatValue];
        }
    }];
}

#pragma mark - Properties

- (UIView *)screenShootContainerView {
    if (!_screenShootContainerView) {
        _screenShootContainerView = [[UIView alloc] init];
        
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        [_screenShootContainerView resetSize:CGSizeMake(screenSize.width, screenSize.height - 44 - 20)];
        [self.screenShootImageView resetOriginY:0 - 44 - 20];
        
        [_screenShootContainerView addSubview:self.screenShootImageView];
        
        _screenShootContainerView.clipsToBounds = YES;
    }
    return _screenShootContainerView;
}

- (UIImageView *)screenShootImageView {
    if (!_screenShootImageView) {
        self.navigationBarShadowImageView.hidden = YES;
        _screenShootImageView = [[UIImageView alloc] initWithImage:[UIImage screenShoot]];
        self.navigationBarShadowImageView.hidden = NO;
        [_screenShootImageView resetSize:[UIScreen mainScreen].bounds.size];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapScreenShootImageView:)];
        [_screenShootImageView addGestureRecognizer:tap];
        
        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeUpScreenShootImageView:)];
        swipe.direction = UISwipeGestureRecognizerDirectionUp;
        [_screenShootImageView addGestureRecognizer:swipe];
        
        _screenShootImageView.userInteractionEnabled = YES;
    }
    return _screenShootImageView;
}

#pragma mark - Handle gesture recognizer

- (void)didTapScreenShootImageView:(UIGestureRecognizer *)gestureRecognizer {
    [self hideInnerModalViewController];
}

- (void)didSwipeUpScreenShootImageView:(UIGestureRecognizer *)gestureRecognizer {
    [self hideInnerModalViewController];
}

#pragma mark - Overwrite methods

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    if (self.sourceViewController && self.viewControllers.count > 1) {
        UIViewController *topViewController = self.viewControllers[self.viewControllers.count - 2];
        if (self.sourceViewController == topViewController) {
            [self.innerModalViewController viewDidAppear:YES];
        }
    }
    return [super popViewControllerAnimated:animated];
}

@end
