//
//  WTShowAllKindsOfCellsViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-30.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTShowAllKindsOfCellsViewController.h"
#import "UIApplication+WTAddition.h"

#import "News+Addition.h"
#import "Activity+Addition.h"
#import "Star+Addition.h"
#import "Organization+Addition.h"
#import "User+Addition.h"

#import "WTNewsCell.h"
#import "WTActivityCell.h"
#import "WTOrganizationCell.h"
#import "WTUserCell.h"
#import "WTStarCell.h"

#import "WTNewsDetailViewController.h"
#import "WTActivityDetailViewController.h"
#import "WTOrganizationDetailViewController.h"
#import "WTUserDetailViewController.h"
#import "WTStarDetailViewController.h"

@interface WTShowAllKindsOfCellsViewController ()

@end

@implementation WTShowAllKindsOfCellsViewController

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
	// Do any additional setup after loading the view.
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Object *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([object isKindOfClass:[News class]]) {
        WTNewsCell *newsCell = (WTNewsCell *)cell;
        [newsCell configureCellWithIndexPath:indexPath news:(News *)object];
    } else if ([object isKindOfClass:[Activity class]]) {
        WTActivityCell *activityCell = (WTActivityCell *)cell;
        [activityCell configureCellWithIndexPath:indexPath activity:(Activity *)object];
    } else if ([object isKindOfClass:[Organization class]]) {
        WTOrganizationCell *orgCell = (WTOrganizationCell *)cell;
        [orgCell configureCellWithIndexPath:indexPath organization:(Organization *)object];
    } else if ([object isKindOfClass:[User class]]) {
        WTUserCell *userCell = (WTUserCell *)cell;
        [userCell configureCellWithIndexPath:indexPath user:(User *)object];
    } else if ([object isKindOfClass:[Star class]]) {
        WTStarCell *starCell = (WTStarCell *)cell;
        [starCell configureCellWithIndexPath:indexPath Star:(Star *)object];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Object *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([object isKindOfClass:[News class]])
        return 105.0f;
    else if ([object isKindOfClass:[Activity class]])
        return 92.0f;
    else if ([object isKindOfClass:[Organization class]])
        return 78.0f;
    else if ([object isKindOfClass:[User class]])
        return 78.0f;
    else if ([object isKindOfClass:[Star class]])
        return 78.0f;
    else
        return 0;
}

- (NSString *)customCellClassNameAtIndexPath:(NSIndexPath *)indexPath {
    Object *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([object isKindOfClass:[News class]])
        return @"WTNewsCell";
    else if ([object isKindOfClass:[Activity class]])
        return @"WTActivityCell";
    else if ([object isKindOfClass:[Organization class]])
        return @"WTOrganizationCell";
    else if ([object isKindOfClass:[User class]])
        return @"WTUserCell";
    else if ([object isKindOfClass:[Star class]])
        return @"WTStarCell";
    else
        return nil;
}

- (UIViewController *)detailViewControllerForIndexPath:(NSIndexPath *)indexPath {
    Object *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    UIViewController *vc = nil;
    NSString *backBarButtonText = NSLocalizedString(@"Search", nil);
    if ([object isKindOfClass:[News class]]) {
        vc = [WTNewsDetailViewController createDetailViewControllerWithNews:(News *)object backBarButtonText:backBarButtonText];
    } else if ([object isKindOfClass:[Activity class]]) {
        vc = [WTActivityDetailViewController createDetailViewControllerWithActivity:(Activity *)object backBarButtonText:backBarButtonText];
    } else if ([object isKindOfClass:[Organization class]]) {
        vc = [WTOrganizationDetailViewController createDetailViewControllerWithOrganization:(Organization *)object backBarButtonText:backBarButtonText];
    } else if ([object isKindOfClass:[User class]]) {
        // 如果是当前用户, 则进行Tab跳转
        if ([WTCoreDataManager sharedManager].currentUser == object) {
            [[UIApplication sharedApplication].rootTabBarController clickTabWithName:WTRootTabBarViewControllerMe];
            return nil;
        }
        vc = [WTUserDetailViewController createDetailViewControllerWithUser:(User *)object backBarButtonText:backBarButtonText];
    } else if ([object isKindOfClass:[Star class]]) {
        vc = [WTStarDetailViewController createDetailViewControllerWithStar:(Star *)object backBarButtonText:backBarButtonText];
    } else {
        return nil;
    }
    return vc;
}

@end
