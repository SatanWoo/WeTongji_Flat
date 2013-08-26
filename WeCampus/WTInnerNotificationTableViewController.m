//
//  WTInnerNotificationTableViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-3-4.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTInnerNotificationTableViewController.h"
#import "WTNotificationCell.h"
#import "Notification+Addition.h"
#import "WeTongjiSDK.h"
#import "NSString+WTAddition.h"
#import "NSNotificationCenter+WTAddition.h"
#import "Notification+Addition.h"
#import "Object+Addition.h"

#import "WEActivityDetailViewController.h"

@interface WTInnerNotificationTableViewController ()
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, assign) NSInteger nextPage;
@end

@implementation WTInnerNotificationTableViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.nextPage = 2;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.alwaysBounceVertical = YES;
    [self configureRrefreshControl];
    
    self.nextPage = 1;
    [self.refreshControl beginRefreshing];
    [self loadMoreDataWithSuccessBlock:^{
        [self.refreshControl endRefreshing];
    } failureBlock:^{
        [self.refreshControl endRefreshing];
    }];
}

- (void)configureRrefreshControl
{
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    [self.refreshControl resetOriginY:0];
    [self.tableView addSubview:self.refreshControl];
}

#pragma mark - Handle Notifications
- (void)handleCurrentUserDidChangeNotification:(NSNotification *)notification {
    if ([WTCoreDataManager sharedManager].currentUser) {
        self.fetchedResultsController = nil;
        [self.tableView reloadData];
    }
}

#pragma mark - Logic methods

- (void)loadMoreDataWithSuccessBlock:(void (^)(void))success
                        failureBlock:(void (^)(void))failure {
    
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        NSDictionary *resultDict = (NSDictionary *)responseObject;
        NSString *nextPage = resultDict[@"NextPager"];
        self.nextPage = nextPage.integerValue;
        
        if (self.nextPage == 0) {
            
        } else {
            
        }
        
        NSSet *notificationsSet = [Notification insertNotifications:responseObject];
        [[WTCoreDataManager sharedManager].currentUser addOwnedNotifications:notificationsSet];
        
        if (success)
            success();
        
    } failureBlock:^(NSError *error) {
        if (failure)
            failure();
    }];
    [request getNotificationsInPage:self.nextPage];
    [[WTClient sharedClient] enqueueRequest:request];
}

- (void)clearOutdatedData {
    [Notification clearOutdatedNotifications];
}
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Notification *notification = [self.fetchedResultsController objectAtIndexPath:indexPath];
    return [notification cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNotification *notification = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([notification isKindOfClass:[ActivityInvitationNotification class]]) {
        ActivityInvitationNotification *activityInvitation = (ActivityInvitationNotification *)notification;
        WEActivityDetailViewController *vc = [WEActivityDetailViewController createDetailViewControllerWithModel:activityInvitation.activity];
        [self.delegate innerNotificaionTableViewController:self wantToPushViewController:vc];
    }
//    } else if ([notification isKindOfClass:[CourseInvitationNotification class]]) {
//        CourseInvitationNotification *courseInvitation = (CourseInvitationNotification *)notification;
//        WTCourseDetailViewController *vc = [WTCourseDetailViewController createDetailViewControllerWithCourse:courseInvitation.course backBarButtonText:NSLocalizedString(@"Notification", nil)];
//        [self.delegate innerNotificaionTableViewController:self wantToPushViewController:vc];
//    } else if ([notification isKindOfClass:[FriendInvitationNotification class]]) {
//        FriendInvitationNotification *friendInvitation = (FriendInvitationNotification *)notification;
//        // 如果是确认好友邀请的通知，则展示receiver
//        User *user = friendInvitation.sender;
//        if (user == [WTCoreDataManager sharedManager].currentUser) {
//            user = friendInvitation.receiver;
//        }
//        WTUserDetailViewController *vc = [WTUserDetailViewController createDetailViewControllerWithUser:user backBarButtonText:NSLocalizedString(@"Notification", nil)];
//        [self.delegate innerNotificaionTableViewController:self wantToPushViewController:vc];
//    }
}

#pragma mark - CoreDataTableViewController methods
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Notification *notification = [self.fetchedResultsController objectAtIndexPath:indexPath];
    WTNotificationCell *notificationCell = (WTNotificationCell *)cell;
    notificationCell.delegate = self;
    [notificationCell configureUIWithNotificaitonObject:notification];
}

- (void)configureFetchRequest:(NSFetchRequest *)request {
    [request setEntity:[NSEntityDescription entityForName:@"Notification" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext]];
    NSSortDescriptor *sortBySendTime = [[NSSortDescriptor alloc] initWithKey:@"sendTime" ascending:NO];
    [request setSortDescriptors:@[sortBySendTime]];
    
    NSLog(@"wtcoredatamanager is %@",[WTCoreDataManager sharedManager].currentUser);
    
    if ([WTCoreDataManager sharedManager].currentUser) {
        [request setPredicate:[NSPredicate predicateWithFormat:@"SELF in %@", [WTCoreDataManager sharedManager].currentUser.ownedNotifications]];
    }
}

- (NSString *)customCellClassNameAtIndexPath:(NSIndexPath *)indexPath {
    Notification *notification = [self.fetchedResultsController objectAtIndexPath:indexPath];
    return [notification customCellClassName];
}

- (void)insertCellAtIndexPath:(NSIndexPath *)indexPath {
    [super insertCellAtIndexPath:indexPath];
}

//- (void)fetchedResultsControllerDidPerformFetch {
//}

#pragma mark - WTNotificationCellDelegate

- (void)cellHeightDidChange {
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}


#pragma mark - Refresh Control
- (void)loadData
{
    [self loadMoreDataWithSuccessBlock:^{
        [self performSelector:@selector(endRefreshing) withObject:nil afterDelay:2.0f];
        [self.tableView reloadData];
    } failureBlock:^{
        [self.refreshControl endRefreshing];
    }];
}

- (void)refreshData
{
    [self loadData];
}

- (void)endRefreshing
{
    [self.refreshControl endRefreshing];
}

@end
