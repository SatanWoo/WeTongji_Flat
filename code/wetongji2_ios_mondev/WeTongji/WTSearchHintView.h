//
//  WTSearchHintView.h
//  WeTongji
//
//  Created by 王 紫川 on 13-5-8.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTSearchHintView : UIView <UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSString *searchKeyword;

+ (WTSearchHintView *)createSearchHintView;

@end
