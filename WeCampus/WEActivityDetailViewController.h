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
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

+ (WEActivityDetailViewController *)createDetailViewControllerWithModel:(Activity *)act;

@end
