//
//  WESettingViewController.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-18.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WESettingViewController.h"
#import "WEAboutViewController.h"
#import "WTCoreDataManager.h"
#import "WTClient.h"

@interface WESettingViewController ()
@end

@implementation WESettingViewController

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
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    self.title = @"设置";
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 30);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)didClickSeeAboutButton:(id)sender
{
    WEAboutViewController *aboutVC = [[WEAboutViewController alloc] init];
    [self.navigationController pushViewController:aboutVC animated:YES];
}

- (IBAction)didClickClearCache:(id)sender
{
    [[WTCoreDataManager sharedManager] eraseAllData];
}

- (IBAction)didClickLogout:(id)sender
{
    [[WTClient sharedClient] logout];
    [WTCoreDataManager sharedManager].currentUser = nil;
}
@end
