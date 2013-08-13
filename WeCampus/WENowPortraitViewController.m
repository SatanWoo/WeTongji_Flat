//
//  WENowPortraitViewController.m
//  WeCampus
//
//  Created by Song on 13-8-12.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WENowPortraitViewController.h"

@interface WENowPortraitViewController ()
{
    WENowPortraitWeekListViewController *weekTitleVC;
    WENowPortraitDayEventListViewController *dayEventListVC;
}
@end

@implementation WENowPortraitViewController

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

- (void)viewDidAppear:(BOOL)animated
{
    if(!weekTitleVC)
    {
        weekTitleVC = [[WENowPortraitWeekListViewController alloc] init];
        weekTitleVC.delegate = self;
        weekTitleVC.view.frame = self.weekTitleContainerView.bounds;
        [self.weekTitleContainerView addSubview:weekTitleVC.view];
    }
    if(!dayEventListVC)
    {
        dayEventListVC = [[WENowPortraitDayEventListViewController alloc] init];
        
        dayEventListVC.view.frame = self.dayEventListContainerView.bounds;
        [self.dayEventListContainerView addSubview:dayEventListVC.view];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Week List Delegate
- (void)weekListViewController:(WENowPortraitWeekListViewController*)vc dateDidChanged:(NSDate*)date
{
    NSLog(@"%@",date);
}

@end
