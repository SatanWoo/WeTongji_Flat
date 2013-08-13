//
//  WEActivitiesViewController.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-12.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WEActivitiesViewController.h"
#import "UIBarButtonItem+Addition.h"
#import "Object+Addition.h"
#import "WEActivityCell.h"
#import "Controller+Addition.h"
#import "WTClient.h"
#import "WEActivitySettingViewController.h"

@interface WEActivitiesViewController () <WEActivitySettingViewControllerDelegate>
@property (nonatomic, assign) ActivityShowTypes type;
@property (nonatomic, assign) NSInteger nextPage;
@property (nonatomic, strong) WEActivitySettingViewController *settingViewController;
@end

@implementation WEActivitiesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (id)initWithTitle:(ActivityShowTypes)type
{
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.nextPage = 1;
    [self loadMoreDataWithSuccessBlock:^{
    } failureBlock:^{
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self configureTableView];
}

#pragma mark - Override

- (void)configureLoadedActivity:(Activity *)activity {
    [activity setObjectHeldByHolder:[self class]];
}

- (void)configureLoadDataRequest:(WTRequest *)request {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [request getActivitiesInTypes:[NSUserDefaults getActivityShowTypesArray]
                      orderMethod:[userDefaults getActivityOrderMethod]
                       smartOrder:[userDefaults getActivitySmartOrderProperty]
                       showExpire:YES
                             page:self.nextPage];
}

- (void)clearOutdatedData {
    NSSet *activityShowTypesSet = [NSUserDefaults getActivityShowTypesSet];
    for (NSNumber *showTypeNumber in activityShowTypesSet) {
        [Activity setOutdatedActivitesFreeFromHolder:[self class] inCategory:showTypeNumber];
    }
}

#pragma mark - UI Method
- (void)configureNavigationBarTitle
{
    //    if (self.type == ActivityShowTypesAll) {
    //        self.title = NSLocalizedString(@"Activities", nil);
    //    } else if (self.type == ActivityShowTypeAcademics) {
    //        self.title = NSLocalizedString(@"Academics", nil);
    //    } else if (self.type == ActivityShowTypeCompetition) {
    //        self.title = NSLocalizedString(@"Competition", nil);
    //    } else if (self.type == ActivityShowTypeEnterprise) {
    //        self.title = NSLocalizedString(@"Enterprise", nil);
    //    } else {
    //        self.title = NSLocalizedString(@"Entertainment", nil);
    //    }
    
    NSSet *activityShowTypesSet = [NSUserDefaults getActivityShowTypesSet];
    if (activityShowTypesSet.count == 1) {
        self.title = [Activity convertCategoryStringFromCategory:activityShowTypesSet.anyObject];
    } else {
        self.title = NSLocalizedString(@"Activities", nil);
    }
}

- (void)configureNavigationBar
{
    [self configureNavigationBarTitle];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    [self configureNavigationBarButton];
}

- (void)configureNavigationBarButton
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc ] initBarButtonWithTarget:self action:@selector(didClickShowSettingView) normalImage:@"event_filter_btn"];
}

- (void)didClickShowSettingView
{
    if (self.settingViewController) return;
    
    self.settingViewController = [[WEActivitySettingViewController alloc] init];
    self.settingViewController.delegate = self;
    [self.view addSubview:self.settingViewController.view];
}

- (void)configureTableView {
    self.tableView.alwaysBounceVertical = YES;
    self.tableView.scrollsToTop = NO;
}

#pragma mark - Data load methods

- (void)loadMoreDataWithSuccessBlock:(void (^)(void))success
                        failureBlock:(void (^)(void))failure {
    WTRequest * request = [WTRequest requestWithSuccessBlock:^(id responseData) {
        NSDictionary *resultDict = (NSDictionary *)responseData;
        NSString *nextPage = resultDict[@"NextPager"];
        self.nextPage = nextPage.integerValue;
        
        NSArray *resultArray = resultDict[@"Activities"];
        for (NSDictionary *dict in resultArray) {
            Activity *activity = [Activity insertActivity:dict];
            [self configureLoadedActivity:activity];
        }
        
        if (success)
            success();
        
    } failureBlock:^(NSError * error) {
        
        if (failure)
            failure();
        
    }];
    [self configureLoadDataRequest:request];
    [[WTClient sharedClient] enqueueRequest:request];
}


#pragma mark - CoreDataTableViewController methods

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    WEActivityCell *activityCell = (WEActivityCell *)cell;
    
    Activity *activity = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [activityCell configureCellWithActivity:activity];
}

- (void)configureFetchRequest:(NSFetchRequest *)request {
    [request setEntity:[NSEntityDescription entityForName:@"Activity" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext]];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    ActivityOrderMethod orderMethod = [userDefaults getActivityOrderMethod];
    BOOL smartOrder = [userDefaults getActivitySmartOrderProperty];
    BOOL showExpire = YES;
    BOOL orderByAsc = ![WTRequest shouldActivityOrderByDesc:orderMethod smartOrder:smartOrder showExpire:showExpire];
    NSArray *descriptors = nil;
    NSSortDescriptor *updateTimeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"updatedAt" ascending:YES];
    
    switch (orderMethod) {
        case ActivityOrderByPublishDate:
        {
            descriptors = [NSArray arrayWithObjects:[[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:orderByAsc], updateTimeDescriptor, nil];
        }
            break;
        case ActivityOrderByPopularity:
        {
            descriptors = [NSArray arrayWithObjects:[[NSSortDescriptor alloc] initWithKey:@"likeCount" ascending:orderByAsc], updateTimeDescriptor, nil];
        }
            break;
        case ActivityOrderByStartDate:
        {
            descriptors = [NSArray arrayWithObjects:[[NSSortDescriptor alloc] initWithKey:@"beginTime" ascending:orderByAsc], updateTimeDescriptor, nil];
        }
            break;
        default:
            break;
    }
    
    [request setSortDescriptors:descriptors];
    
    [request setPredicate:[NSPredicate predicateWithFormat:@"(category in %@) AND (SELF in %@)", [NSUserDefaults getActivityShowTypesSet], [Controller controllerModelForClass:[self class]].hasObjects]];
}

- (NSString *)customCellClassNameAtIndexPath:(NSIndexPath *)indexPath {
    return @"WEActivityCell";
}

- (NSString *)customSectionNameKeyPath {
    return nil;
}

#pragma mark - WEActivitySettingViewControllerDelegate
- (void)didClickFinshSetting
{
    [self.settingViewController.view removeFromSuperview];
    self.settingViewController = nil;
    [self configureNavigationBarTitle];
    [self.tableView reloadData];
}

@end
