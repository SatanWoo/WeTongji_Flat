//
//  WTActivityViewController.h
//  WeTongji
//
//  Created by Shen Yuncheng on 1/20/13.
//  Copyright (c) 2013 Tongji Apple Club. All rights reserved.
//

#import "WTCoreDataTableViewController.h"
#import "WTRootNavigationController.h"
#import "WTInnerSettingViewController.h"

@class Activity;

@interface WTActivityViewController : WTCoreDataTableViewController <WTRootNavigationControllerDelegate, WTInnerSettingViewControllerDelegate>

@property (nonatomic, readonly) NSInteger nextPage;

- (void)configureLoadDataRequest:(WTRequest *)request;

- (void)configureLoadedActivity:(Activity *)activity;

@end
