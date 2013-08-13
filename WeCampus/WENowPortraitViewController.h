//
//  WENowPortraitViewController.h
//  WeCampus
//
//  Created by Song on 13-8-12.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WENowPortraitWeekListViewController.h"

@interface WENowPortraitViewController : UIViewController<WENowPortraitWeekListViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *weekTitleContainerView;
- (IBAction)previousDay:(id)sender;
- (IBAction)nextDay:(id)sender;

@end
