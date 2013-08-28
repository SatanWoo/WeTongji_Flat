//
//  WENotificationRootViewController.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-24.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WENotificationRootViewController.h"
#import "WESettingViewController.h"
#import "WTInnerNotificationTableViewController.h"

#import "WTRequest.h"
#import "WTClient.h"
#import "Notification+Addition.h"

@interface WENotificationRootViewController () <WTInnerNotificationTableViewControllerDelegate>

@property (nonatomic, strong) WTInnerNotificationTableViewController *tableViewController;
@property (nonatomic, strong) NSTimer *loadUnreadNotificationsTimer;
@property (nonatomic, assign) BOOL isVisible;
@end

@implementation WENotificationRootViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpLoadUnreadNotificationsTimer];
    [self.view addSubview:self.tableViewController.view];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.tableViewController viewDidAppear:animated];
}

#define offset (460 - self.view.frame.size.height)
- (void)viewWillAppear:(BOOL)animated {
    [((WEAppDelegate *)[UIApplication sharedApplication].delegate) showTabbar];
    [self.tableViewController.view resetHeight:self.view.frame.size.height];
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
        NSSet *notificationsSet = [Notification insertNotifications:responseObject];
        [[WTCoreDataManager sharedManager].currentUser addOwnedNotifications:notificationsSet];
        
        if (notificationsSet.count != 0) {
            if (!self.isVisible)
                [self.tableViewController loadUnreadNotifications:notificationsSet.count];
        }
    } failureBlock:^(NSError *error) {
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
    [self.navigationController pushViewController:pushVC animated:YES];
}

//- (IBAction)test:(id)sender
//{
//    WESettingViewController *vc = [[WESettingViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
//}

@end
