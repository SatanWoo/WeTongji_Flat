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

@interface WENotificationRootViewController () <WTInnerNotificationTableViewControllerDelegate>

@property (nonatomic, strong) WTInnerNotificationTableViewController *tableViewController;
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
    [self.view addSubview:self.tableViewController.view];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.tableViewController viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableViewController.view resetHeight:self.view.frame.size.height];
    self.isVisible = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.isVisible = NO;
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
