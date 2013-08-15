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

- (void)configureWithInfo:(Activity *)act
{
    [self configureAvatar];
    [self.avatar loadImageWithImageURLString:act.author.avatar];
    self.orgName.text = act.author.name;
    self.titleLabel.text = act.what;
    self.timeLabel.text = act.yearMonthDayBeginToEndTimeString;
    self.locationLabel.text = act.where;
}

- (void)configureAvatar
{
    self.avatarContainerView.layer.masksToBounds = YES;
    self.avatarContainerView.layer.cornerRadius = 6;
}
@end
