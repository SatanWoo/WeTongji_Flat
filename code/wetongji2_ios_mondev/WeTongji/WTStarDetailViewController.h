//
//  WTStarDetailViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 13-5-20.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTDetailViewController.h"

@class Star;

@interface WTStarDetailViewController : WTDetailViewController

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

+ (WTStarDetailViewController *)createDetailViewControllerWithStar:(Star *)star
                                                 backBarButtonText:(NSString *)backBarButtonText;

@end
