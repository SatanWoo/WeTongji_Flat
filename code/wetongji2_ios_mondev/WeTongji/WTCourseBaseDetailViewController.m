//
//  WTCourseBaseDetailViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-7-3.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTCourseBaseDetailViewController.h"
#import "Course+Addition.h"
#import "WTCourseBaseHeaderView.h"
#import "WTCourseProfileView.h"
#import "WTSelectFriendsViewController.h"
#import "WTResourceFactory.h"
#import "WTShareEventFriendsViewController.h"

@interface WTCourseBaseDetailViewController () <WTSelectFriendsViewControllerDelegate>

@property (nonatomic, weak) WTCourseBaseHeaderView *headerView;
@property (nonatomic, weak) WTCourseProfileView *profileView;

@end

@implementation WTCourseBaseDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self configureUI];
}

#pragma mark - Properties

- (WTCourseBaseHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [self createHeaderView];
    }
    return _headerView;
}

#pragma mark - Methods to overwrite

- (WTCourseBaseHeaderView *)createHeaderView {
    return nil;
}

- (Course *)targetCourse {
    return nil;
}

- (BOOL)showMoreNavigationBarButton {
    return NO;
}

- (BOOL)showLikeNavigationBarButton {
    return NO;
}

#pragma mark - UI methods

- (void)configureUI {
    [self configureHeaderView];
    [self configureProfileView];
    [self configureScrollView];
}

- (void)configureProfileView {
    Course *course = [self targetCourse];
    WTCourseProfileView *profileView = [WTCourseProfileView createProfileViewWithCourse:course];
    [profileView resetOriginY:self.headerView.frame.size.height];
    [self.scrollView insertSubview:profileView belowSubview:self.headerView];
    self.profileView = profileView;
}

- (void)configureInviteButton {
    [self.headerView configureInviteButton];
    [self.headerView.inviteButton addTarget:self action:@selector(didClickInviteButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)configureHeaderView {
    WTCourseBaseHeaderView *headerView = self.headerView;
    [self.scrollView addSubview:headerView];
    self.headerView = headerView;
    [self.headerView.inviteButton addTarget:self action:@selector(didClickInviteButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.friendCountButton addTarget:self action:@selector(didClickFriendCountButton:) forControlEvents:UIControlEventTouchUpInside];
    
    Course *course = [self targetCourse];
    if (course.isAudit.boolValue) {
        [self.headerView.participateButton addTarget:self action:@selector(didClickParticipateButton:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)configureScrollView {
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.profileView.frame.size.height + self.profileView.frame.origin.y);
}

#pragma mark - Actions

- (void)didClickFriendCountButton:(UIButton *)sender {
    Course *course = [self targetCourse];
    WTShareEventFriendsViewController *vc = [WTShareEventFriendsViewController createViewControllerWithTargetObject:course];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didClickParticipateButton:(UIButton *)sender {
    BOOL participated = sender.selected;
    [self.headerView configureParticipateButtonStatus:participated];
    
    if (participated) {
        [self.headerView.inviteButton fadeIn];
    }
    else {
        [self.headerView.inviteButton fadeOut];
    }
    
    Course *course = [self targetCourse];
    
    sender.userInteractionEnabled = NO;
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        WTLOG(@"Set course scheduled:%d succeeded", participated);
        sender.userInteractionEnabled = YES;
        course.registeredByCurrentUser = !course.registeredByCurrentUser;
        
    } failureBlock:^(NSError *error) {
        WTLOGERROR(@"Set course scheduled:%d, reason:%@", participated, error.localizedDescription);
        sender.userInteractionEnabled = YES;
        [self.headerView configureParticipateButtonStatus:!participated];
        
        if (!participated) {
            [self.headerView.inviteButton fadeIn];
        } else {
            [self.headerView.inviteButton fadeOut];
        }
        
        [WTErrorHandler handleError:error];
    }];
    
    [request setCourseScheduled:participated courseID:course.identifier];
    [[WTClient sharedClient] enqueueRequest:request];
}

- (void)didClickInviteButton:(UIButton *)sender {
    [WTSelectFriendsViewController showWithDelegate:self];
}

#pragma mark - WTSelectFriendsViewControllerDelegate

- (void)selectFriendViewController:(WTSelectFriendsViewController *)vc
                  didSelectFriends:(NSArray *)friendArray {
    
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        WTLOG(@"Course invite success:%@", responseObject);
        [[[UIAlertView alloc] initWithTitle:@"注意" message:@"邀请好友成功" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil] show];
        [self configureInviteButton];
    } failureBlock:^(NSError *error) {
        [WTErrorHandler handleError:error];
        [self configureInviteButton];
    }];
    NSMutableArray *userIDArray = [NSMutableArray array];
    for (User *user in vc.selectedFriendsArray) {
        [userIDArray addObject:user.identifier];
    }
    Course *course = [self targetCourse];
    [request courseInvite:course.identifier inviteUserIDArray:userIDArray];
    [[WTClient sharedClient] enqueueRequest:request];
    
    [WTResourceFactory configureActivityIndicatorButton:self.headerView.inviteButton activityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.headerView.courseOutdated) {
        CGFloat briefDescriptionViewTopIndent = self.headerView.frame.size.height - HEADER_VIEW_BOTTOM_INDENT;
        if (scrollView.contentOffset.y > briefDescriptionViewTopIndent) {
            [self.headerView resetOriginY:scrollView.contentOffset.y - briefDescriptionViewTopIndent];
        } else {
            [self.headerView resetOriginY:0];
        }
    }
}

@end
