//
//  WESeeAllSchoolEventsHeaderView.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-11.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WESeeAllSchoolEventsHeaderView.h"
#define kWESeeAllSchoolEventsHeaderViewNibName @"WESeeAllSchoolEventsHeaderView"

@implementation WESeeAllSchoolEventsHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

+ (WESeeAllSchoolEventsHeaderView *)createWESeeAllSchoolEventsHeaderView
{
    NSArray *array = [[NSBundle mainBundle]loadNibNamed:kWESeeAllSchoolEventsHeaderViewNibName
                                                  owner:nil options:nil];
    return [array lastObject];
}

- (IBAction)clickSeeAllEvent:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickSeeAllEvent)]) {
        [self.delegate didClickSeeAllEvent];
    }
}

@end
