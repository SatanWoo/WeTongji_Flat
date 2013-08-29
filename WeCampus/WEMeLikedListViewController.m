//
//  WEMeLikedListViewController.m
//  WeCampus
//
//  Created by Song on 13-8-28.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WEMeLikedListViewController.h"
#import "Organization+Addition.h"
#import "Activity+Addition.h"
#import "User+Addition.h"
#import "News+Addition.h"
#import "Activity+Addition.h"
#import "Star+Addition.h"
#import "Organization+Addition.h"
#import "User+Addition.h"

#import "WEActivityCell.h"
#import "WESearchResultAvatarCell.h"
#import "WESeeMoreObjectCell.h"

#import "WEActivityDetailViewController.h"
#import "WESearchResultGroupObjectViewController.h"
#import "WESearchResultAcitivitiesViewController.h"
#import "WESearchResultOrgsViewController.h"
#import "WESearchResultHeaderView.h"

@interface WEMeLikedListViewController ()<UITableViewDataSource>
{
    NSArray *sectionTitleArray;
    NSDictionary *sectionData;
}
@end

@implementation WEMeLikedListViewController


static int orgSection = 100;
static int userSection = 100;
static int actSection = 100;


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
    [self initTableData];
    [self configureScrollView];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTableData
{
    NSMutableArray *titles = [@[] mutableCopy];
    NSMutableDictionary *data = [@{} mutableCopy];
    if(self.actsArray.count > 1)
    {
        NSString *key = @"Activity";
        [titles addObject:key];
        data[key] = self.actsArray;
    }
    if(self.orgsArray.count > 1)
    {
        NSString *key = @"Organization";
        [titles addObject:key];
        data[key] = self.orgsArray;
    }
    if(self.usersArray.count > 1)
    {
        NSString *key = @"User";
        [titles addObject:key];
        data[key] = self.usersArray;
    }
    sectionTitleArray = titles;
    sectionData = data;
}

- (void)configureScrollView
{
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height + 1);
    self.scrollView.hidden = YES;
}

- (void)setScrollViewVisible:(BOOL)visible
{
    self.scrollView.hidden = !visible;
    self.tableView.hidden = visible;
}

#pragma mark - Pay Attention

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return sectionTitleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger numberOfRows = [sectionData[sectionTitleArray[indexPath.section]] count];
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
    NSInteger number = [sectionData[sectionTitleArray[section]] count];
    return number;
}

#pragma mark - normal

- (Object*)objectAtIndexPath:(NSIndexPath*)indexPath
{
    NSString *key = sectionTitleArray[indexPath.section];
    NSArray *arr = sectionData[key];
    Object *object = arr[indexPath.row];
    return object;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[WESeeMoreObjectCell class]]) return;
    
    Object *object = [self objectAtIndexPath:indexPath];
    
    if ([object isKindOfClass:[Activity class]]) {
        if (indexPath.row > 3) return;
        WEActivityCell *activityCell = (WEActivityCell *)cell;
        [activityCell configureCellWithActivity:(Activity *)object];
    }  else if ([object isKindOfClass:[Organization class]]) {
        if (indexPath.row > 0) return;
        WESearchResultAvatarCell *orgCell = (WESearchResultAvatarCell *)cell;
        [self configureWithOrgs:orgCell];
    } else if ([object isKindOfClass:[User class]]) {
        if (indexPath.row > 0) return;
        WESearchResultAvatarCell *userCell = (WESearchResultAvatarCell *)cell;
        [userCell configureWithObject:(LikeableObject *)object];
    }
}

- (void)configureWithUsers:(WESearchResultAvatarCell *)cell
{
    if ([self.usersArray count]) {
        for (User *user in self.usersArray) {
            [cell configureWithObject:user];
        }
    }
}

- (void)configureWithOrgs:(WESearchResultAvatarCell *)cell
{
    if ([self.orgsArray count]) {
        for (Organization *org in self.orgsArray) {
            [cell configureWithObject:org];
        }
    }
}

                    
                    
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Object *object = [self objectAtIndexPath:indexPath];
    if ([object isKindOfClass:[Activity class]]) {
        actSection = indexPath.section;
        
        if (indexPath.row <= 2)
            return kWEActivityCellHeight;
        else if (indexPath.row == 3)
            return kWESeeMoreObjectCellHeight;
        else
            return 0;
    } else if ([object isKindOfClass:[Organization class]]) {
        orgSection = indexPath.section;
        if (indexPath.row > 0) return 0;
        return kWESearchAvatarCellHeight;
        
        
    } else if ([object isKindOfClass:[User class]]) {
        userSection = indexPath.section;
        if (indexPath.row > 0) return 0;
        return kWESearchAvatarCellHeight;
    } else
        return 0;
}

- (NSString *)customCellClassNameAtIndexPath:(NSIndexPath *)indexPath {
    Object *object = [self objectAtIndexPath:indexPath];
    NSLog(@"object name is %@", object);
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
    UIViewController *vc = nil;
    if (indexPath.section == actSection) {
        if (indexPath.row >= 3) {
            vc = [WESearchResultAcitivitiesViewController createResultActsViewControllerWithData:self.actsArray];
        } else {
            Object *object = [self objectAtIndexPath:indexPath];
            if ([object isKindOfClass:[Activity class]]) {
                vc = [WEActivityDetailViewController createDetailViewControllerWithModel:(Activity *)object];
            }
        }
    } else if (indexPath.section == userSection) {
        vc = [WESearchResultGroupObjectViewController createGroupObjectViewControllerWithData:self.usersArray andTitle:@"用户"];
    } else if (indexPath.section == orgSection) {
        vc = [WESearchResultOrgsViewController createResultOrgsViewControllerWithData:self.orgsArray];
    }
    return vc;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *sectionName = NSLocalizedString(sectionTitleArray[section],nil);
    NSInteger count = [self tableView:tableView numberOfRowsInSection:section];
    
    WESearchResultHeaderView *headerView = [WESearchResultHeaderView createSearchResultHeaderViewWithName:[NSString stringWithFormat:@"%@(%d)", sectionName, count]];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    UIViewController *vc = [super detailViewControllerForIndexPath:indexPath];
//    if (vc)
//        [self.delegate wantToPushViewController:vc];
}

- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kWESearchResultHeaderViewHeight;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = kWESearchResultHeaderViewHeight;
    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}
@end
