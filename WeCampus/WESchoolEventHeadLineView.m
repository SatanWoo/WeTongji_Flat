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

- (void)configureViewWithActivity:(Activity *)act
{
    self.categoryLabel.text = act.categoryString;
    self.titleLabel.text = act.what;
    self.timeLabel.text = [act yearMonthDayBeginToEndTimeString];
    
    [self.timeLabel sizeToFit];
    [self.timeLabel sizeToFit];
    [self.avatar loadImageWithImageURLString:act.image];
}

@end
