//
//  WTOrganizationDetailViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-14.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTOrganizationDetailViewController.h"
#import "Organization+Addition.h"
#import "UIImageView+AsyncLoading.h"
#import "WTBannerView.h"
#import "WTOrganizationProfileView.h"
#import "WTOrganizationHeaderView.h"
#import <QuartzCore/QuartzCore.h>
#import "WTOrganizationActivityViewController.h"
#import "WTOrganizationNewsViewController.h"
#import "UIApplication+WTAddition.h"
#import "WTDragToLoadDecorator.h"
#import "WTLikeButtonView.h"

@interface WTOrganizationDetailViewController () <UIActionSheetDelegate, WTDragToLoadDecoratorDataSource, WTDragToLoadDecoratorDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@property (nonatomic, weak) WTOrganizationProfileView *profileView;
@property (nonatomic, weak) WTOrganizationHeaderView *headerView;
@property (nonatomic, strong) Organization *org;

@property (nonatomic, strong) WTDragToLoadDecorator *dragToLoadDecorator;

@end

@implementation WTOrganizationDetailViewController

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
}

- (void)viewDidAppear:(BOOL)animated {
    [self.dragToLoadDecorator startObservingChangesInDragToLoadScrollView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.dragToLoadDecorator stopObservingChangesInDragToLoadScrollView];
}

+ (WTOrganizationDetailViewController *)createDetailViewControllerWithOrganization:(Organization *)org
                                                                 backBarButtonText:(NSString *)backBarButtonText {
    WTOrganizationDetailViewController *result = [[WTOrganizationDetailViewController alloc] init];
    
    result.org = org;
    
    result.backBarButtonText = backBarButtonText;

    return result;
}

#pragma mark - UI methods

- (void)configureDragToLoadDecorator {
    self.dragToLoadDecorator = [WTDragToLoadDecorator createDecoratorWithDataSource:self delegate:self bottomActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.dragToLoadDecorator setBottomViewDisabled:YES immediately:YES];
}

- (void)configureUI {
    [self configureHeaderView];
    [self configureProfileView];
    [self configureScrollView];
}

- (void)configureScrollView {
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.scrollsToTop = YES;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width,
                                             self.profileView.frame.origin.y + self.profileView.frame.size.height);
}

- (void)configureHeaderView {
    WTOrganizationHeaderView *headerView = [WTOrganizationHeaderView createHeaderViewWithOrganization:self.org];
    [self.scrollView addSubview:headerView];
    self.headerView = headerView;
}

- (void)configureProfileView {
    WTOrganizationProfileView *profileView = [WTOrganizationProfileView createProfileViewWithOrganization:self.org];
    [profileView resetOriginY:self.headerView.frame.origin.y + self.headerView.frame.size.height];
    [self.scrollView addSubview:profileView];
    self.profileView = profileView;
    
    [self.profileView.newsButton addTarget:self action:@selector(didClickNewsButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.profileView.activityButton addTarget:self action:@selector(didClickActivityButton:) forControlEvents:profileView];
    [self.profileView.emailButton addTarget:self action:@selector(didClickEmailButton:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Actions

- (void)didClickActivityButton:(UIButton *)sender {
    WTOrganizationActivityViewController *vc = [WTOrganizationActivityViewController createViewControllerWithOrganization:self.org];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didClickNewsButton:(UIButton *)sender {
    WTOrganizationNewsViewController *vc = [WTOrganizationNewsViewController createViewControllerWithOrganization:self.org];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didClickEmailButton:(UIButton *)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"%@%@?", NSLocalizedString(@"Send email to ", nil), self.org.email] delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
    [sheet showFromTabBar:[UIApplication sharedApplication].rootTabBarController.tabBar];
}

#pragma mark - UIActionSheetDelegate 

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        NSString *URLString = [[NSString alloc] initWithFormat:@"mailto://%@", self.org.email];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
    }
}

#pragma mark - Methods to overwrite

- (LikeableObject *)targetObject {
    return self.org;
}

- (NSArray *)imageArrayToShare {
    UIImage *image = self.headerView.avatarImageView.image;
    if (image)
        return @[image];
    return nil;
}

- (NSString *)textToShare {
    return [NSString stringWithFormat:@"%@\n\n%@", self.org.name, self.org.about];
}

#pragma mark - WTDragToLoadDecoratorDataSource

- (UIScrollView *)dragToLoadScrollView {
    return self.scrollView;
}

#pragma mark - WTDragToLoadDecoratorDelegate

- (void)dragToLoadDecoratorDidDragDown {
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        WTLOG(@"get account info success:%@", responseObject);
        [Organization insertOrganization:responseObject[@"Account"]];
        [self.profileView updateView];
        [self.headerView updateView];
        [self configureScrollView];
        [self.likeButtonContainerView configureViewWithObject:self.org];
        [self.dragToLoadDecorator topViewLoadFinished:YES];
    } failureBlock:^(NSError *error) {
        [WTErrorHandler handleError:error];
        [self.dragToLoadDecorator topViewLoadFinished:NO];
    }];
    [request getAccount:self.org.identifier];
    [[WTClient sharedClient] enqueueRequest:request];
}

@end
