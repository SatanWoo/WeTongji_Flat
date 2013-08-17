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
@property (weak, nonatomic) IBOutlet UIView *maskView;

+ (WTSearchHistoryView *)createSearchHistoryView;
- (void)cover;
- (void)uncover;

@end

@interface WTSearchHistoryTableViewHeaderView : UIView

@property (nonatomic, weak) IBOutlet UILabel *searchHistoryDisplayLabel;

+ (WTSearchHistoryTableViewHeaderView *)createHeaderView;

@end
