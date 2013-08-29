//
//  WESearchResultOrgsViewController.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-29.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WESearchResultOrgsViewController.h"
#import "WEOrgListCell.h"
#import "Organization+Addition.h"

@interface WESearchResultOrgsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSArray *datas;
@end

@implementation WESearchResultOrgsViewController

+ (WESearchResultOrgsViewController *)createResultOrgsViewControllerWithData:(NSArray *)datas
{
    WESearchResultOrgsViewController *controller = [[WESearchResultOrgsViewController alloc] init];
    controller.datas = datas;
    
    return controller;
}

- (void)reloadWithDatas:(NSArray *)datas
{
    if (!datas) return;
    self.datas = [NSArray arrayWithArray:datas];
    [self.tableView reloadData];
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
    self.title = @"组织机构";
}

- (void)configureNavigationBar
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.datas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"Cell";
    WEOrgListCell *cell = (WEOrgListCell *)[tableView dequeueReusableCellWithIdentifier:identifer];
    Organization *org = (Organization *)[self.datas objectAtIndex:indexPath.row];
    if (cell == nil) {
        cell = [WEOrgListCell createOrgListCellWithOrg:org];
    } else {
        [cell configureOrgListWithOrg:org];
    }
    
    return cell;
}


@end
