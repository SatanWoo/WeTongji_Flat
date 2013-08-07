//
//  WTShareEventFriendsViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-6-21.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTShareEventFriendsViewController.h"
#import "WTDragToLoadDecorator.h"
#import "WTResourceFactory.h"
#import "Activity+Addition.h"
#import "Course+Addition.h"
#import "User+Addition.h"
#import "NSString+WTAddition.h"
#import <WeTongjiSDK/WeTongjiSDK.h>
#import "WTUserCell.h"
#import "WTUserDetailViewController.h"

@interface WTShareEventFriendsViewController () <WTDragToLoadDecoratorDelegate, WTDragToLoadDecoratorDataSource>

@property (nonatomic, strong) WTDragToLoadDecorator *dragToLoadDecorator;

@property (nonatomic, weak) Object *object;

@end

@implementation WTShareEventFriendsViewController

+ (WTShareEventFriendsViewController *)createViewControllerWithTargetObject:(Object *)object {
    if (![object isKindOfClass:[Event class]] && ![object isKindOfClass:[Course class]]) {
        return nil;
    }
    
    WTShareEventFriendsViewController *result = [[WTShareEventFriendsViewController alloc] init];
    
    result.object = object;
    
    return result;
}

- (void)viewDidLoad {
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

- (void)viewDidDisappear:(BOOL)animated {
    [self.dragToLoadDecorator stopObservingChangesInDragToLoadScrollView];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark - Data load methods

- (void)loadDataWithSuccessBlock:(void (^)(void))success
                    failureBlock:(void (^)(void))failure {
    WTRequest * request = [WTRequest requestWithSuccessBlock:^(id responseData) {
        WTLOG(@"Get friends: %@", responseData);
        
        if (success)
            success();
        
        NSDictionary *resultDict = (NSDictionary *)responseData;
        NSArray *friendsArray = resultDict[@"Users"];
        for (NSDictionary *infoDict in friendsArray) {
            User *friend = [User insertUser:infoDict];
            if ([self.object isKindOfClass:[Event class]]) {
                Event *event = (Event *)self.object;
                [event addScheduledByObject:friend];
            } else if ([self.object isKindOfClass:[Course class]]) {
                Course *course = (Course *)self.object;
                [course addRegisteredByObject:friend];
            }
            
            [[WTCoreDataManager sharedManager].currentUser addFriendsObject:friend];
        }
        
    } failureBlock:^(NSError * error) {
        WTLOGERROR(@"Get friends:%@", error.localizedDescription);
        
        if (failure)
            failure();
        
        [WTErrorHandler handleError:error];
    }];
    if ([self.object isKindOfClass:[Activity class]]) {
        [request getFriendsWithSameActivity:self.object.identifier];
    } else if ([self.object isKindOfClass:[CourseInstance class]]) {
        CourseInstance *courseInstance = (CourseInstance *)self.object;
        [request getFriendsWithSameCourse:courseInstance.course.identifier];
    } else if ([self.object isKindOfClass:[Course class]]) {
        [request getFriendsWithSameCourse:self.object.identifier];
    }
    [[WTClient sharedClient] enqueueRequest:request];
}

- (void)clearAllData {
    if ([self.object isKindOfClass:[Event class]]) {
        Event *event = (Event *)self.object;
        BOOL currentUserScheduledThisEvent = event.scheduledByCurrentUser;
        [event removeScheduledBy:event.scheduledBy];
        if (currentUserScheduledThisEvent)
            event.scheduledByCurrentUser = YES;
    } else if ([self.object isKindOfClass:[Course class]]) {
        Course *course = (Course *)self.object;
        BOOL currentUserRegisteredThisCourse = course.registeredByCurrentUser;
        [course removeRegisteredBy:course.registeredBy];
        if (currentUserRegisteredThisCourse)
            course.registeredByCurrentUser = YES;
    }
}

#pragma mark - Logic methods

- (NSString *)targetObjectTitle {
    NSString *titleString = nil;
    if ([self.object isKindOfClass:[Event class]]) {
        Event *event = (Event *)self.object;
        titleString = event.what;
    } else if ([self.object isKindOfClass:[Course class]]) {
        Course *course = (Course *)self.object;
        titleString = course.courseName;
    }
    return titleString;
}

- (NSNumber *)targetObjectFriendsCount {
    NSNumber *friendsCount = nil;
    if ([self.object isKindOfClass:[Event class]]) {
        Event *event = (Event *)self.object;
        friendsCount = event.friendsCount;
    } else if ([self.object isKindOfClass:[Course class]]) {
        Course *course = (Course *)self.object;
        friendsCount = course.friendsCount;
    }
    return friendsCount;
}

#pragma mark - UI methods

- (void)configureNavigationBar {
    
    self.navigationItem.titleView = [WTResourceFactory createNavigationBarTitleViewWithText:[NSString friendCountStringConvertFromCountNumber:[self targetObjectFriendsCount]]];
    
    self.navigationItem.leftBarButtonItem = [WTResourceFactory createBackBarButtonWithText:[self targetObjectTitle] target:self action:@selector(didClickBackButton:)];
}

- (void)configureTableView {
    self.tableView.alwaysBounceVertical = YES;
    
    self.tableView.scrollsToTop = NO;
}

- (void)configureDragToLoadDecorator {
    self.dragToLoadDecorator = [WTDragToLoadDecorator createDecoratorWithDataSource:self delegate:self bottomActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [self.dragToLoadDecorator setBottomViewDisabled:YES immediately:YES];
}

#pragma mark - Actions

- (void)didClickBackButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - CoreDataTableViewController methods

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    WTUserCell *userCell = (WTUserCell *)cell;
    User *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [userCell configureCellWithIndexPath:indexPath user:user];
}

- (void)configureFetchRequest:(NSFetchRequest *)request {
    [request setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext]];
    
    NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    
    [request setSortDescriptors:@[nameDescriptor]];
    
    if ([self.object isKindOfClass:[Event class]]) {
        Event *event = (Event *)self.object;
        [request setPredicate:[NSPredicate predicateWithFormat:@"SELF in %@ AND SELF != %@", event.scheduledBy, [WTCoreDataManager sharedManager].currentUser]];
    } else if ([self.object isKindOfClass:[Course class]]) {
        Course *course = (Course *)self.object;
        [request setPredicate:[NSPredicate predicateWithFormat:@"SELF in %@ AND SELF != %@", course.registeredBy, [WTCoreDataManager sharedManager].currentUser]];
    }    
}

- (NSString *)customCellClassNameAtIndexPath:(NSIndexPath *)indexPath {
    return @"WTUserCell";
}

- (void)fetchedResultsControllerDidPerformFetch {
    if ([self.fetchedResultsController.sections.lastObject numberOfObjects] == 0) {
        [self.dragToLoadDecorator setTopViewLoading:YES];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    User *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    WTUserDetailViewController *vc = [WTUserDetailViewController createDetailViewControllerWithUser:user backBarButtonText:[NSString friendCountStringConvertFromCountNumber:[self targetObjectFriendsCount]]];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - WTDragToLoadDecoratorDataSource

- (UIScrollView *)dragToLoadScrollView {
    return self.tableView;
}

#pragma mark - WTDragToLoadDecoratorDelegate

- (void)dragToLoadDecoratorDidDragDown {
    [self loadDataWithSuccessBlock:^{
        [self clearAllData];
        [self.dragToLoadDecorator topViewLoadFinished:YES];
    } failureBlock:^{
        [self.dragToLoadDecorator topViewLoadFinished:NO];
    }];
}

@end
