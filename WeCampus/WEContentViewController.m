//
//  WEContentViewController.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-11.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WEContentViewController.h"

@interface WEContentViewController ()

@end

@implementation WEContentViewController

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
    [self configureNavigationBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldHideNavigationBar
{
    return NO;
}

- (void)configureNavigationBar
{
    
}

@end
