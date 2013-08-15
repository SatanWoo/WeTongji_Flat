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

@interface WESchoolEventHeadLineView()
@property (nonatomic, strong) Activity *act;
@end

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
    self.act = act;
    self.categoryLabel.text = act.categoryString;
    [self configureCategoryColor];
    
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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    [self addGestureRecognizer:tap];
}

- (void)configureCategoryColor
{
    NSString *text = self.categoryLabel.text;
  
    if ([text isEqualToString:NSLocalizedString(@"Academics", nil)]) {
        [self.categoryLabel setTextColor:[UIColor colorWithHue:0.169 saturation:0.86 brightness:0.63 alpha:1]];
    } else if ([text isEqualToString:NSLocalizedString(@"Competition", nil)]){
        [self.categoryLabel setTextColor:[UIColor colorWithHue:0.28 saturation:0.85 brightness:0.91 alpha:1]];
    } else if ([text isEqualToString:NSLocalizedString(@"Entertainment", nil)]) {
        [self.categoryLabel setTextColor:[UIColor colorWithHue:0 saturation:0.65 brightness:0.92 alpha:1]];
    } else {
        [self.categoryLabel setTextColor:[UIColor colorWithHue:0.213 saturation:0.92 brightness:0.98 alpha:1]];
    }
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

- (IBAction)didClickShowCategory:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickShowCategoryButtonWithModel:)]) {
        [self.delegate didClickShowCategoryButtonWithModel:self.act];
    }
}

- (void)didTap:(UITapGestureRecognizer *)tap
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapToSeeDetailInfo:)]) {
        [self.delegate didTapToSeeDetailInfo:self.act];
    }
}

@end
