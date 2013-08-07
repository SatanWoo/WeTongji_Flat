//
//  WTNowTableViewController.m
//  WeTongji
//
//  Created by 吴 wuziqi on 13-3-6.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTNowTableViewController.h"
#import "Exam+Addition.h"
#import "Course+Addition.h"
#import "Activity+Addition.h"
#import "Controller+Addition.h"
#import "WTNowConfigLoader.h"
#import "WTNowActivityCell.h"
#import "WTNowCourseCell.h"
#import "Event+Addition.h"
#import "Object+Addition.h"
#import "NSNotificationCenter+WTAddition.h"
#import "WTDragToLoadDecorator.h"
#import "WTNowViewController.h"
#import "UIApplication+WTAddition.h"
#import "NSString+WTAddition.h"

@interface WTNowTableViewController () <WTDragToLoadDecoratorDelegate, WTDragToLoadDecoratorDataSource>

@property (nonatomic, strong) WTDragToLoadDecorator *dragToLoadDecorator;

@end

@implementation WTNowTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureTableView];
    [self configureDragToLoadDecorator];
}

- (void)viewWillAppear:(BOOL)animated {
    self.view.frame = self.targetFrame;
}

- (void)viewDidAppear:(BOOL)animated {
    [self.dragToLoadDecorator startObservingChangesInDragToLoadScrollView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.dragToLoadDecorator stopObservingChangesInDragToLoadScrollView];
}

#pragma mark - Public methods

- (void)scrollToNow:(BOOL)animated {
    Event *nowEvent = [self getNowEvent];
    if (nowEvent) {
        NSIndexPath *indexPath = [self.fetchedResultsController indexPathForObject:nowEvent];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:animated];
    }
}

- (void)updateTableViewController {
    [self viewDidAppear:YES];
}

#pragma mark - Properties

- (void)setWeekNumber:(NSUInteger)weekNumber {
    _weekNumber = weekNumber;
    self.fetchedResultsController = nil;
    [self.tableView reloadData];
}

#pragma mark - Logic Method

- (NSDate *)convertWeekNumberToDate:(NSUInteger)weekNumber {
    return [[WTNowConfigLoader sharedLoader].baseStartDate dateByAddingTimeInterval:weekNumber * WEEK_TIME_INTERVAL];
}

- (Event *)getNowEvent {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Event"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"(SELF in %@) AND (endTime >= %@)", [WTCoreDataManager sharedManager].currentUser.scheduledEvents, [NSDate date]];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"beginTime" ascending:YES]];
    
    NSArray *matches = [[WTCoreDataManager sharedManager].managedObjectContext executeFetchRequest:request error:nil];
    if ([matches count] == 0) {
        return nil;
    } else {
        return [matches objectAtIndex:0];
    }
}

- (void)loadDataFrom:(NSDate *)fromDate
                  to:(NSDate *)toDate
        successBlock:(void (^)(void))success
        failureBlock:(void (^)(void))failure {
    WTRequest * request = [WTRequest requestWithSuccessBlock:^(id responseData) {
        WTLOG(@"Get Now Data Success: %@", responseData);
        
        if (success) {
            success();
        }
                
        NSDictionary *resultDict = (NSDictionary *)responseData;
        NSArray *activitiesArray = resultDict[@"Activities"];
        for (NSDictionary *dict in activitiesArray) {
            Activity *activity= [Activity insertActivity:dict];
            [activity setObjectHeldByHolder:[self class]];
        }
        
        NSArray *coursesArray = resultDict[@"CourseInstances"];
        for (NSDictionary *dict in coursesArray) {
            CourseInstance *courseInstance = [CourseInstance insertCourseInstance:dict];
            [courseInstance setObjectHeldByHolder:[self class]];
            courseInstance.scheduledByCurrentUser = YES;
        }
        
        NSArray *examsArray = resultDict[@"Exams"];
        for (NSDictionary *dict in examsArray) {
            Exam *exam = [Exam insertExam:dict];
            [exam setObjectHeldByHolder:[self class]];
            exam.scheduledByCurrentUser = YES;
        }
    } failureBlock:^(NSError * error) {
        WTLOGERROR(@"Get NowData Error:%@", error.localizedDescription);
        if (failure) {
            failure();
        }
        [WTErrorHandler handleError:error];
    }];    
    [request getScheduleWithBeginDate:fromDate endDate:toDate];
    [[WTClient sharedClient] enqueueRequest:request];
}

#pragma mark - UI methods

- (void)configureDragToLoadDecorator {
    self.dragToLoadDecorator = [WTDragToLoadDecorator createDecoratorWithDataSource:self delegate:self bottomActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.dragToLoadDecorator setBottomViewDisabled:YES immediately:YES];
}

- (void)configureTableView {
    self.tableView.alwaysBounceVertical = YES;
    self.tableView.scrollsToTop = NO;
}

