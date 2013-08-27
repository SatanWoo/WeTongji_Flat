//
//  WESearchResultGroupObjectViewController.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-27.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WESearchResultGroupObjectViewController.h"
#import "WEColloectionViewController.h"
#import "WEFriendHeadCell.h"
#import "WEMeViewController.h"

@interface WESearchResultGroupObjectViewController () <WEColloectionViewControllerDelegate>
@property (strong, nonatomic) WEColloectionViewController *collectionViewController;
@end

@implementation WESearchResultGroupObjectViewController 

+ (WESearchResultGroupObjectViewController *)createGroupObjectViewControllerWithData:(NSArray *)data andTitle:(NSString *)title
{
    WESearchResultGroupObjectViewController *controller = [[WESearchResultGroupObjectViewController alloc] init];
    controller.title = title;
    [controller reloadWithData:data];
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
    [self configureCollectionView];
}

- (void)configureNavigationBar
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)reloadWithData:(NSArray *)objects
{
    if (!objects) return;
    [self.collectionViewController setData:objects];
}

#pragma mark - UI Method
- (void)configureCollectionView
{
    [self.collectionViewController setCellClass:[WEFriendHeadCell class]];
    self.collectionViewController.delegate = self;
    self.collectionViewController.view.frame = self.view.bounds;
    [self.view addSubview:self.collectionViewController.view];
}

#pragma mark - Properties
- (WEColloectionViewController *)collectionViewController
{
    if (!_collectionViewController) {
        _collectionViewController = [[WEColloectionViewController alloc] init];
        _collectionViewController.delegate = self;
    }
    return _collectionViewController;
}

#pragma mark - WEColloectionViewControllerDelegate
- (void)WEColloectionViewController:(WEColloectionViewController*)vc didSelect:(id)obj
{
    if ([obj isKindOfClass:[User class]]) {
        WEMeViewController* temp = [[WEMeViewController alloc] init];
        [temp configureWithUser:(User *)obj];
        
        [self.navigationController pushViewController:temp animated:YES];
    }
}

@end
