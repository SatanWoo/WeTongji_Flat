//
//  WTElectricityQueryViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-3-2.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTElectricityQueryViewController.h"
#import "WTRootNavigationController.h"
#import "UIApplication+WTAddition.h"
#import "WTResourceFactory.h"

@implementation WTElectricityQueryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationBar];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView:)]];
}

+ (void)show {
    WTElectricityQueryViewController *vc = [[WTElectricityQueryViewController alloc] init];
    WTRootNavigationController *nav = [[WTRootNavigationController alloc] initWithRootViewController:vc];
    
    UIViewController *rootVC = [UIApplication sharedApplication].rootTabBarController;
    [rootVC presentViewController:nav animated:YES completion:nil];
}

#pragma mark - Logic methods

- (void)dismissView {
    UIViewController *rootVC = [UIApplication sharedApplication].rootTabBarController;
    [rootVC dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UI methods

- (void)configureNavigationBar {
    UIBarButtonItem *cancalBarButtonItem = [WTResourceFactory createNormalBarButtonWithText:NSLocalizedString(@"Not now", nil) target:self action:@selector(didClickCancelButton:)];
    self.navigationItem.leftBarButtonItem = cancalBarButtonItem;
}

#pragma mark - Actions

- (void)didClickCancelButton:(UIButton *)sender {
    [self dismissView];
}

- (void)getElectricityBalance {
    self.label.text = @"正在加载电量...";
    BlockARCWeakSelf weakSelf = self;
    [[WTElectricityBalanceQueryService sharedService] getElectricChargeBalanceWithDistrict:self.districtTextField.text building:self.buildingTextField.text room:self.roomTextField.text successBlock:^(id responseObject) {
        NSArray *result = responseObject;
        NSNumber *balance = result[WTElectricityBalanceQueryServiceResultIndexTodayBalance];
        NSNumber *avarageUse = result[WTElectricityBalanceQueryServiceResultIndexAvarageUse];
        weakSelf.label.text = [NSString stringWithFormat:@"剩余电量: %.2f kWh, 平均日用电量: %.2f kWh", balance.floatValue, avarageUse.floatValue];
        [weakSelf.label sizeToFit];
    } failureBlock:^(NSError *error) {
        NSLog(@"Query Electricity Balance Failure:%@", error.localizedDescription);
        weakSelf.label.text = @"加载电量失败";
    }];
}

- (IBAction)didClickRefreshButton:(UIButton *)sender {
    [self getElectricityBalance];
}

#pragma mark - Handle gesture recognizer

- (void)didTapView:(UIGestureRecognizer*)gestureRecognizer {
    [self.view endEditing:YES];
}

@end
