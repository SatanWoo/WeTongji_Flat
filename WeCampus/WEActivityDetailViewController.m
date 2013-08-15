//
//  WEActivityDetailViewController.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-15.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WEActivityDetailViewController.h"
#import "WEActivityDetailHeaderView.h"
#import "WEActivityDetailContentView.h"
#import "WEDetailTransparentHeaderView.h"

@interface WEActivityDetailViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) Activity *act;
@property (strong, nonatomic) WEActivityDetailContentView *contentViewCell;
@end

@implementation WEActivityDetailViewController

+ (WEActivityDetailViewController *)createDetailViewControllerWithModel:(Activity *)act
{
    WEActivityDetailViewController *vc = [[WEActivityDetailViewController alloc] initWithNibName:@"WEActivityDetailViewController" bundle:nil];
    vc.act = act;
    
    return vc;
}

- (WEActivityDetailContentView *)contentViewCell
{
    if (!_contentViewCell) {
        _contentViewCell = [WEActivityDetailContentView createDetailContentViewWithInfo:self.act];
    }
    return _contentViewCell;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


#define kDefaultOffsetY 400
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self.tableView setContentOffset:CGPointMake(0, kDefaultOffsetY)];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) return 0;
    else return 1;
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) return 80;
    else return 246;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.contentViewCell;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.contentViewCell.frame.size.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) return [WEDetailTransparentHeaderView createTransparentHeaderView];
    return [WEActivityDetailHeaderView createActivityDetailViewWithInfo:self.act];
}

#pragma mark - UI Method

@end
