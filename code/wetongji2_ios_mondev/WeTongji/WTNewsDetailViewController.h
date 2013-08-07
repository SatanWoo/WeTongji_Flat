//
//  WTNewsDetailViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 13-4-18.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTDetailViewController.h"

@class News;
@class OHAttributedLabel;

@interface WTNewsDetailViewController : WTDetailViewController

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *contentLabelContainerView;
@property (nonatomic, weak) IBOutlet OHAttributedLabel *contentLabel;

+ (WTNewsDetailViewController *)createDetailViewControllerWithNews:(News *)news
                                                 backBarButtonText:(NSString *)backBarButtonText;

@end
