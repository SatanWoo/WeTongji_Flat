//
//  WEDetailTransparentHeaderView.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-16.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WEDetailTransparentHeaderView.h"

@implementation WEDetailTransparentHeaderView

+ (WEDetailTransparentHeaderView *)createTransparentHeaderView
{
    WEDetailTransparentHeaderView *view = [[[NSBundle mainBundle] loadNibNamed:@"WEDetailTransparentHeaderView" owner:nil options:nil] lastObject];
    
    return view;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

@end
