//
//  WEActivityDetailViewController.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-15.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WEActivityDetailViewController.h"
#import "WEActivityDetailHeaderView.h"

@interface WEActivityDetailViewController ()
@property (strong, nonatomic) Activity *act;
@property (strong, nonatomic) WEActivityDetailHeaderView *headerView;
@end

@implementation WEActivityDetailViewController

+ (WEActivityDetailViewController *)createDetailViewControllerWithModel:(Activity *)act
{
    WEActivityDetailViewController *vc = [[WEActivityDetailViewController alloc] initWithNibName:@"WEActivityDetailViewController" bundle:nil];
    vc.act = act;
    
    return vc;
}

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
    self.title = @"活动详情";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    [self configureHeaderView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UI Method

- (void)updateScrollView
{
    
}

- (void)configureHeaderView
{
    self.headerView = [WEActivityDetailHeaderView createActivityDetailViewWithInfo:self.act];
    [self.scrollView addSubview:self.headerView];
}

@end
