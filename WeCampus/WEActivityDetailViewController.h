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

+ (NSString *)cutTextForWeibo:(NSString *)text;
+ (WEActivityDetailViewController *)createDetailViewControllerWithModel:(Activity *)act;
- (IBAction)popBack:(id)sender;
- (IBAction)share:(id)sender;

@end
