//
//  WEHomeNavigationViewController.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-11.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WEHomeNavigationViewController.h"
#import "WEHomeRootViewController.h"

@interface WEHomeNavigationViewController ()

@end

@implementation WEHomeNavigationViewController

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

- (void)initRootViewController
{
    WEHomeRootViewController *rootViewController = [[WEHomeRootViewController alloc] init];
    rootViewController.hidesBottomBarWhenPushed = NO;
    [self pushViewController:rootViewController animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
