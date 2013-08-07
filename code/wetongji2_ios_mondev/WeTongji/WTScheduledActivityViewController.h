//
//  WTScheduledActivityViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 13-7-1.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTActivityViewController.h"

@class User;

@interface WTScheduledActivityViewController : WTActivityViewController

+ (WTScheduledActivityViewController *)createViewControllerWithUser:(User *)user;

@end