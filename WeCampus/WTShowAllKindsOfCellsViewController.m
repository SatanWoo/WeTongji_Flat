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
#import "WESeeMoreObjectCell.h"

#import "WEActivityDetailViewController.h"

#define kActivitySection 2

@interface WTShowAllKindsOfCellsViewController ()
//@property (nonatomic, strong) WESearchResultAvatarCell *userAvatarCell;
//@property (nonatomic, strong) WESearchResultAvatarCell *orgAvatarCell;
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

#pragma mark - Pay Attention

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger numberOfRows = [self.fetchedResultsController.sections[indexPath.section] numberOfObjects];
    if (indexPath.row >= numberOfRows)
        return nil;
        
    NSString *name = [self customCellClassNameAtIndexPath:indexPath];
    
    NSString *cellIdentifier = name ? name : @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        if (name) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:[self customCellClassNameAtIndexPath:indexPath] owner:self options:nil];
            cell = nib[0];
        }
        else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = [self.fetchedResultsController.sections[section] numberOfObjects];
    return number;
}

#pragma mark - normal

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[WESeeMoreObjectCell class]]) return;
    
    Object *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([object isKindOfClass:[Activity class]]) {
        
        if (indexPath.row > 3) return;
        WEActivityCell *activityCell = (WEActivityCell *)cell;
        [activityCell configureCellWithActivity:(Activity *)object];
    }  else if ([object isKindOfClass:[Organization class]]) {
        if (indexPath.row > 0) return;
        WESearchResultAvatarCell *orgCell = (WESearchResultAvatarCell *)cell;
        [orgCell configureWithObject:(LikeableObject *)object];
    } else if ([object isKindOfClass:[User class]]) {
        if (indexPath.row > 0) return;
        WESearchResultAvatarCell *userCell = (WESearchResultAvatarCell *)cell;
        [userCell configureWithObject:(LikeableObject *)object];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Object *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([object isKindOfClass:[Activity class]]) {
        if (indexPath.row <= 2)
            return kWEActivityCellHeight;
        else if (indexPath.row == 3)
            return kWESeeMoreObjectCellHeight;
        else
            return 0;
    } else if ([object isKindOfClass:[Organization class]]) {
        if (indexPath.row > 0) return 0;
        return kWESearchAvatarCellHeight;
    } else if ([object isKindOfClass:[User class]]) {
        if (indexPath.row > 0) return 0;
        return kWESearchAvatarCellHeight;
    } else
        return 0;
}

- (NSString *)customCellClassNameAtIndexPath:(NSIndexPath *)indexPath {
    Object *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([object isKindOfClass:[Activity class]]) {
        if (indexPath.row <= 2) {
            return @"WEActivityCell";
        } else if (indexPath.row == 3){
            return @"WESeeMoreObjectCell";
        } else {
            return nil;
        }
    } else if ([object isKindOfClass:[Organization class]]) {
        if (indexPath.row > 0) return nil;
        return @"WESearchResultAvatarCell";
    } else if ([object isKindOfClass:[User class]]) {
        if (indexPath.row > 0) return nil;
        return @"WESearchResultAvatarCell";
    } else
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
