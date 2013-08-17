//
//  WEActivityDetailViewController.h
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-15.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WEContentViewController.h"
#import "Activity+Addition.h"

@interface WEActivityDetailViewController : WEContentViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *buttonContainerView;

+ (WEActivityDetailViewController *)createDetailViewControllerWithModel:(Activity *)act;
- (IBAction)popBack:(id)sender;

@end
