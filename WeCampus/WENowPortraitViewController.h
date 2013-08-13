//
//  WENowPortraitViewController.h
//  WeCampus
//
//  Created by Song on 13-8-12.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WENowPortraitWeekListViewController.h"
#import "WENowPortraitDayEventListViewController.h"

@interface WENowPortraitViewController : UIViewController<WENowPortraitWeekListViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *weekTitleContainerView;
@property (weak, nonatomic) IBOutlet UIView *dayEventListContainerView;


@end
