//
//  WEActivityDetailViewController.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-15.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WEActivityDetailViewController.h"
#import "WEActivityDetailHeaderView.h"
#import "WEActivityDetailControlAreaView.h"
#import "WEActivityDetailContentView.h"

@interface WEActivityDetailViewController ()
@property (strong, nonatomic) Activity *act;
@property (strong, nonatomic) WEActivityDetailHeaderView *headerView;
@property (strong, nonatomic) WEActivityDetailControlAreaView *controlAreaView;
@property (strong, nonatomic) WEActivityDetailContentView *contentView;
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
    self.title = NSLocalizedString(@"Activity Detail", nil);
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    [self updateScrollView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UI Method

- (void)updateScrollView
{
    [self configureHeaderView];
    [self configureControlArea];
    [self configureContentView];
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, self.contentView.frame.size.height + self.contentView.frame.origin.y)];
}

- (void)configureHeaderView
{
    self.headerView = [WEActivityDetailHeaderView createActivityDetailViewWithInfo:self.act];
    [self.scrollView addSubview:self.headerView];
}

- (void)configureControlArea
{
    self.controlAreaView = [WEActivityDetailControlAreaView createActivityDetailViewWithInfo:self.act];
    [self.controlAreaView resetOriginY:self.headerView.frame.origin.y + self.headerView.frame.size.height];
    [self.scrollView addSubview:self.controlAreaView];
}

- (void)configureContentView
{
    self.contentView = [WEActivityDetailContentView createDetailContentViewWithInfo:self.act];
    [self.contentView resetOriginY:self.controlAreaView.frame.origin.y + self.controlAreaView.frame.size.height];
    [self.scrollView addSubview:self.contentView];
}

@end
