//
//  WENavigationViewController.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-11.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WENavigationViewController.h"
#import "WERootViewController.h"

@interface WENavigationViewController ()

@end

@implementation WENavigationViewController

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
    [self initRootViewController];
    [self configureNavigationBar];
}

- (void)configureNavigationBar
{
    if ([self.rootViewController shouldHideNavigationBar]) {
        self.navigationBar.hidden = YES;
    } else {
        self.navigationBar.hidden = NO;
    }
}

- (void)initRootViewController
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
