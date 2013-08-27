//
//  WESearchResultAcitivitiesViewController.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-27.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WESearchResultAcitivitiesViewController.h"
#import "WEActivityCell.h"

@interface WESearchResultAcitivitiesViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSArray *datas;
@end

@implementation WESearchResultAcitivitiesViewController

+ (WESearchResultAcitivitiesViewController *)createResultActsViewControllerWithData:(NSArray *)datas
{
    WESearchResultAcitivitiesViewController *controller = [[WESearchResultAcitivitiesViewController alloc] init];
    controller.datas = datas;
    
    return controller;
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
    self.title = @"活动";
}

- (void)configureNavigationBar
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)reloadWithDatas:(NSArray *)datas
{
    if (!datas) return;
    self.datas = [NSArray arrayWithArray:datas];
    [self.tableView reloadData];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kWEActivityCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"Cell";
    WEActivityCell *cell = (WEActivityCell *)[tableView dequeueReusableCellWithIdentifier:identifer];
    Activity *act = (Activity *)[self.datas objectAtIndex:indexPath.row];
    if (cell == nil) {
        cell = [WEActivityCell createWEActivityCellWithActs:act];
    } else {
        [cell configureCellWithActivity:act];
    }
    
    return cell;
}

@end
