//
//  WTUserDetailViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 13-5-16.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTDetailViewController.h"

@class User;

@interface WTUserDetailViewController : WTDetailViewController

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

+ (WTUserDetailViewController *)createDetailViewControllerWithUser:(User *)user
                                                 backBarButtonText:(NSString *)backBarButtonText;

@end
