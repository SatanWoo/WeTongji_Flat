//
//  WESearchResultOrgsViewController.h
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-29.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WEContentViewController.h"

@interface WESearchResultOrgsViewController : WEContentViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

+ (WESearchResultOrgsViewController *)createResultOrgsViewControllerWithData:(NSArray *)datas;
- (void)reloadWithDatas:(NSArray *)datas;

@end
