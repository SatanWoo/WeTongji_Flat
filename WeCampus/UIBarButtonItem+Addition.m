//
//  UIBarButtonItem+Addition.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-12.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "UIBarButtonItem+Addition.h"

@implementation UIBarButtonItem (Addition)

- (UIBarButtonItem *)initBarButtonWithTarget:(id)target action:(SEL)action normalImage:(NSString *)normal
{
    self = [super init];
    if (self) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *filterNormalIconImage = [UIImage imageNamed:normal];
        [button setImage:filterNormalIconImage forState:UIControlStateNormal];
        [button setImage:filterNormalIconImage forState:UIControlStateHighlighted];
        [button setImage:filterNormalIconImage forState:UIControlStateSelected];
        [button resetWidth:filterNormalIconImage.size.width];
        
        UIView *containerView = [[UIView alloc] initWithFrame:button.frame];
        [button resetOrigin:CGPointMake(0, 1)];
        [containerView addSubview:button];
        
        self = [self initWithCustomView:containerView];
    }
    
    return self;
}


@end
