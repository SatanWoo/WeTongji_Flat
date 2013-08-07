//
//  WTSearchHistoryView.h
//  WeTongji
//
//  Created by 王 紫川 on 13-5-12.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTSearchHistoryView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

+ (WTSearchHistoryView *)createSearchHistoryView;

@end

@interface WTSearchHistoryTableViewHeaderView : UIView

@property (nonatomic, weak) IBOutlet UILabel *searchHistoryDisplayLabel;

+ (WTSearchHistoryTableViewHeaderView *)createHeaderView;

@end
