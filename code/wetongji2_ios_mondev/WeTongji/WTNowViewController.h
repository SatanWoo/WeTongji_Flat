//
//  WTNowViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 13-1-2.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTRootViewController.h"

@class Event;

@interface WTNowViewController : WTRootViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

- (void)showNowItemDetailViewWithEvent:(Event *)event;

@end
