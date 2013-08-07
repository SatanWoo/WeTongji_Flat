//
//  WTHomeViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 12-12-18.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTRootViewController.h"

@interface WTHomeViewController : WTRootViewController <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

- (IBAction)didClickShowNowTabButton:(UIButton *)sender;

@end
