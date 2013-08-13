//
//  WENowPortraitWeekListViewController.h
//  WeCampus
//
//  Created by Song on 13-8-12.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WENowPortraitWeekListViewController;

@protocol  WENowPortraitWeekListViewControllerDelegate <NSObject>

- (void)weekListViewController:(WENowPortraitWeekListViewController*)vc dateDidChanged:(NSDate*)date;

@end


@interface WENowPortraitWeekListViewController : UIViewController

@property (nonatomic,weak) id<WENowPortraitWeekListViewControllerDelegate> delegate;

@property (nonatomic,retain,readonly) NSDate *selectedDate;


- (void)selectPreviousDay;
- (void)selectNextDay;

@end
