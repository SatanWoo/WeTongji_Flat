//
//  WERootViewController.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-11.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WERootViewController.h"
#import "WENavigationViewController.h"
#import "WEContentViewController.h"
#import "WEAppDelegate.h"

@interface WERootViewController () <UINavigationControllerDelegate>

@end

@implementation WERootViewController

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
    self.navigationController.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [((WEAppDelegate *)[UIApplication sharedApplication].delegate) showTabbar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldHideNavigationBar
{
    return YES;
}

@end
