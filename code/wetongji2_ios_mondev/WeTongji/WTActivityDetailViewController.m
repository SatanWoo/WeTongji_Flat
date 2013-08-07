//
//  WTEventDetailViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 12-12-19.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "WTActivityDetailViewController.h"
#import "WTResourceFactory.h"
#import "WTLikeButtonView.h"
#import "Activity+Addition.h"
#import <WeTongjiSDK/WeTongjiSDK.h>
#import "NSString+WTAddition.h"
#import "WTCoreDataManager.h"
#import "WTActivityDetailDescriptionView.h"
#import "WTDetailImageViewController.h"
#import "WTActivityHeaderView.h"
#import "WTActivityImageRollView.h"
#import "WTOrganizationDetailViewController.h"
#import "WTSelectFriendsViewController.h"
#import "WTShareEventFriendsViewController.h"

@interface WTActivityDetailViewController () <WTDetailImageViewControllerDelegate, WTSelectFriendsViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@property (nonatomic, weak) WTActivityHeaderView *headerView;
@property (nonatomic, strong) WTActivityImageRollView *imageRollView;
@property (nonatomic, strong) WTActivityDetailDescriptionView *detailDescriptionView;

@property (nonatomic, strong) Activity *activity;

- (IBAction)didClickOrganizerIndicator;
- (IBAction)didClickLocationIndicator;

@end

@implementation WTActivityDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+ (WTActivityDetailViewController *)createDetailViewControllerWithActivity:(Activity *)activity
                                                         backBarButtonText:(NSString *)backBarButtonText {
    if (!activity)
        return nil;
    
    WTActivityDetailViewController *result = [[WTActivityDetailViewController alloc] init];
    result.activity = activity;
    result.backBarButtonText = backBarButtonText;
    
    return result;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configureUI];
}

#pragma mark - UI methods

- (void)configureUI {
    [self configureHeaderView];
    [self configureImageRollView];
    [self configureDetailDescriptionView];
    [self configureScrollView];
}

- (void)configureScrollView {
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.detailDescriptionView.frame.origin.y + self.detailDescriptionView.frame.size.height);
}

#pragma mark Configure header view

