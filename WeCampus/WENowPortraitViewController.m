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
    weekTitleVC = [[WENowPortraitWeekListViewController alloc] init];
    weekTitleVC.delegate = self;
    weekTitleVC.view.frame = self.weekTitleContainerView.bounds;
    [self.weekTitleContainerView addSubview:weekTitleVC.view];
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)previousDay:(id)sender {
    [weekTitleVC selectPreviousDay];
}

- (IBAction)nextDay:(id)sender {
    [weekTitleVC selectNextDay];
}
@end