- (void)adjustTableViewContentOffset {
    
    if (self.tableView.contentOffset.y == 0) {
        self.tableView.contentOffset = CGPointMake(0, 0.5f);
    } else if (self.tableView.contentOffset.y == self.tableView.contentSize.height - self.tableView.frame.size.height + self.tableView.contentInset.bottom) {
        self.tableView.contentOffset = CGPointMake(0, self.tableView.contentOffset.y - 0.5f);
    }
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIImageView *bgImageView = nil;
    if (section == 0) {
        bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WTTableViewSectionBg"]];
    } else {
        bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WTTableViewTopLineSectionBg"]];
    }
    
    CGFloat sectionHeaderHeight = bgImageView.frame.size.height;
    
    Event *firstEventInSection = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    
    UILabel *weekDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0, tableView.bounds.size.width, sectionHeaderHeight)];
    weekDayLabel.text = [firstEventInSection.beginTime convertToWeekString];
    weekDayLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    if ([firstEventInSection.beginTime isDateInToday])
        weekDayLabel.textColor = WTBlueColor;
    else
        weekDayLabel.textColor = WTSectionHeaderViewGrayColor;
    weekDayLabel.backgroundColor = [UIColor clearColor];
    
    UILabel *yearMonthDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width - 10.0f, sectionHeaderHeight)];
    yearMonthDayLabel.textAlignment = NSTextAlignmentRight;
    yearMonthDayLabel.text = [firstEventInSection.beginTime convertToYearMonthDayString];
    yearMonthDayLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    yearMonthDayLabel.textColor = WTSectionHeaderViewGrayColor;
    yearMonthDayLabel.backgroundColor = [UIColor clearColor];
    
    UIView *headerView = [[UIView alloc] initWithFrame:bgImageView.frame];
    [headerView addSubview:bgImageView];
    [headerView addSubview:weekDayLabel];
    [headerView addSubview:yearMonthDayLabel];
    
    return headerView;
}

#pragma mark - CoreDataTableViewController methods

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Event *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    WTNowBaseCell *nowCell = (WTNowBaseCell *)cell;
    [nowCell configureCellWithEvent:item];
    
    NSDate *nowDate = [NSDate date];
    if ([nowDate compare:item.beginTime] == NSOrderedAscending) {
        [nowCell updateCellStatus:WTNowBaseCellTypeNormal];

    } else if ([nowDate compare:item.endTime] == NSOrderedDescending) {
        [nowCell updateCellStatus:WTNowBaseCellTypePast];
    } else {
        [nowCell updateCellStatus:WTNowBaseCellTypeNow];
    }
}

- (void)configureFetchRequest:(NSFetchRequest *)request {
    [request setEntity:[NSEntityDescription entityForName:@"Event" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext]];

    request.predicate = [NSPredicate predicateWithFormat:@"(SELF in %@) AND (beginTime >= %@) AND (beginTime <= %@) AND (SELF in %@)", [WTCoreDataManager sharedManager].currentUser.scheduledEvents, [self convertWeekNumberToDate:self.weekNumber - 1], [self convertWeekNumberToDate:self.weekNumber], [Controller controllerModelForClass:[self class]].hasObjects];
    
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"beginTime" ascending:YES]];
}

- (NSString *)customCellClassNameAtIndexPath:(NSIndexPath *)indexPath {
    Event *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([item isKindOfClass:[Activity class]]) {
        return @"WTNowActivityCell";
    } else if ([item isKindOfClass:[CourseInstance class]]){
        return @"WTNowCourseCell";
    }
    return nil;
}

- (NSString *)customSectionNameKeyPath {
    return @"beginDay";
}

- (void)fetchedResultsControllerDidPerformFetch {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 300 * NSEC_PER_MSEC), dispatch_get_current_queue(), ^{
        if ([self.fetchedResultsController.sections.lastObject numberOfObjects] == 0) {
            [self.dragToLoadDecorator setTopViewLoading:YES];            
        }
    });
}

#pragma mark - WTDragToLoadDataSource

- (UIScrollView *)dragToLoadScrollView {
    return self.tableView;
}

#pragma mark - WTDragToLoadDelegate

- (void)dragToLoadDecoratorDidDragDown {
    NSDate *fromDate = [self convertWeekNumberToDate:self.weekNumber - 1];
    NSDate *toDate = [self convertWeekNumberToDate:self.weekNumber];
    [self loadDataFrom:fromDate
                    to:toDate
          successBlock:^{
              [Event setCurrentUserScheduledEventsFreeFromHolder:[self class]
                                                        fromDate:fromDate
                                                          toDate:toDate];
              [self.dragToLoadDecorator topViewLoadFinished:YES animationCompletion:^{
                  if (!self.tableView.dragging)
                      [self adjustTableViewContentOffset];
              }];
          } failureBlock:^{
              [self.dragToLoadDecorator topViewLoadFinished:NO animationCompletion:^{
                  if (!self.tableView.dragging)
                      [self adjustTableViewContentOffset];
              }];
          }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self adjustTableViewContentOffset];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self adjustTableViewContentOffset];
    }
}

@end
