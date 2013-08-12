//
//  WEActivitiesViewController.h
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-12.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WTCoreDataTableViewController.h"
#import "WTRequest.h"
#import "Activity+Addition.h"

@interface WEActivitiesViewController : WTCoreDataTableViewController

@property (nonatomic, readonly) NSInteger nextPage;

- (void)configureLoadDataRequest:(WTRequest *)request;

- (void)configureLoadedActivity:(Activity *)activity;
- (id)initWithTitle:(ActivityShowTypes)type;

@end
