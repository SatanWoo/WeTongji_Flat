//
//  WTInnerNotificationViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-3-2.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTInnerNotificationViewController.h"
#import "WTInnerNotificationTableViewController.h"
#import "Notification+Addition.h"
#import "NSNotificationCenter+WTAddition.h"
#import "UIApplication+WTAddition.h"

@interface WTInnerNotificationViewController () <WTInnerNotificationTableViewControllerDelegate>

@property (nonatomic, strong) NSTimer *loadUnreadNotificationsTimer;

@property (nonatomic, strong) WTInnerNotificationTableViewController *tableViewController;

@property (nonatomic, assign) BOOL isVisible;

@end

@implementation WTInnerNotificationViewController

+ (WTInnerNotificationViewController *)sharedViewController {
    static WTInnerNotificationViewController *viewController = nil;
    static dispatch_once_t WTInnerNotificationTableViewControllerPredicate;
    dispatch_once(&WTInnerNotificationTableViewControllerPredicate, ^{
        viewController = [[WTInnerNotificationViewController alloc] init];
        [viewController setUpLoadUnreadNotificationsTimer];
    });
    
    return viewController;
}

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
    // Do any additional setup after loading the view from its nib.
    [self.view addSubview:self.tableViewController.view];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.tableViewController viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableViewController.view resetHeight:self.view.frame.size.height - 41.0f];
    [NSNotificationCenter postUserDidCheckNotificationsNotification];
    self.isVisible = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.isVisible = NO;
}

#pragma mark - Load data methods

- (void)setUpLoadUnreadNotificationsTimer {
    // 设定 15 秒刷新频率
    self.loadUnreadNotificationsTimer = [NSTimer scheduledTimerWithTimeInterval:15
                                                               target:self
                                                             selector:@selector(loadUnreadNotificationsTimerFired:)
                                                             userInfo:nil
                                                              repeats:YES];
    
    // 立即刷新一次
    [self loadUnreadNotifications];
}

- (void)loadUnreadNotificationsTimerFired:(NSTimer *)timer {
    [self loadUnreadNotifications];
}

- (void)loadUnreadNotifications {
    if (![WTCoreDataManager sharedManager].currentUser)
        return;
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        WTLOG(@"Get notification list succese:%@", responseObject);
        NSSet *notificationsSet = [Notification insertNotifications:responseObject];
        [[WTCoreDataManager sharedManager].currentUser addOwnedNotifications:notificationsSet];
        
        if (notificationsSet.count != 0) {
            if (!self.isVisible)
                [NSNotificationCenter postDidLoadUnreadNotificationsNotification];
        }
    } failureBlock:^(NSError *error) {
        WTLOGERROR(@"Get notification list failure:%@", error.localizedDescription);
    }];
    [request getUnreadNotifications];
    [[WTClient sharedClient] enqueueRequest:request];
}

#pragma mark - Properties

- (WTInnerNotificationTableViewController *)tableViewController {
    if (!_tableViewController) {
        _tableViewController = [[WTInnerNotificationTableViewController alloc] init];
        _tableViewController.delegate = self;
    }
    return _tableViewController;
}

#pragma mark - WTInnerNotificationTableViewControllerDelegate

- (void)innerNotificaionTableViewController:(WTInnerNotificationTableViewController *)vc
                   wantToPushViewController:(UIViewController *)pushVC {
    UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].rootTabBarController.selectedViewController;
    [nav pushViewController:pushVC animated:YES];
}

@end
