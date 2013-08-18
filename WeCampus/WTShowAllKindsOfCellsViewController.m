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

#import "WEActivityCell.h"
#import "WESearchResultAvatarCell.h"

#import "WEActivityDetailViewController.h"

@interface WTShowAllKindsOfCellsViewController ()
@property (nonatomic, strong) WESearchResultAvatarCell *userAvatarCell;
@property (nonatomic, strong) WESearchResultAvatarCell *orgAvatarCell;
@end

@implementation WTShowAllKindsOfCellsViewController

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
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Object *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([object isKindOfClass:[Activity class]]) {
        WEActivityCell *activityCell = (WEActivityCell *)cell;
        [activityCell configureCellWithActivity:(Activity *)object];
    }  else if ([object isKindOfClass:[Organization class]]) {
        WESearchResultAvatarCell *orgCell = (WESearchResultAvatarCell *)cell;
        //[orgCell configureCellWithIndexPath:indexPath organization:(Organization *)object];
    } else if ([object isKindOfClass:[User class]]) {
        WESearchResultAvatarCell *userCell = (WESearchResultAvatarCell *)cell;
        //[userCell configureCellWithIndexPath:indexPath user:(User *)object];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Object *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([object isKindOfClass:[Activity class]])
        return kWEActivityCellHeight;
    else if ([object isKindOfClass:[Organization class]])
        return kWESearchAvatarCellHeight;
    else if ([object isKindOfClass:[User class]])
        return kWESearchAvatarCellHeight;
    else
        return 0;
}

- (NSString *)customCellClassNameAtIndexPath:(NSIndexPath *)indexPath {
    Object *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([object isKindOfClass:[Activity class]])
        return @"WEActivityCell";
    else if ([object isKindOfClass:[Organization class]])
        return @"WESearchResultAvatarCell";
    else if ([object isKindOfClass:[User class]])
        return @"WESearchResultAvatarCell";
    else
        return nil;
}

- (UIViewController *)detailViewControllerForIndexPath:(NSIndexPath *)indexPath {
    Object *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    UIViewController *vc = nil;
    
    if ([object isKindOfClass:[Activity class]]) {
        vc = [WEActivityDetailViewController createDetailViewControllerWithModel:(Activity *)object];
    }
    
//    if ([object isKindOfClass:[News class]]) {
//        vc = [WTNewsDetailViewController createDetailViewControllerWithNews:(News *)object backBarButtonText:backBarButtonText];
//    } else if ([object isKindOfClass:[Activity class]]) {
//        vc = [WTActivityDetailViewController createDetailViewControllerWithActivity:(Activity *)object backBarButtonText:backBarButtonText];
//    } else if ([object isKindOfClass:[Organization class]]) {
//        vc = [WTOrganizationDetailViewController createDetailViewControllerWithOrganization:(Organization *)object backBarButtonText:backBarButtonText];
//    } else if ([object isKindOfClass:[User class]]) {
//        // 如果是当前用户, 则进行Tab跳转
//        if ([WTCoreDataManager sharedManager].currentUser == object) {
//            [[UIApplication sharedApplication].rootTabBarController clickTabWithName:WTRootTabBarViewControllerMe];
//            return nil;
//        }
//        vc = [WTUserDetailViewController createDetailViewControllerWithUser:(User *)object backBarButtonText:backBarButtonText];
//    } else if ([object isKindOfClass:[Star class]]) {
//        vc = [WTStarDetailViewController createDetailViewControllerWithStar:(Star *)object backBarButtonText:backBarButtonText];
//    } else {
//        return nil;
//    }
    return vc;
}

@end