- (void)configureInviteButton {
    [self.headerView configureInviteButton];
    [self.headerView.inviteButton addTarget:self action:@selector(didClickInviteButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)configureHeaderView {
    self.headerView = [WTActivityHeaderView createHeaderViewWithActivity:self.activity];
    [self.scrollView addSubview:self.headerView];
    
    [self.headerView.inviteButton addTarget:self action:@selector(didClickInviteButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.participateButton addTarget:self action:@selector(didClickParticipateButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.friendCountButton addTarget:self action:@selector(didClickFriendCountButton:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark Configure image roll view

- (void)configureImageRollView {
    if (self.activity.image) {
        // TODO:
        self.imageRollView = [WTActivityImageRollView createImageRollViewWithImageURLStringArray:@[self.activity.image]];
        [self.imageRollView resetOrigin:CGPointMake(0, self.headerView.frame.origin.y + self.headerView.frame.size.height)];

        [self.scrollView insertSubview:self.imageRollView atIndex:0];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTagImageRollView:)];
        [self.imageRollView.scrollView addGestureRecognizer:tapGestureRecognizer];
    }
}

#pragma mark Configure detail descriptioin view

- (void)configureDetailDescriptionView {
    self.detailDescriptionView = [WTActivityDetailDescriptionView createDetailDescriptionViewWithActivity:self.activity];
    if (self.imageRollView) {
        [self.detailDescriptionView resetOriginY:self.imageRollView.frame.origin.y + self.imageRollView.frame.size.height];
    } else {
        [self.detailDescriptionView resetOriginY:self.headerView.frame.size.height];
    }
    [self.scrollView insertSubview:self.detailDescriptionView atIndex:0];
    
    [self.detailDescriptionView.organizerButton addTarget:self action:@selector(didClickOrganizerButton:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.headerView.activityOutdated) {
        CGFloat briefDescriptionViewTopIndent = self.headerView.frame.size.height - HEADER_VIEW_BOTTOM_INDENT;
        if (scrollView.contentOffset.y > briefDescriptionViewTopIndent) {
            [self.headerView resetOriginY:scrollView.contentOffset.y - briefDescriptionViewTopIndent];
        } else {
            [self.headerView resetOriginY:0];
        }
    }
}

#pragma mark - Handle gesture methods

- (void)didTagImageRollView:(UITapGestureRecognizer *)gesture {
    WTActivityImageRollItemView *currentImageRollItemView = [self.imageRollView currentItemView];
    UIImageView *currentImageView = currentImageRollItemView.imageView;
    CGRect imageViewFrame = [self.view convertRect:currentImageView.frame fromView:currentImageView.superview];
    imageViewFrame.origin.y += 64.0f;
    
    [WTDetailImageViewController showDetailImageViewWithImageURLString:self.activity.image
                                                         fromImageView:currentImageView
                                                              fromRect:imageViewFrame
                                                              delegate:self];
}

#pragma mark - Actions

- (void)didClickOrganizerButton:(UIButton *)sender {
    WTOrganizationDetailViewController *vc = [WTOrganizationDetailViewController createDetailViewControllerWithOrganization:self.activity.author backBarButtonText:self.activity.what];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didClickInviteButton:(UIButton *)sender {
    [WTSelectFriendsViewController showWithDelegate:self];
}

- (void)didClickFriendCountButton:(UIButton *)sender {
    WTShareEventFriendsViewController *vc = [WTShareEventFriendsViewController createViewControllerWithTargetObject:self.activity];
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
    
    sender.userInteractionEnabled = NO;
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        WTLOG(@"Set activitiy scheduled:%d succeeded", participated);
        sender.userInteractionEnabled = YES;
        self.activity.scheduledByCurrentUser = !self.activity.scheduledByCurrentUser;
        
    } failureBlock:^(NSError *error) {
        WTLOGERROR(@"Set activitiy scheduled:%d, reason:%@", participated, error.localizedDescription);
        sender.userInteractionEnabled = YES;
        [self.headerView configureParticipateButtonStatus:!participated];
        
        if (!participated) {
            [self.headerView.inviteButton fadeIn];
            self.activity.scheduledByCurrentUser = YES;
        }
        else {
            [self.headerView.inviteButton fadeOut];
            self.activity.scheduledByCurrentUser = NO;
        }
        
        [WTErrorHandler handleError:error];
    }];
    
    [request setActivityScheduled:participated activityID:self.activity.identifier];
    [[WTClient sharedClient] enqueueRequest:request];
}

- (void)didClickOrganizerIndicator {
    NSLog(@"Organizer Indicator button clicked");
}

- (void)didClickLocationIndicator {
    NSLog(@"Location Indicator button clicked");
}

#pragma mark - WTDetailImageViewControllerDelegate

- (void)detailImageViewControllerDidDismiss:(NSUInteger)currentPage {
    self.imageRollView.scrollView.contentOffset = CGPointMake(self.imageRollView.frame.size.width * currentPage, 0);
    self.imageRollView.pageControl.currentPage = currentPage;
    [self.imageRollView reloadItemImages];
}

#pragma mark - Methods to overwrite

- (LikeableObject *)targetObject {
    return self.activity;
}

- (NSArray *)imageArrayToShare {
    UIImage *image = self.imageRollView.currentItemView.imageView.image;
    if (image)
        return @[image];
    return nil;
}

- (NSString *)textToShare {
    return [NSString stringWithFormat:@"%@\n\n%@\n\n%@\n\n%@", self.activity.what, self.activity.where, self.activity.yearMonthDayBeginToEndTimeString, self.activity.content];
}

#pragma mark - WTSelectFriendsViewControllerDelegate

- (void)selectFriendViewController:(WTSelectFriendsViewController *)vc
                  didSelectFriends:(NSArray *)friendArray {
    
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        WTLOG(@"Activity invite success:%@", responseObject);
        [[[UIAlertView alloc] initWithTitle:@"注意" message:@"邀请好友成功" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil] show];
        [self configureInviteButton];
    } failureBlock:^(NSError *error) {
        [WTErrorHandler handleError:error];
        [self configureInviteButton];
    }];
    NSMutableArray *userIDArray = [NSMutableArray array];
    for (User *user in friendArray) {
        [userIDArray addObject:user.identifier];
    }
    [request activityInvite:self.activity.identifier inviteUserIDArray:userIDArray];
    [[WTClient sharedClient] enqueueRequest:request];
    
    [WTResourceFactory configureActivityIndicatorButton:self.headerView.inviteButton activityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
}

@end
