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
        
    [self clearSearchResultObjects];
    
    [self loadSearchResult];
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

- (void)loadSearchResult {
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        [self clearSearchResultObjects];
        
        NSDictionary *resultDict = (NSDictionary *)responseObject;
        NSArray *activityInfoArray = resultDict[@"Activities"];
        for (NSDictionary *infoDict in activityInfoArray) {
            Activity *activity = [Activity insertActivity:infoDict];
            [activity setObjectHeldByHolder:[self class]];
        }
        
        NSArray *newsInfoArray = resultDict[@"Information"];
        for (NSDictionary *infoDict in newsInfoArray) {
            News *news = [News insertNews:infoDict];
            [news setObjectHeldByHolder:[self class]];
        }
        
        NSArray *starInfoArray = resultDict[@"Person"];
        for (NSDictionary *infoDict in starInfoArray) {
            Star *star = [Star insertStar:infoDict];
            [star setObjectHeldByHolder:[self class]];
        }
        
        NSArray *orgInfoArray = resultDict[@"Accounts"];
        for (NSDictionary *infoDict in orgInfoArray) {
            Organization *org = [Organization insertOrganization:infoDict];
            [org setObjectHeldByHolder:[self class]];
        }
        
        NSArray *userArray = resultDict[@"Users"];
        for (NSDictionary *infoDict in userArray) {
            User *user = [User insertUser:infoDict];
            [user setObjectHeldByHolder:[self class]];
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

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WTTableViewSectionBg"]];
//    CGFloat sectionHeaderHeight = 24.0f;
//    
//    NSString *sectionName = NSLocalizedString([self.fetchedResultsController.sections[section] name], nil);
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0, tableView.bounds.size.width, sectionHeaderHeight)];
//    label.text = sectionName;
//    label.font = [UIFont boldSystemFontOfSize:12.0f];
//    label.textColor = WTSectionHeaderViewGrayColor;
//    label.backgroundColor = [UIColor clearColor];
//    
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, sectionHeaderHeight)];
//    [headerView addSubview:bgImageView];
//    [headerView addSubview:label];
//    
//    return headerView;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *vc = [super detailViewControllerForIndexPath:indexPath];
    if (vc)
        [self.delegate wantToPushViewController:vc];
}

@end
