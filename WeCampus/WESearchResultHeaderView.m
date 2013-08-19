//
//  WESearchResultHeaderView.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-19.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WESearchResultHeaderView.h"

@implementation WESearchResultHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (WESearchResultHeaderView *)createSearchResultHeaderViewWithName:(NSString *)name
{
    WESearchResultHeaderView *view = [[[NSBundle mainBundle] loadNibNamed:@"WESearchResultHeaderView" owner:self options:nil] lastObject];
    
    [view configureContent:name];
    return view;
}

- (void)configureContent:(NSString *)name
{
    self.nameLabel.text = name;
    [self.nameLabel sizeToFit];
}

@end
