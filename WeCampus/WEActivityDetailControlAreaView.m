//
//  WEActivityDetailControlAreaView.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-15.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WEActivityDetailControlAreaView.h"

@implementation WEActivityDetailControlAreaView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

+ (WEActivityDetailControlAreaView *)createActivityDetailViewWithInfo:(Activity *)act
{
    WEActivityDetailControlAreaView *view = [[[NSBundle mainBundle] loadNibNamed:@"WEActivityDetailControlAreaView" owner:nil options:nil] lastObject];
    
    [view configureControlArea:act];
    return view;
}

- (void)configureControlArea:(Activity *)act
{
    self.likeCountLabel.text = act.likeCount.stringValue;
}

@end
