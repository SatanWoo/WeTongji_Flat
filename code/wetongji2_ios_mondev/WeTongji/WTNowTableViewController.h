//
//  WTNowTableViewController.h
//  WeTongji
//
//  Created by 吴 wuziqi on 13-3-6.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTCoreDataTableViewController.h"

@interface WTNowTableViewController : WTCoreDataTableViewController

@property (nonatomic, assign) NSUInteger weekNumber;

@property (nonatomic, assign) CGRect targetFrame; // eggaches

- (void)scrollToNow:(BOOL)animated;

- (void)updateTableViewController;

@end
