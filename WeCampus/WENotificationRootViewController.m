//
//  WENotificationRootViewController.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-24.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WENotificationRootViewController.h"
#import "WESettingViewController.h"

@interface WENotificationRootViewController ()

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)test:(id)sender
{
    WESettingViewController *vc = [[WESettingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
