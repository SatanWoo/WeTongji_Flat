//
//  WENotificationControllerViewController.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-24.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WENotificationControllerViewController.h"

@interface WENotificationControllerViewController ()

@end

@implementation WENotificationControllerViewController

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
    // Dispose of any resources that can be recreated.
}

- (void)initRootViewController
{
    WENotificationRootViewController *rootViewController = [[WENotificationRootViewController alloc] init];
    [self pushViewController:rootViewController animated:NO];
}

@end
