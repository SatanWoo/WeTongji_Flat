//
//  WTEventDetailViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 12-12-19.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTDetailViewController.h"

@class Activity;

@interface WTActivityDetailViewController : WTDetailViewController <UIScrollViewDelegate>

+ (WTActivityDetailViewController *)createDetailViewControllerWithActivity:(Activity *)activity
                                                         backBarButtonText:(NSString *)backBarButtonText;

@end
