//
//  WESchoolEventHeadLineView.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-11.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WESchoolEventHeadLineView.h"
#import "UIImageView+AsyncLoading.h"
#define kWESchoolEventHeadLineViewNibName @"WESchoolEventHeadLineView"

@implementation WESchoolEventHeadLineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

+ (WESchoolEventHeadLineView *)createWESchoolEventHeadLineViewWithModel:(Activity *)act
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:kWESchoolEventHeadLineViewNibName owner:nil options:nil];
    WESchoolEventHeadLineView *headerLineView = [array lastObject];
    [headerLineView configureViewWithActivity:act];
    return headerLineView;
}

#define maxLabelRightBorder 306

- (void)configureViewWithActivity:(Activity *)act
{
    self.categoryLabel.text = act.categoryString;
    self.titleLabel.text = act.what;
    self.timeLabel.text = [act yearMonthDayBeginToEndTimeString];
    
    [self.timeLabel sizeToFit];
    
    if (act.image == nil) {
        [self configureNoImageLayout];
    } else {
        [self.avatar loadImageWithImageURLString:act.image];
        [self configureImageLayout];
    }
    
    [self.titleLabel sizeToFit];
    [self.titleLabel resetWidth:maxLabelRightBorder - self.titleLabel.frame.origin.x];
}

#define originXWithImage 76
#define originXWithoutImage 26

- (void)configureImageLayout
{
    [self.titleLabel resetOriginX:originXWithImage];
    [self.timeLabel resetOriginX:originXWithImage];
}

- (void)configureNoImageLayout
{
    [self.titleLabel resetOriginX:originXWithoutImage];
    [self.timeLabel resetOriginX:originXWithoutImage];
}

@end
