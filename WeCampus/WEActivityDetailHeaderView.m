//
//  WEActivityDetailHeaderView.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-15.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WEActivityDetailHeaderView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AsyncLoading.h"
#import "Organization+Addition.h"

@implementation WEActivityDetailHeaderView

+ (WEActivityDetailHeaderView *)createActivityDetailViewWithInfo:(Activity *)act
{
    WEActivityDetailHeaderView *view = [[[NSBundle mainBundle] loadNibNamed:@"WEActivityDetailHeaderView" owner:nil options:nil] lastObject];
    [view configureWithInfo:act];
    return view;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

#define maxRightLabelBorder 305
#define kSpan 10

- (void)configureWithInfo:(Activity *)act
{
    self.colorContainerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"green_point"]];
    
    [self configureAvatar];
    [self.avatar loadImageWithImageURLString:act.author.avatar];
    
    self.orgName.text = act.author.name;
    self.titleLabel.text = act.what;
    self.timeLabel.text = act.yearMonthDayBeginToEndTimeString;
    self.locationLabel.text = act.where;
    
    [self resizeLabel:self.orgName];
    [self resizeLabel:self.timeLabel];
    [self resizeLabel:self.titleLabel];
    [self resizeLabel:self.locationLabel];
    
    [self.colorContainerView resetHeight:self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + kSpan];
    [self.infoContainerView resetOriginY:
     self.colorContainerView.frame.origin.y + self.colorContainerView.frame.size.height];
    
    [self resetHeight:self.infoContainerView.frame.origin.y + self.infoContainerView.frame.size.height];
}

- (void)resizeLabel:(UILabel *)label
{
    [label sizeToFit];
    [label resetWidth:maxRightLabelBorder - label.frame.origin.x];
}

#define kBorderRadius 20
- (void)configureAvatar
{
    self.avatarContainerView.layer.masksToBounds = YES;
    self.avatarContainerView.layer.cornerRadius = kBorderRadius;
}

#pragma mark - Public Method
- (void)resetLayout:(CGFloat)percent
{
    if (percent <= 0) return;
    if (percent > 1) percent = 1;
    
    self.infoContainerView.alpha = 1 - percent;
    self.titleLabel.alpha = 1 - 0.5 * percent;
    self.avatarContainerView.alpha = 1 - percent;
    self.orgName.alpha = 1 - percent;
}

@end
