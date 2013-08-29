//
//  WEHomeRootViewController.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-11.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WEHomeRootViewController.h"
#import "WEBannerContainerView.h"
#import "WESeeAllSchoolEventsHeaderView.h"
#import "Event+Addition.h"
#import "Activity+Addition.h"
#import "News+Addition.h"
#import "Star+Addition.h"
#import "Course+Addition.h"
#import "Organization+Addition.h"
#import "Object+Addition.h"
#import "Organization+Addition.h"
#import "Advertisement+Addition.h"
#import "WTRequest.h"
#import "WTClient.h"
#import "WESchoolEventHeadLineView.h"
#import "WEActivitiesViewController.h"
#import "NSUserDefaults+WTAddition.h"
#import "WEActivityDetailViewController.h"
#import "UIApplication+WTAddition.h"

@interface WEHomeRootViewController () <WESeeAllSchoolEventsHeaderViewDelegate, WESchoolEventHeadLineViewDelegate>
@property (nonatomic, strong) WEBannerContainerView *bannerContainerView;
@property (nonatomic, strong) WESeeAllSchoolEventsHeaderView *seeAllHeaderView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic, strong) NSMutableArray *headlineViewArray;
@property (nonatomic, assign) BOOL shouldLoadHomeItems;
@property (nonatomic, assign) BOOL isLoadingHomeItems;
@property (nonatomic, assign) BOOL isVisible;
@property (nonatomic, strong) NSDictionary *homeResponseDict;

@property (nonatomic, strong) NSTimer *autoScrollTimer;
@end

@implementation WEHomeRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
         self.shouldLoadHomeItems = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Home", nil);
    [self configureBannerView];
    [self configureRrefreshControl];
    [self configureScrollView];
    [self setUpAutoScrollTimer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateBannerView];
    [self updateScrollView];
    
    if (self.shouldLoadHomeItems) {
        [self loadHomeSelectedItems];
        self.shouldLoadHomeItems = NO;
    }
    
    self.isVisible = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self refillViews];
    self.isVisible = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Property
- (NSMutableArray *)headlineViewArray
{
    if (!_headlineViewArray) {
        _headlineViewArray = [[NSMutableArray alloc] init];
    }
    return _headlineViewArray;
}

- (WESeeAllSchoolEventsHeaderView *)seeAllHeaderView
{
    if (!_seeAllHeaderView) {
        _seeAllHeaderView = [WESeeAllSchoolEventsHeaderView createWESeeAllSchoolEventsHeaderView];
        _seeAllHeaderView.delegate = self;
    }
    return _seeAllHeaderView;
}

#pragma mark - Load data methods
- (void)refillViews {
    if (!self.homeResponseDict)
        return;
    
    [self adjustScrollView];
    [self.refreshControl endRefreshing];
    
    NSDictionary *resultDict = self.homeResponseDict;
    
    // Refill headline views
    [Object setAllObjectsFreeFromHolder:[WESchoolEventHeadLineView class]];
    
    NSArray *activityInfoArray = resultDict[@"Activities"];
    for (NSDictionary *infoDict in activityInfoArray) {
        Activity *activity = [Activity insertActivity:infoDict];
        [activity setObjectHeldByHolder:[WESchoolEventHeadLineView class]];
    }

    [self fillHeadLineViews];
    
    // Refill banner view
    [Object setAllObjectsFreeFromHolder:[WEBannerContainerView class]];
    
    NSDictionary *bannerActivityInfo = resultDict[@"BannerActivity"];
    if ([bannerActivityInfo isKindOfClass:[NSDictionary class]]) {
        Activity *bannerActivity = [Activity insertActivity:bannerActivityInfo];
        [bannerActivity setObjectHeldByHolder:[WEBannerContainerView class]];
    }
    
    NSDictionary *bannerNewsInfo = resultDict[@"BannerInformation"];
    if ([bannerNewsInfo isKindOfClass:[NSDictionary class]]) {
        News *bannerNews = [News insertNews:bannerNewsInfo];
        [bannerNews setObjectHeldByHolder:[WEBannerContainerView class]];
    }
    
    NSArray *bannerAdvertisementArray = resultDict[@"BannerAdvertisements"];
    for (NSDictionary *adInfo in bannerAdvertisementArray) {
        Advertisement *ad = [Advertisement insertAdvertisement:adInfo];
        [ad setObjectHeldByHolder:[WEBannerContainerView class]];
    }
    
    [self fillBannerView];
    
    self.homeResponseDict = nil;
}

