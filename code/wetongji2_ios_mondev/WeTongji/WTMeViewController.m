//
//  WTMeViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-1-2.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTMeViewController.h"
#import "WTFriendListViewController.h"
#import "WTCoreDataManager.h"
#import "WTResourceFactory.h"
#import "WTUserProfileHeaderView.h"
#import "WTCurrentUserProfileView.h"
#import "NSNotificationCenter+WTAddition.h"
#import "UIApplication+WTAddition.h"
#import <WeTongjiSDK/WeTongjiSDK.h>
#import "UIImage+ProportionalFill.h"
#import "User+Addition.h"
#import "WTMeSettingViewController.h"
#import "WTFriendListViewController.h"
#import "WTLikeListViewController.h"
#import "NSUserDefaults+WTAddition.h"
#import "WTDragToLoadDecorator.h"
#import "WTScheduledActivityViewController.h"
#import "WTScheduledCourseViewController.h"

@interface WTMeViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, WTInnerSettingViewControllerDelegate, WTRootNavigationControllerDelegate, WTDragToLoadDecoratorDataSource, WTDragToLoadDecoratorDelegate>

@property (nonatomic, weak) WTUserProfileHeaderView *profileHeaderView;
@property (nonatomic, weak) WTCurrentUserProfileView *profileView;
@property (nonatomic, readonly) UIButton *settingButton;

@property (nonatomic, strong) WTDragToLoadDecorator *dragToLoadDecorator;

@property (nonatomic, assign) BOOL delayHandelCurrentUserDidChange;

@end

@implementation WTMeViewController

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
    [self configureUI];
    [self configureDragToLoadDecorator];
    
    [NSNotificationCenter registerCurrentUserDidChangeNotificationWithSelector:@selector(hanldeCurrentUserDidChangeNotification:) target:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.dragToLoadDecorator startObservingChangesInDragToLoadScrollView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.dragToLoadDecorator stopObservingChangesInDragToLoadScrollView];
}

#pragma mark - Public methods

#pragma mark - Notification handler

- (void)hanldeCurrentUserDidChangeNotification:(NSNotification *)notification {
    if (!self.settingButton.selected) {
        [self didClickSettingButton:self.settingButton];
        self.delayHandelCurrentUserDidChange = YES;
    } else if ([WTCoreDataManager sharedManager].currentUser) {
        [self configureUI];
    }
}

#pragma mark - Properties

- (UIButton *)settingButton {
    return (UIButton *)self.navigationItem.rightBarButtonItem.customView.subviews.lastObject;
}

#pragma mark - UI methods

- (void)configureUI {
    [self configureNavigationBar];
    [self configureProfileHeaderView];
    [self configureProfileView];
    [self configureScrollView];
}

- (void)configureDragToLoadDecorator {
    self.dragToLoadDecorator = [WTDragToLoadDecorator createDecoratorWithDataSource:self delegate:self bottomActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.dragToLoadDecorator setBottomViewDisabled:YES immediately:YES];
}

