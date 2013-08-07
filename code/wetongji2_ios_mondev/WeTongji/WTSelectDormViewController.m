//
//  WTSelectDormViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-7-8.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTSelectDormViewController.h"
#import "WTConfigLoader.h"
#import "WTResourceFactory.h"
#import "WTDormCell.h"
#import "WTInputDormRoomNumberView.h"
#import "UIApplication+WTAddition.h"
#import "WTNavigationViewController.h"

@interface WTSelectDormViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *districtIndexArray;

@property (nonatomic, strong) NSDictionary *districtBuildingDictionary;

@property (nonatomic, strong) WTInputDormRoomNumberView *dormRoomNumberView;

@end

@implementation WTSelectDormViewController

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
    [self configureNavigationBar];
    
    [self configureDormRoomNumberView];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WTRootBgUnit"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

+ (void)showWithDelegate:(id<WTSelectDormViewControllerDelegate>)delegate {
    WTSelectDormViewController *vc = [[WTSelectDormViewController alloc] init];
    
    vc.delegate = delegate;
    
    WTNavigationViewController *nav = [[WTNavigationViewController alloc] initWithRootViewController:vc];
    
    [[UIApplication sharedApplication].rootTabBarController presentViewController:nav animated:YES completion:nil];
}

#pragma mark - Properties

- (NSArray *)districtIndexArray {
    if (!_districtIndexArray) {
        _districtIndexArray = self.districtBuildingDictionary[kDistrictIndexArray];
    }
    return _districtIndexArray;
}

- (NSDictionary *)districtBuildingDictionary {
    if (!_districtBuildingDictionary) {
        _districtBuildingDictionary = [[WTConfigLoader sharedLoader] loadConfig:KWTDistrictBuildingMap];
    }
    return _districtBuildingDictionary;
}

#pragma mark - UI methods

- (void)configureNavigationBar {
    self.navigationItem.leftBarButtonItem = [WTResourceFactory createNormalBarButtonWithText:NSLocalizedString(@"Cancel", nil) target:self action:@selector(didClickCancelButton:)];
    
    self.navigationItem.titleView = [WTResourceFactory createNavigationBarTitleViewWithText:NSLocalizedString(@"Select Dorm", nil)];
}

- (void)configureDormRoomNumberView {
    self.dormRoomNumberView = [WTInputDormRoomNumberView createView];
    self.tableView.tableHeaderView = self.dormRoomNumberView;
}

- (void)configureCell:(WTDormCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    [cell configureCellWithIndexPath:indexPath buildingName:self.districtBuildingDictionary[self.districtIndexArray[indexPath.section]][indexPath.row]];
}

#pragma mark - Actions

- (void)didClickCancelButton:(UIButton *)sender {
    [[UIApplication sharedApplication].rootTabBarController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    NSString *cellIdentifier = @"WTDormCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = nib.lastObject;
    }
    [self configureCell:(WTDormCell *)cell atIndexPath:indexPath];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WTTableViewSectionBg"]];
    CGFloat sectionHeaderHeight = bgImageView.frame.size.height;
    
    NSString *sectionName = self.districtIndexArray[section];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0, tableView.bounds.size.width - 20.0f, sectionHeaderHeight)];
    label.text = sectionName;
    label.font = [UIFont boldSystemFontOfSize:12.0f];
    label.textColor = WTSectionHeaderViewGrayColor;
    label.backgroundColor = [UIColor clearColor];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 24.0f)];
    headerView.backgroundColor = [UIColor clearColor];
    [headerView addSubview:bgImageView];
    [headerView addSubview:label];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *roomNumber = self.dormRoomNumberView.roomNumberTextField.text;
    if ([roomNumber isEqualToString:@""]) {
        [self.dormRoomNumberView.roomNumberTextField becomeFirstResponder];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else {
        NSString *distribute = self.districtIndexArray[indexPath.section];
        NSString *building = self.districtBuildingDictionary[distribute][indexPath.row];
        [self.delegate selectDormViewController:self didSelectDistribute:distribute building:building roomNumber:roomNumber];
        [[UIApplication sharedApplication].rootTabBarController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *buildingArray = self.districtBuildingDictionary[self.districtIndexArray[section]];
    return buildingArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.districtIndexArray.count;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

@end
