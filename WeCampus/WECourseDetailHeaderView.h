//
//  WEActivityDetailHeaderView.h
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-15.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course+Addition.h"

@interface WECourseDetailHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *teacherName;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIView *avatarContainerView;
@property (weak, nonatomic) IBOutlet UIView *colorContainerView;
@property (weak, nonatomic) IBOutlet UIView *infoContainerView;

+ (WECourseDetailHeaderView *)createCourseDetailViewWithInfo:(Course *)course;
- (void)resetLayout:(CGFloat)percent;

@end
