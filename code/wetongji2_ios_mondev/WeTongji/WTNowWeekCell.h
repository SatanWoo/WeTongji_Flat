//
//  WTNowWeekCell.h
//  WeTongji
//
//  Created by 王 紫川 on 13-4-15.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTNowTableViewController.h"

@interface WTNowWeekCell : UITableViewCell

@property (nonatomic, readonly) WTNowTableViewController *tableViewController;

- (void)configureCellWithWeekNumber:(NSUInteger)weekNumber;

- (void)scrollToNow:(BOOL)animated;

- (void)cellDidAppear;

@end
