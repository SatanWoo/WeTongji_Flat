//
//  WTScheduledCourseViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 13-6-21.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTCoreDataTableViewController.h"

@class User;

@interface WTScheduledCourseViewController : WTCoreDataTableViewController

+ (WTScheduledCourseViewController *)createViewControllerWithUser:(User *)user;

@end
