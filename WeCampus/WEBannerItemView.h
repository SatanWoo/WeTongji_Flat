//
//  WEBannerItemView.h
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-11.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Object;

@interface WEBannerItemView : UIView
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *org;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (copy, nonatomic) NSString *imageURLString;

+ (WEBannerItemView *)createBannerItemView;
- (void)configureViewWithModelObject:(Object *)object;
@end
