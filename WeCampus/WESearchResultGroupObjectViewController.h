//
//  WESearchResultGroupObjectViewController.h
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-27.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WEContentViewController.h"

@interface WESearchResultGroupObjectViewController : WEContentViewController

+ (WESearchResultGroupObjectViewController *)createGroupObjectViewControllerWithData:(NSArray *)data andTitle:(NSString *)title;
- (void)reloadWithData:(NSArray *)objects;

@end
