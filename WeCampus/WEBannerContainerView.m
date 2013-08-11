//
//  WEBannerContainerView.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-11.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WEBannerContainerView.h"
#define kWEBannerContainerViewNibName @"WEBannerContainerView"

@implementation WEBannerContainerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

+ (WEBannerContainerView *)createBannerContainerView
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:kWEBannerContainerViewNibName owner:self options:nil];
    return [array lastObject];
}

@end
