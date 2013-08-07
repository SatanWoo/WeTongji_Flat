//
//  WTNowViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-1-2.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTNowViewController.h"
#import "WTResourceFactory.h"
#import "WTCoreDataManager.h"
#import "NSNotificationCenter+WTAddition.h"
#import "WTNowBarTitleView.h"
#import "WTNowWeekCell.h"
#import "NSString+WTAddition.h"
#import "Activity.h"
#import "CourseInstance.h"
#import "WTActivityDetailViewController.h"
#import "WTCourseInstanceDetailViewController.h"
#import "WTNowConfigLoader.h"
#import "NSString+WTAddition.h"

@interface WTNowViewController () <WTNowBarTitleViewDelegate>

@property (nonatomic, strong) NSIndexPath *nowIndexPath;
@property (nonatomic, strong) WTNowBarTitleView *barTitleView;

@property (nonatomic, assign) BOOL shouldScrollToNow;

@end

@implementation WTNowViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureNavigationBar];
    [self configureTableView];
    [self configureBarTitleView];
    
    [NSNotificationCenter registerCurrentUserDidChangeNotificationWithSelector:@selector(handleCurrentUserDidChangeNotification:)
                                                                        target:self];
    
    self.shouldScrollToNow = YES;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.tableView.scrollEnabled = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.shouldScrollToNow) {
        self.shouldScrollToNow = NO;
        [self scrollToNow:NO];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    if (self.tableView.visibleCells.count == 0)
        return;
    WTNowWeekCell *visibleCell = (WTNowWeekCell *)self.tableView.visibleCells[0];
    [visibleCell cellDidAppear];
}

#pragma mark - Public methods

