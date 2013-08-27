//
//  WTSearchResultTableViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-3-9.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTSearchResultTableViewController.h"
#import "NSUserDefaults+WTAddition.h"
#import "WeTongjiSDK.h"
#import "News+Addition.h"
#import "Activity+Addition.h"
#import "Star+Addition.h"
#import "Organization+Addition.h"
#import "Object+Addition.h"
#import "Controller+Addition.h"
#import "User+Addition.h"
#import "WESearchResultHeaderView.h"

@interface WTSearchResultTableViewController ()

@property (nonatomic, copy) NSString *searchKeyword;
@property (nonatomic, assign) NSInteger searchCategory;

@end

@implementation WTSearchResultTableViewController

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
    [self configureScrollView];
    [self clearSearchResultObjects];
    [self loadSearchResultWithBlock:^(int result) {
        if (result == 0) [self setScrollViewVisible:YES];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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

+ (WTSearchResultTableViewController *)createViewControllerWithSearchKeyword:(NSString *)keyword
                                                              searchCategory:(NSInteger)category
{
    WTSearchResultTableViewController *result = [[WTSearchResultTableViewController alloc] init];
    
    result.searchKeyword = keyword;
    
    result.searchCategory = category;
    
    
    [[NSUserDefaults standardUserDefaults] addSearchHistoryItemWithSearchKeyword:keyword searchCategory:category];
    
    return result;
}

#pragma mark - Load data methods

- (void)clearSearchResultObjects {
    [Object setAllObjectsFreeFromHolder:[self class]];
}

- (void)loadSearchResultWithBlock:(void (^)(int))completion {
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        [self clearSearchResultObjects];
        
        int count = 0;
        
        NSDictionary *resultDict = (NSDictionary *)responseObject;
        NSArray *activityInfoArray = resultDict[@"Activities"];
        count += [activityInfoArray count];
        
        NSMutableArray *acts = [[NSMutableArray alloc] init];
        
        for (NSDictionary *infoDict in activityInfoArray) {
            Activity *activity = [Activity insertActivity:infoDict];
            [activity setObjectHeldByHolder:[self class]];
            [acts addObject:activity];
        }
        self.actsArray = [NSArray arrayWithArray:acts];
        
        NSArray *orgInfoArray = resultDict[@"Accounts"];
        NSMutableArray *orgs = [[NSMutableArray alloc] init];
        count += [orgInfoArray count];
        for (NSDictionary *infoDict in orgInfoArray) {
            Organization *org = [Organization insertOrganization:infoDict];
            [org setObjectHeldByHolder:[self class]];
            [orgs addObject:org];
        }
        self.orgsArray = [NSArray arrayWithArray:orgs];
        
        NSArray *userArray = resultDict[@"Users"];
        NSMutableArray *users = [[NSMutableArray alloc] init];
        count += [userArray count];
        for (NSDictionary *infoDict in userArray) {
            User *user = [User insertUser:infoDict];
            [user setObjectHeldByHolder:[self class]];
            [users addObject:user];
        }
        self.usersArray = [NSArray arrayWithArray:users];
        
        if (completion) {
            completion(count);
        }
        
    } failureBlock:^(NSError *error) {
    }];
    [request getSearchResultInCategory:self.searchCategory keyword:self.searchKeyword];
    [[WTClient sharedClient] enqueueRequest:request];
}

#pragma mark - UI methods

#pragma mark - Actions

- (void)didClickBackButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - CoreDataTableViewController methods

- (void)configureFetchRequest:(NSFetchRequest *)request {
    [request setEntity:[NSEntityDescription entityForName:@"Object" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext]];
    NSSortDescriptor *updatedAtDescriptor = [[NSSortDescriptor alloc] initWithKey:@"objectClass" ascending:NO];
    
    [request setSortDescriptors:@[updatedAtDescriptor]];
    
    
    [request setPredicate:[NSPredicate predicateWithFormat:@"SELF in %@", [Controller controllerModelForClass:[self class]].hasObjects]];
}

- (NSString *)customSectionNameKeyPath {
    return @"objectClass";
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *sectionName = NSLocalizedString([self.fetchedResultsController.sections[section] name], nil);    
    NSInteger count = [self.fetchedResultsController.sections[section] numberOfObjects];
    
    WESearchResultHeaderView *headerView = [WESearchResultHeaderView createSearchResultHeaderViewWithName:[NSString stringWithFormat:@"%@(%d)", sectionName, count]];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *vc = [super detailViewControllerForIndexPath:indexPath];
    if (vc)
        [self.delegate wantToPushViewController:vc];
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
