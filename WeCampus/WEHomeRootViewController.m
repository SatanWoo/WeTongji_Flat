//
//  WEHomeRootViewController.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-11.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WEHomeRootViewController.h"
#import "WEBannerContainerView.h"
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

@interface WEHomeRootViewController ()
@property (nonatomic, strong) WEBannerContainerView *bannerContainerView;

@property (nonatomic, strong) NSMutableArray *homeSelectViewArray;
@property (nonatomic, assign) BOOL shouldLoadHomeItems;
@property (nonatomic, assign) BOOL isLoadingHomeItems;
@property (nonatomic, assign) BOOL isVisible;
@property (nonatomic, strong) NSDictionary *homeResponseDict;
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
    [self configureBannerView];
    [self configureScrollView];
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

#pragma mark - Load data methods

- (void)refillViews {
    if (!self.homeResponseDict)
        return;
    
    //[self adjustScrollView];
    
    NSDictionary *resultDict = self.homeResponseDict;
    
    // Refill home select views
//    [Object setAllObjectsFreeFromHolder:[WTHomeSelectContainerView class]];
//    
//    NSArray *activityInfoArray = resultDict[@"Activities"];
//    for (NSDictionary *infoDict in activityInfoArray) {
//        Activity *activity = [Activity insertActivity:infoDict];
//        [activity setObjectHeldByHolder:[WTHomeSelectContainerView class]];
//    }
//    
//    NSArray *newsInfoArray = resultDict[@"Information"];
//    for (NSDictionary *infoDict in newsInfoArray) {
//        News *news = [News insertNews:infoDict];
//        [news setObjectHeldByHolder:[WTHomeSelectContainerView class]];
//    }
//    
//    NSObject *starInfoObject = resultDict[@"Person"];
//    if ([starInfoObject isKindOfClass:[NSArray class]]) {
//        NSArray *starInfoArray = (NSArray *)starInfoObject;
//        for (NSDictionary *infoDict in starInfoArray) {
//            Star *star = [Star insertStar:infoDict];
//            [star setObjectHeldByHolder:[WTHomeSelectContainerView class]];
//        }
//    } else if ([starInfoObject isKindOfClass:[NSDictionary class]]) {
//        NSDictionary *starInfoDict = (NSDictionary *)starInfoObject;
//        Star *star = [Star insertStar:starInfoDict];
//        [star setObjectHeldByHolder:[WTHomeSelectContainerView class]];
//    }
//    
//    NSDictionary *popularOrgDict = resultDict[@"AccountPopular"];
//    Organization *org = [Organization insertOrganization:popularOrgDict];
//    [org setObjectHeldByHolder:[WTHomeSelectContainerView class]];
//    
//    [self fillHomeSelectViews];
    
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
    
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        self.homeResponseDict = (NSDictionary *)responseObject;
        
        if (!self.isVisible)
            [self refillViews];
        else if (self.isVisible &&
                 [Object getAllObjectsHeldByHolder:[WEBannerContainerView class] objectEntityName:@"Object"].count == 0) {
            //[self reloadHomeSelectItemAnimation];
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

- (void)adjustScrollView {
    [self.scrollView setScrollEnabled:NO];
    [self.scrollView setScrollEnabled:YES];
    self.scrollView.contentOffset = CGPointZero;
    //[self scrollViewDidScroll:self.scrollView];
}

//- (void)reloadHomeSelectItemAnimation {
//    self.view.userInteractionEnabled = NO;
//    UIImageView *screenShootImageView = [[UIImageView alloc] initWithImage:[UIImage screenShoot]];
//    [screenShootImageView resetSize:[UIScreen mainScreen].bounds.size];
//    [[UIApplication sharedApplication].keyWindow addSubview:screenShootImageView];
//    [UIView animateWithDuration:0.5f animations:^{
//        screenShootImageView.alpha = 0;
//    } completion:^(BOOL finished) {
//        [screenShootImageView removeFromSuperview];
//        self.view.userInteractionEnabled = YES;
//    }];
//}

- (void)configureScrollView {
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.scrollsToTop = NO;
    [self updateScrollView];
}

- (void)updateScrollView {
    UIView *bottomView = self.homeSelectViewArray.lastObject;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, bottomView.frame.origin.y + bottomView.frame.size.height);
}

//- (void)configureHomeSelectViews {
//    [self configureActivitySelect];
//    [self configureNewsSelect];
//    [self configureFeaturedSelect];
//    [self fillHomeSelectViews];
//}
//
//- (void)updateHomeSelectViews {
//    NSInteger index = 0;
//    for (WTHomeSelectContainerView *homeSelectContainerView in self.homeSelectViewArray) {
//        [homeSelectContainerView resetOrigin:CGPointMake(0, self.nowContainerView.frame.size
//                                                         .height + self.nowContainerView.frame.origin.y + homeSelectContainerView.frame.size.height * index)];
//        [homeSelectContainerView updateItemViews];
//        index++;
//    }
//}

//- (void)fillHomeSelectViews {
//    WTHomeSelectContainerView *activitySelectContainerView = self.homeSelectViewArray[0];
//    NSArray *activityArray = [Object getAllObjectsHeldByHolder:[WTHomeSelectContainerView class] objectEntityName:@"Activity"];
//    activityArray = [activityArray sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"likeCount" ascending:NO]]];
//    [activitySelectContainerView configureItemInfoArray:activityArray];
//    
//    WTHomeSelectContainerView *newsSelectContainerView = self.homeSelectViewArray[1];
//    NSArray *newsArray = [Object getAllObjectsHeldByHolder:[WTHomeSelectContainerView class] objectEntityName:@"News"];
//    newsArray = [newsArray sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"likeCount" ascending:NO]]];
//    [newsSelectContainerView configureItemInfoArray:newsArray];
//    
//    WTHomeSelectContainerView *featuredSelectContainerView = self.homeSelectViewArray[2];
//    NSMutableArray *featurerSelectInfoArray = [NSMutableArray arrayWithArray:[Object getAllObjectsHeldByHolder:[WTHomeSelectContainerView class] objectEntityName:@"Star"]];
//    [featurerSelectInfoArray addObjectsFromArray:[Object getAllObjectsHeldByHolder:[WTHomeSelectContainerView class] objectEntityName:@"Organization"]];
//    [featuredSelectContainerView configureItemInfoArray:featurerSelectInfoArray];
//}
//
//- (void)configureNewsSelect {
//    WTHomeSelectContainerView *containerView = [WTHomeSelectContainerView createHomeSelectContainerViewWithCategory:WTHomeSelectContainerViewCategoryNews];
//    containerView.delegate = self;
//    [self.homeSelectViewArray addObject:containerView];
//    [self.scrollView addSubview:containerView];
//}
//
//- (void)configureFeaturedSelect {
//    WTHomeSelectContainerView *containerView = [WTHomeSelectContainerView createHomeSelectContainerViewWithCategory:WTHomeSelectContainerViewCategoryFeatured];
//    containerView.delegate = self;
//    [self.homeSelectViewArray addObject:containerView];
//    [self.scrollView addSubview:containerView];
//}
//
//- (void)configureActivitySelect {
//    WTHomeSelectContainerView *containerView = [WTHomeSelectContainerView createHomeSelectContainerViewWithCategory:WTHomeSelectContainerViewCategoryActivity];
//    containerView.delegate = self;
//    [self.homeSelectViewArray addObject:containerView];
//    [self.scrollView addSubview:containerView];
//}

- (void)configureBannerView {
    self.bannerContainerView = [WEBannerContainerView createBannerContainerView];
    [self.bannerContainerView resetOrigin:CGPointZero];
    //self.bannerContainerView.delegate = self;
    [self.scrollView addSubview:self.bannerContainerView];
    [self fillBannerView];
}

- (void)fillBannerView {
    [self.bannerContainerView configureBannerWithObjectsArray:[Object getAllObjectsHeldByHolder:[WEBannerContainerView class] objectEntityName:@"Object"]];
}

- (void)updateBannerView {
    [self.bannerContainerView reloadItemImages];
}

//- (void)configureNavigationBar {
//    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WTNavigationBarLogo"]];
//    self.navigationItem.titleView = logoImageView;
//}
//
//- (void)configureNowView {
//    WTHomeNowContainerView *nowContainerView = [WTHomeNowContainerView createHomeNowContainerViewWithDelegate:self];
//    [self.scrollView insertSubview:nowContainerView belowSubview:self.bannerContainerView];
//    [nowContainerView resetOriginY:self.bannerContainerView.frame.size.height];
//    self.nowContainerView = nowContainerView;
//    [self updateNowView];
//}
//
//- (void)updateNowView {
//    NSArray *events = [Event getTodayEvents];
//    [self.nowContainerView configureNowContainerViewWithEvents:events];
//    if (!events) {
//        [self.nowContainerView resetOriginY:self.bannerContainerView.frame.origin.y + self.bannerContainerView.frame.size.height - self.nowContainerView.frame.size.height];
//    } else {
//        [self.nowContainerView resetOriginY:self.bannerContainerView.frame.origin.y + self.bannerContainerView.frame.size.height];
//    }
//}
//
//- (void)pushDetailViewControllerWithModelObject:(Object *)modelObject {
//    if ([modelObject isKindOfClass:[Activity class]]) {
//        WTActivityDetailViewController *vc = [WTActivityDetailViewController createDetailViewControllerWithActivity:(Activity *)modelObject backBarButtonText:nil];
//        [self.navigationController pushViewController:vc animated:YES];
//    } else if ([modelObject isKindOfClass:[News class]]) {
//        WTNewsDetailViewController *vc = [WTNewsDetailViewController createDetailViewControllerWithNews:(News *)modelObject backBarButtonText:nil];
//        [self.navigationController pushViewController:vc animated:YES];
//    } else if ([modelObject isKindOfClass:[Organization class]]) {
//        WTOrganizationDetailViewController *vc = [WTOrganizationDetailViewController createDetailViewControllerWithOrganization:(Organization *)modelObject backBarButtonText:nil];
//        [self.navigationController pushViewController:vc animated:YES];
//    } else if([modelObject isKindOfClass:[Star class]]) {
//        WTStarDetailViewController *vc = [WTStarDetailViewController createDetailViewControllerWithStar:(Star *)modelObject backBarButtonText:nil];
//        [self.navigationController pushViewController:vc animated:YES];
//    } else if ([modelObject isKindOfClass:[Advertisement class]]) {
//        Advertisement *ad = (Advertisement *)modelObject;
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ad.website]];
//    }
//}


@end
