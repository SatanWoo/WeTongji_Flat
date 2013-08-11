//
//  WEBannerContainerView.h
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-11.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WEBannerContainerView : UIView
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

+ (WEBannerContainerView *)createBannerContainerView;
- (void)configureBannerWithObjectsArray:(NSArray *)objectsArray;
- (void)reloadItemImages;

@end
