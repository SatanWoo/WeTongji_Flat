//
//  WTScheduledCourseViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-6-21.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTScheduledCourseViewController.h"
#import "WTDragToLoadDecorator.h"
#import "User+Addition.h"
#import "Course+Addition.h"
#import <WeTongjiSDK/WeTongjiSDK.h>
#import "WTCourseCell.h"
#import "WTResourceFactory.h"
#import "NSString+WTAddition.h"
#import "NSUserDefaults+WTAddition.h"
#import "WTCourseDetailViewController.h"
#import "WTNowConfigLoader.h"

@interface WTScheduledCourseViewController () <WTDragToLoadDecoratorDelegate, WTDragToLoadDecoratorDataSource>

@property (nonatomic, strong) WTDragToLoadDecorator *dragToLoadDecorator;

@property (nonatomic, strong) User *user;

@end

@implementation WTScheduledCourseViewController

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
    
    [self configureTableView];
    
    [self configureDragToLoadDecorator];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WTRootBgUnit"]];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.dragToLoadDecorator startObservingChangesInDragToLoadScrollView];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.dragToLoadDecorator stopObservingChangesInDragToLoadScrollView];
}

+ (WTScheduledCourseViewController *)createViewControllerWithUser:(User *)user {
    WTScheduledCourseViewController *result = [[WTScheduledCourseViewController alloc] init];
    
    result.user = user;
    
    return result;
}

#pragma mark - Load data methods

- (void)clearData {
    [self.user removeRegisteredCourses:self.user.registeredCourses];
}

- (void)loadMoreDataWithSuccessBlock:(void (^)(void))success
                        failureBlock:(void (^)(void))failure {
    WTRequest * request = [WTRequest requestWithSuccessBlock:^(id responseData) {
        WTLOG(@"Get Courses: %@", responseData);
        
        if (success)
            success();
        
        NSDictionary *responseDict = (NSDictionary *)responseData;
        NSArray *courseInfoArray = responseDict[@"Courses"];
        for (NSDictionary *courseInfo in courseInfoArray) {
            Course *course = [Course insertCourse:courseInfo];
            [self.user addRegisteredCoursesObject:course];
        }
        
    } failureBlock:^(NSError * error) {
        WTLOGERROR(@"Get Courses:%@", error.localizedDescription);
        
        if (failure)
            failure();
        
        [WTErrorHandler handleError:error];
    }];
    
    // TODO:!!!!!
    // 服务器貌似没有考虑begin和end参数？
    NSDate *semesterBeginTime = [WTNowConfigLoader sharedLoader].baseStartDate;
    NSInteger semesterWeekCount = [WTNowConfigLoader sharedLoader].numberOfWeeks;
    BOOL isCurrentUser = [WTCoreDataManager sharedManager].currentUser == self.user;
    [request getCoursesRegisteredByUser:isCurrentUser ? nil : self.user.identifier
                              beginDate:semesterBeginTime
                                endDate:[NSDate dateWithTimeInterval:semesterWeekCount * WEEK_TIME_INTERVAL
                                                           sinceDate:semesterBeginTime]];
    
    [[WTClient sharedClient] enqueueRequest:request];
}
#pragma mark - UI methods

- (void)configureDragToLoadDecorator {
    self.dragToLoadDecorator = [WTDragToLoadDecorator createDecoratorWithDataSource:self delegate:self bottomActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [self.dragToLoadDecorator setBottomViewDisabled:YES immediately:YES];
}

- (void)configureNavigationBar {
    self.navigationItem.titleView = [WTResourceFactory createNavigationBarTitleViewWithText:NSLocalizedString(@"Courses", nil)];
    self.navigationItem.leftBarButtonItem = [WTResourceFactory createBackBarButtonWithText:self.user.name target:self action:@selector(didClickBackButton:)];
}

- (void)configureTableView {
    self.tableView.alwaysBounceVertical = YES;
    
    self.tableView.scrollsToTop = NO;
    
    _noAnimationFlag = YES;
}

#pragma mark - Actions

- (void)didClickBackButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - CoreDataTableViewController methods

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    WTCourseCell *courseCell = (WTCourseCell *)cell;
    
    Course *course = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [courseCell configureCellWithIndexPath:indexPath course:course];
}

- (void)configureFetchRequest:(NSFetchRequest *)request {
    [request setEntity:[NSEntityDescription entityForName:@"Course" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext]];
    
    NSSortDescriptor *yearDescriptor = [[NSSortDescriptor alloc] initWithKey:@"year" ascending:NO];
    NSSortDescriptor *semesterDescriptor = [[NSSortDescriptor alloc] initWithKey:@"semester" ascending:NO];
    NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"courseName" ascending:YES];
    
    [request setSortDescriptors:@[yearDescriptor, semesterDescriptor, nameDescriptor]];
    
    [request setPredicate:[NSPredicate predicateWithFormat:@"SELF in %@", self.user.registeredCourses]];
}

- (NSString *)customCellClassNameAtIndexPath:(NSIndexPath *)indexPath {
    return @"WTCourseCell";
}

- (NSString *)customSectionNameKeyPath {
    return @"yearSemesterString";
}

- (void)fetchedResultsControllerDidPerformFetch {
    if ([self.fetchedResultsController.sections.lastObject numberOfObjects] == 0) {
        [self.dragToLoadDecorator setTopViewLoading:YES];
    }
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WTTableViewSectionBg"]];
    CGFloat sectionHeaderHeight = bgImageView.frame.size.height;
    
    NSString *sectionName = [self.fetchedResultsController.sections[section] name];
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
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:YES animated:YES];
    
    Course *course = [self.fetchedResultsController objectAtIndexPath:indexPath];
    WTCourseDetailViewController *vc = [WTCourseDetailViewController createDetailViewControllerWithCourse:course backBarButtonText:NSLocalizedString(@"Courses", nil)];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - WTDragToLoadDecoratorDataSource

- (UIScrollView *)dragToLoadScrollView {
    return self.tableView;
}

#pragma mark - WTDragToLoadDecoratorDelegate

- (void)dragToLoadDecoratorDidDragDown {
    [self loadMoreDataWithSuccessBlock:^{
        [self clearData];
        [self.dragToLoadDecorator topViewLoadFinished:YES];
    } failureBlock:^{
        [self.dragToLoadDecorator topViewLoadFinished:NO];
    }];
}

@end