- (void)configureProfileView {
    [self.profileView removeFromSuperview];
    WTCurrentUserProfileView *profileView = [WTCurrentUserProfileView createProfileViewWithUser:[WTCoreDataManager sharedManager].currentUser];
    [profileView resetOriginY:self.profileHeaderView.frame.size.height];
    [self.scrollView addSubview:profileView];
    self.profileView = profileView;
    
    [profileView.friendButton addTarget:self action:@selector(didClickFriendButton:) forControlEvents:UIControlEventTouchUpInside];
    [profileView.likedActiviyButton addTarget:self action:@selector(didClickLikedActivityButton:) forControlEvents:UIControlEventTouchUpInside];
    [profileView.likedNewsButton addTarget:self action:@selector(didClickLikedNewsButton:) forControlEvents:UIControlEventTouchUpInside];
    [profileView.likedStarButton addTarget:self action:@selector(didClickLikedStarButton:) forControlEvents:UIControlEventTouchUpInside];
    [profileView.likedOrganizationButton addTarget:self action:@selector(didClickLikedOrganizationButton:) forControlEvents:UIControlEventTouchUpInside];
    [profileView.likedUserButton addTarget:self action:@selector(didClickLikedUserButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [profileView.scheduledActivityButton addTarget:self action:@selector(didClickScheduledActivityButton:) forControlEvents:UIControlEventTouchUpInside];
    [profileView.scheduledCourseButton addTarget:self action:@selector(didClickScheduledCourseButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)configureScrollView {
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.profileView.frame.origin.y + self.profileView.frame.size.height);
}

- (void)configureProfileHeaderView {
    [self.profileHeaderView removeFromSuperview];
    WTUserProfileHeaderView *headerView = [WTUserProfileHeaderView createProfileHeaderViewWithUser:[WTCoreDataManager sharedManager].currentUser];
    [self.scrollView addSubview:headerView];
    self.profileHeaderView = headerView;
    
    [headerView.functionButton addTarget:self action:@selector(didClickChangeAvatarButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)configureNavigationBar {
    self.navigationItem.titleView = [WTResourceFactory createNavigationBarTitleViewWithText:[WTCoreDataManager sharedManager].currentUser.name];
    [self configureSettingBarButton];
}

- (void)configureSettingBarButton {
    self.navigationItem.rightBarButtonItem = [WTResourceFactory createSettingBarButtonWithTarget:self action:@selector(didClickSettingButton:)];
}

#pragma mark - Actions

- (void)didClickScheduledActivityButton:(UIButton *)sender {
    WTScheduledActivityViewController *vc = [WTScheduledActivityViewController createViewControllerWithUser:[WTCoreDataManager sharedManager].currentUser];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didClickScheduledCourseButton:(UIButton *)sender {
    WTScheduledCourseViewController *vc = [WTScheduledCourseViewController createViewControllerWithUser:[WTCoreDataManager sharedManager].currentUser];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didClickLikedActivityButton:(UIButton *)sender {
    User *currentUser = [WTCoreDataManager sharedManager].currentUser;
    WTLikeListViewController *vc = [WTLikeListViewController createViewControllerWithUser:currentUser likeObjectClass:@"Activity" backButtonText:currentUser.name];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didClickLikedNewsButton:(UIButton *)sender {
    User *currentUser = [WTCoreDataManager sharedManager].currentUser;
    WTLikeListViewController *vc = [WTLikeListViewController createViewControllerWithUser:currentUser likeObjectClass:@"News" backButtonText:currentUser.name];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didClickLikedBillboardPostButton:(UIButton *)sender {
    User *currentUser = [WTCoreDataManager sharedManager].currentUser;
    WTLikeListViewController *vc = [WTLikeListViewController createViewControllerWithUser:currentUser likeObjectClass:@"BillboardPost" backButtonText:currentUser.name];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didClickLikedStarButton:(UIButton *)sender {
    User *currentUser = [WTCoreDataManager sharedManager].currentUser;
    WTLikeListViewController *vc = [WTLikeListViewController createViewControllerWithUser:currentUser likeObjectClass:@"Star" backButtonText:currentUser.name];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didClickLikedOrganizationButton:(UIButton *)sender {
    User *currentUser = [WTCoreDataManager sharedManager].currentUser;
    WTLikeListViewController *vc = [WTLikeListViewController createViewControllerWithUser:currentUser likeObjectClass:@"Organization" backButtonText:currentUser.name];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didClickLikedUserButton:(UIButton *)sender {
    User *currentUser = [WTCoreDataManager sharedManager].currentUser;
    WTLikeListViewController *vc = [WTLikeListViewController createViewControllerWithUser:currentUser likeObjectClass:@"User" backButtonText:currentUser.name];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didClickFriendButton:(UIButton *)sender {
    User *currentUser = [WTCoreDataManager sharedManager].currentUser;
    WTFriendListViewController *vc = [WTFriendListViewController createViewControllerWithUser:currentUser backButtonText:currentUser.name];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didClickSettingButton:(UIButton *)sender {
    WTRootNavigationController *nav = (WTRootNavigationController *)self.navigationController;
    
    if (sender.selected) {
        sender.selected = NO;
        
        WTMeSettingViewController *vc = [[WTMeSettingViewController alloc] init];
        vc.delegate = self;
        [nav showInnerModalViewController:vc sourceViewController:self disableNavBarType:WTDisableNavBarTypeLeft];
        
    } else {
        [nav hideInnerModalViewController];
    }
}

- (void)didClickChangeAvatarButton:(UIButton *)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:NSLocalizedString(@"Camera", nil), NSLocalizedString(@"Photo Album", nil), nil];
    [actionSheet showFromTabBar:[UIApplication sharedApplication].rootTabBarController.tabBar];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == actionSheet.cancelButtonIndex)
        return;
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.delegate = self;
    ipc.allowsEditing = YES;
    
    if(buttonIndex == 1) {
        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else if(buttonIndex == 0) {
        ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    [self presentModalViewController:ipc animated:YES];
}

#pragma mark - UIImagePickerController delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *edittedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    edittedImage = [edittedImage imageScaledToFitSize:CROP_AVATAR_SIZE];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        WTLOG(@"Upload avatar success:%@", responseObject);
        NSDictionary *responseDict = responseObject;
        User *currentUser = [User insertUser:responseDict[@"User"]];
        [WTCoreDataManager sharedManager].currentUser = currentUser;
        [self.profileHeaderView updateView];
        [self.profileHeaderView configureFunctionButton];
    } failureBlock:^(NSError *error) {
        WTLOGERROR(@"Upload avatar failure:%@", error.description);
        [WTErrorHandler handleError:error];
        [self.profileHeaderView configureFunctionButton];
    }];
    [request updateUserAvatar:edittedImage];
    [[WTClient sharedClient] enqueueRequest:request];
    
    [WTResourceFactory configureActivityIndicatorButton:self.profileHeaderView.functionButton activityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
}

#pragma mark - WTInnerSettingViewControllerDelegate

- (void)innerSettingViewController:(WTInnerSettingViewController *)controller didFinishSetting:(BOOL)modified {
    if ([WTClient sharedClient].usingTestServer != [NSUserDefaults useTestServer]) {
        [WTClient refreshSharedClient];
    }
    
    if (self.delayHandelCurrentUserDidChange) {
        if (![WTCoreDataManager sharedManager].currentUser) {
            [[UIApplication sharedApplication].rootTabBarController clickTabWithName:WTRootTabBarViewControllerHome];
        } else {
            [self configureUI];
        }
        self.delayHandelCurrentUserDidChange = NO;
        return;
    }
    
    if (modified && ![[NSUserDefaults standardUserDefaults] scheduleNotificationEnabled]) {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
    
    if ([[WTCoreDataManager sharedManager] isCurrentUserInfoDifferentFromDefaultInfo]) {
        WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
            WTLOG(@"Update user info success:%@", responseObject);
            [User insertUser:responseObject[@"User"]];
            [[WTCoreDataManager sharedManager] configureCurrentUserDefaultInfo];
            [self.profileHeaderView updateView];
            [self configureSettingBarButton];
        } failureBlock:^(NSError *error) {
            [WTErrorHandler handleError:error];
            [self configureSettingBarButton];
        }];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [request updateUserEmail:[defaults getCurrentUserEmail] weiboName:[defaults getCurrentUserSinaWeibo] phoneNum:[defaults getCurrentUserPhone] qqAccount:[defaults getCurrentUserQQ] motto:[defaults getCurrentUserMotto] dorm:[defaults getCurrentDorm]];
        [[WTClient sharedClient] enqueueRequest:request];
        
        [WTResourceFactory configureActivityIndicatorBarButton:self.navigationItem.rightBarButtonItem activityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
}

#pragma mark - WTRootNavigationControllerDelegate

- (UIScrollView *)sourceScrollView {
    return self.scrollView;
}

- (void)didHideInnderModalViewController {
    if (self.settingButton.selected == NO) {
        self.settingButton.selected = YES;
    } else if (self.notificationButton.selected == YES) {
        self.notificationButton.selected = NO;
    }
}

#pragma mark - WTDragToLoadDecoratorDataSource

- (UIScrollView *)dragToLoadScrollView {
    return self.scrollView;
}

#pragma mark - WTDragToLoadDecoratorDelegate

- (void)dragToLoadDecoratorDidDragDown {
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        WTLOG(@"get user info success:%@", responseObject);
        [User insertUser:responseObject[@"User"]];
        [[WTCoreDataManager sharedManager] configureCurrentUserDefaultInfo];
        [self.profileView updateView];
        [self.profileHeaderView updateView];
        [self.dragToLoadDecorator topViewLoadFinished:YES];
    } failureBlock:^(NSError *error) {
        [WTErrorHandler handleError:error];
        [self.dragToLoadDecorator topViewLoadFinished:NO];
    }];
    [request getUserInformation];
    [[WTClient sharedClient] enqueueRequest:request];
}

@end