- (void)showNowItemDetailViewWithEvent:(Event *)event {
    if ([event isKindOfClass:[Activity class]]) {
        WTActivityDetailViewController *vc = [WTActivityDetailViewController createDetailViewControllerWithActivity:(Activity *)event backBarButtonText:NSLocalizedString(@"Schedule", nil)];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([event isKindOfClass:[CourseInstance class]]) {
        WTCourseInstanceDetailViewController *vc = [WTCourseInstanceDetailViewController createDetailViewControllerWithCourseInstance:(CourseInstance *)event backBarButtonText:NSLocalizedString(@"Schedule", nil)];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Properties

- (WTNowBarTitleView *)barTitleView {
    if (!_barTitleView) {
        _barTitleView = [WTNowBarTitleView createBarTitleViewWithDelegate:self];
    }
    return _barTitleView;
}

#pragma mark - Notification handler

- (void)handleCurrentUserDidChangeNotification:(NSNotification *)notification {
    [self.tableView reloadData];
    
    if ([WTCoreDataManager sharedManager].currentUser) {
        self.shouldScrollToNow = YES;
    }
    
    [self configureBarTitleView];
}

#pragma mark - Logic methods

//- (void)updateScheduleSetting {
//    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSDate *semesterBeginTime = [defaults getCurrentSemesterBeginTime];
//    if (semesterBeginTime) {
//        NSDate *semesterEndTime = [NSDate dateWithTimeInterval:[defaults getCurrentSemesterWeekCount] sinceDate:semesterBeginTime];
//        if ([semesterEndTime compare:[NSDate date]] == NSOrderedDescending)
//            return;
//    }
//    
//    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
//        WTLOG(@"Get schedule setting:%@", responseObject);
//        
//        NSDictionary *responseDict = (NSDictionary *)responseObject;
//        //    SchoolYearCourseWeekCount = 17;
//        //    SchoolYearStartAt = "2013-02-25T00:00:00+08:00";
//        //    SchoolYearWeekCount = 19;
//        
//        NSString *schoolYearStartAtString = [NSString stringWithFormat:@"%@", responseDict[@"SchoolYearStartAt"]];
//        NSDate *schoolYearStartAtDate = [schoolYearStartAtString convertToDate];
//        NSInteger schoolYearWeekCount = [[NSString stringWithFormat:@"%@", responseDict[@"SchoolYearWeekCount"]] integerValue];
//        
//        [defaults setCurrentSemesterBeginTime:schoolYearStartAtDate];
//        [defaults setCurrentSemesterWeekCount:schoolYearWeekCount];
//        
//        [self.tableView reloadData];
//    } failureBlock:^(NSError *error) {
//        WTLOGERROR(@"Get shedule setting failure:%@", error.localizedDescription);
//    }];
//    
//    [request getScheduleSetting];
//    [[WTClient sharedClient] enqueueRequest:request];
//}

- (NSInteger)todayWeekNumber {
    WTNowConfigLoader *configLoader = [WTNowConfigLoader sharedLoader];
    
    NSDate *beginTime = configLoader.baseStartDate;
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:beginTime];
    NSInteger todayWeekNumber = interval / WEEK_TIME_INTERVAL + 1;
    if (todayWeekNumber > configLoader.numberOfWeeks) {
        todayWeekNumber = configLoader.numberOfWeeks;
    }
    return todayWeekNumber;
}

#pragma mark - UI methods

- (void)configureBarTitleView {
    if ([WTCoreDataManager sharedManager].currentUser) {
        self.barTitleView.alpha = 1.0f;
        self.barTitleView.userInteractionEnabled = YES;
    } else {        
        self.barTitleView.alpha = 0.5f;
        self.barTitleView.userInteractionEnabled = NO;
    }
}

- (void)configureTableView {
    CGRect frame = self.tableView.frame;
    self.tableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    self.tableView.frame = frame;    
}

- (void)configureCell:(WTNowWeekCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"index row:%d", indexPath.row);
    
    [cell resetWidth:self.view.frame.size.height];
    [cell configureCellWithWeekNumber:indexPath.row + 1];
}

- (void)configureNavigationBar {
    self.navigationItem.titleView = self.barTitleView;
        
    self.navigationItem.leftBarButtonItem = self.notificationButton;
    
    self.navigationItem.rightBarButtonItem = [WTResourceFactory createNormalBarButtonWithText:NSLocalizedString(@"Now", nil)
                                                                                       target:self
                                                                                       action:@selector(didClickNowButton:)];
}

- (void)updateTableView {
    NSUInteger index = self.tableView.contentOffset.y / self.tableView.frame.size.width;
    self.barTitleView.weekNumber = index + 1;
    
    if ([self todayWeekNumber] == self.barTitleView.weekNumber) {
        [self scrollToNow:YES];
    }
}

- (void)scrollToNow:(BOOL)animated {
    if (![WTCoreDataManager sharedManager].currentUser) {
        return;
    }
    
    NSInteger todayWeekNumber = [self todayWeekNumber];
    NSInteger numberOfRows = [self tableView:self.tableView numberOfRowsInSection:0];
    if (numberOfRows < todayWeekNumber || todayWeekNumber <= 0)
        return;
    
    NSIndexPath *targetIndexPath = [NSIndexPath indexPathForRow:todayWeekNumber - 1 inSection:0];
    
    BOOL weekTableViewScrollAnimated = abs(todayWeekNumber - self.barTitleView.weekNumber) < 2 && todayWeekNumber != self.barTitleView.weekNumber;
    weekTableViewScrollAnimated = weekTableViewScrollAnimated && animated;
    
    [self.tableView scrollToRowAtIndexPath:targetIndexPath atScrollPosition:UITableViewScrollPositionTop animated:weekTableViewScrollAnimated];
    
    int64_t delay = weekTableViewScrollAnimated ? 300 * NSEC_PER_MSEC : 0;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay), dispatch_get_current_queue(), ^{
        self.barTitleView.weekNumber = todayWeekNumber;
        WTNowWeekCell *weekCell = (WTNowWeekCell *)[self.tableView cellForRowAtIndexPath:targetIndexPath];
        [weekCell scrollToNow:animated];
    });
}

#pragma mark - Actions

- (void)didClickNowButton:(UIButton *)sender {
    [self scrollToNow:YES];
}

#pragma mark - WTNowBarTitleViewDelegate

- (void)nowBarTitleViewWeekNumberDidChange:(WTNowBarTitleView *)titleView {
    if (![WTCoreDataManager sharedManager].currentUser)
        return;
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:titleView.weekNumber - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([WTCoreDataManager sharedManager].currentUser) {
        NSInteger weekCount = [WTNowConfigLoader sharedLoader].numberOfWeeks;
        return weekCount;
    } else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *name = @"WTNowWeekCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:name];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:name owner:self options:nil] lastObject];
    }
    [self configureCell:(WTNowWeekCell *)cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self updateTableView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self updateTableView];
    }
}

#pragma mark - WTRootNavigationControllerDelegate

- (UIScrollView *)sourceScrollView {
    NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:self.barTitleView.weekNumber - 1 inSection:0];
    
    WTNowWeekCell *weekCell = (WTNowWeekCell *)[self.tableView cellForRowAtIndexPath:currentIndexPath];
    
    return weekCell.tableViewController.tableView;
}

@end
