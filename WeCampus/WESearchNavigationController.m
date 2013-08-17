//
//  WESearchNavigationController.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-17.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WESearchNavigationController.h"
#import "WESearchRootViewController.h"

@interface WESearchNavigationController ()

@end

@implementation WESearchNavigationController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initRootViewController
{
    WESearchRootViewController *rootViewController = [[WESearchRootViewController alloc] init];
    rootViewController.hidesBottomBarWhenPushed = NO;
    [self pushViewController:rootViewController animated:NO];
}


@end
