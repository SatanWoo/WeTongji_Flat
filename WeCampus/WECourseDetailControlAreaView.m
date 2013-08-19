//
//  WEActivityDetailControlAreaView.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-15.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WECourseDetailControlAreaView.h"

@implementation WECourseDetailControlAreaView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

+ (WECourseDetailControlAreaView *)createCourseDetailViewWithInfo:(Course *)act
{
    WECourseDetailControlAreaView *view = [[[NSBundle mainBundle] loadNibNamed:@"WECourseDetailControlAreaView" owner:nil options:nil] lastObject];
    
    [view configureControlArea:act];
    return view;
}

- (void)configureControlArea:(Course *)act
{
    self.likeCountLabel.text = act.likeCount.stringValue;
}

@end