- (void)loadHomeSelectedItems {
    if (self.isLoadingHomeItems)
        return;
    self.isLoadingHomeItems = YES;
    [self.refreshControl beginRefreshing];
    
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        self.homeResponseDict = (NSDictionary *)responseObject;
        
        if (!self.isVisible)
            [self refillViews];
        else if (self.isVisible &&
                 [Object getAllObjectsHeldByHolder:[WEBannerContainerView class] objectEntityName:@"Object"].count == 0) {
            [self refillViews];
        }
        
        NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
        [[NSUserDefaults standardUserDefaults] setLastHomeUpdateTime:currentTime];
        
        self.isLoadingHomeItems = NO;
    } failureBlock:^(NSError *error) {
        self.shouldLoadHomeItems = YES;
        self.isLoadingHomeItems = NO;
        
    }];
    [request getHomeRecommendation];
    [[WTClient sharedClient] enqueueRequest:request];
}

#pragma mark - UI methods

- (void)configureRrefreshControl
{
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    [self.refreshControl resetOriginY:0];
    [self.scrollView addSubview:self.refreshControl];
}

- (void)adjustScrollView {
    self.scrollView.contentOffset = CGPointZero;
}

- (void)configureScrollView {
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.scrollsToTop = NO;
    [self updateScrollView];
}

- (void)updateScrollView {
    
    [self adjustScrollView];
    
    UIView *bottomView = self.headlineViewArray.lastObject;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, bottomView.frame.origin.y + bottomView.frame.size.height);
}

- (void)fillHeadLineViews {
    NSArray *activityArray = [Object getAllObjectsHeldByHolder:[WESchoolEventHeadLineView class] objectEntityName:@"Activity"];
    activityArray = [activityArray sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"likeCount" ascending:NO]]];
    
    [self.seeAllHeaderView resetOriginY:self.bannerContainerView.frame.size.height];
    [self.scrollView addSubview:self.seeAllHeaderView];
    
    int i = 0;
    for (Activity *act in activityArray) {
        WESchoolEventHeadLineView *activityHeadlineView = [WESchoolEventHeadLineView createWESchoolEventHeadLineViewWithModel:act];
        activityHeadlineView.delegate = self;
        [self.headlineViewArray addObject:activityHeadlineView];
        [activityHeadlineView resetOriginY:self.seeAllHeaderView.frame.origin.y + self.seeAllHeaderView.frame.size.height + i * activityHeadlineView.frame.size.height];
        [self.scrollView addSubview:activityHeadlineView];
        i++;
    }
    
    [self updateScrollView];
}

- (void)configureBannerView {
    self.bannerContainerView = [WEBannerContainerView createBannerContainerView];
    [self.bannerContainerView resetOrigin:CGPointZero];
    [self.scrollView addSubview:self.bannerContainerView];
    [self fillBannerView];
}

- (void)fillBannerView {
    [self.bannerContainerView configureBannerWithObjectsArray:[Object getAllObjectsHeldByHolder:[WEBannerContainerView class] objectEntityName:@"Object"]];
}

- (void)updateBannerView {
    [self.bannerContainerView reloadItemImages];
}


- (void)pushDetailViewControllerWithModelObject:(Object *)modelObject {
    if ([modelObject isKindOfClass:[Activity class]]) {
        WEActivityDetailViewController *vc = [WEActivityDetailViewController createDetailViewControllerWithModel:(Activity *)modelObject];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([modelObject isKindOfClass:[Advertisement class]]) {
        Advertisement *ad = (Advertisement *)modelObject;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ad.website]];
    }
}
#pragma mark - WESeeAllSchoolEventsHeaderViewDelegate
- (void)didClickSeeAllEvent
{
    [[NSUserDefaults standardUserDefaults] setActivityShowTypes:ActivityShowTypesAll];
    WEActivitiesViewController *vc = [[WEActivitiesViewController alloc] initWithTitle:ActivityShowTypesAll];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - WESchoolEventHeadLineViewDelegate
- (void)didClickShowCategoryButtonWithModel:(Activity *)act
{
    [[NSUserDefaults standardUserDefaults] setActivityShowTypes:act.category.integerValue];
    WEActivitiesViewController *vc = [[WEActivitiesViewController alloc] initWithTitle:act.category.integerValue];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didTapToSeeDetailInfo:(Activity *)act
{
    [self pushDetailViewControllerWithModelObject:act];
}

#pragma mark - Refresh Control
- (void)refreshData
{
    [self loadHomeSelectedItems];
    [self performSelector:@selector(refillViews) withObject:nil afterDelay:2.0f];
}

#pragma mark - Auto Scroll Timer
- (void)setUpAutoScrollTimer {
    // 设定 8 秒刷新频率
    self.autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:8
                                                            target:self
                                                          selector:@selector(autoScroll:)
                                                          userInfo:nil
                                                           repeats:YES];
    
}

- (void)autoScroll:(NSTimer *)timer {
    [self.bannerContainerView autoScroll];
}

@end
