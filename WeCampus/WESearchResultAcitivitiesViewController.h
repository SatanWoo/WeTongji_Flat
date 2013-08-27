//
//  WESearchResultAcitivitiesViewController.h
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-27.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WEContentViewController.h"

@interface WESearchResultAcitivitiesViewController : WEContentViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

+ (WESearchResultAcitivitiesViewController *)createResultActsViewControllerWithData:(NSArray *)datas;
- (void)reloadWithDatas:(NSArray *)datas;

@end
