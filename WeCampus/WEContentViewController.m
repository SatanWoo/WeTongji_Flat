//
//  WEContentViewController.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-11.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WEContentViewController.h"
#import "WENavigationViewController.h"
#import "UIBarButtonItem+Addition.h"

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
     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc ] initBarButtonWithTarget:self action:@selector(didClickBackButton) normalImage:@"back_btn"];
    [self configureNavigationBar];
    [self configureGesture];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [((WEAppDelegate *)[UIApplication sharedApplication].delegate) hideTabbar];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Template Method
- (BOOL)shouldHideNavigationBar
{
    return NO;
}

- (void)configureNavigationBar
{
    
}

- (void)configureGesture
{
    UISwipeGestureRecognizer  *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeToPop:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGesture];
}

#pragma mark - Private 
- (void)didClickBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)swipeToPop:(UISwipeGestureRecognizer *)swipe
{
    [self didClickBackButton];
}


@end
