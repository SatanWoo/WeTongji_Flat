//
//  WEActivityDetailViewController.h
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-15.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WEContentViewController.h"
#import "Course+Addition.h"

@interface WECourseDetailViewController : WEContentViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *buttonContainerView;

+ (WECourseDetailViewController *)createDetailViewControllerWithModel:(Course *)act;
- (IBAction)popBack:(id)sender;

@end
