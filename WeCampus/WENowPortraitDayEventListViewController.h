//
//  WENowPortraitDayEventListViewController.h
//  WeCampus
//
//  Created by Song on 13-8-13.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTCoreDataTableViewController.h"

@interface WENowPortraitDayEventListViewController : WTCoreDataTableViewController
{
    NSDate *needDate;
}
- (void)loadDataForDate:(NSDate*)date;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
