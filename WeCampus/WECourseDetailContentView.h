//
//  WEActivityDetailContentView.h
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-15.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OHAttributedLabel.h>
#import "Course+Addition.h"

@interface WECourseDetailContentView : UITableViewCell
@property (weak, nonatomic) IBOutlet OHAttributedLabel *contentLabel;

+ (WECourseDetailContentView *)createDetailContentViewWithInfo:(Course *)course;
- (void)resetLayout:(CGFloat)percent;

@end
