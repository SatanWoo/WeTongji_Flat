//
//  UIBarButtonItem+Addition.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-12.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "UIBarButtonItem+Addition.h"

@implementation UIBarButtonItem (Addition)

- (id)initBarButtonWithTarget:(id)target action:(SEL)action normalImage:(NSString *)normal
{
    self = [super init];
    if (self) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *normalImage = [UIImage imageNamed:normal];
        [button setImage:normalImage forState:UIControlStateNormal];
        [button setImage:normalImage forState:UIControlStateHighlighted];
        [button setImage:normalImage forState:UIControlStateSelected];
        [button setShowsTouchWhenHighlighted:YES];
        [button resetSize:normalImage.size];
        
        UIView *containerView = [[UIView alloc] initWithFrame:button.frame];
        [containerView resetWidth:containerView.frame.size.width + 2];
        [button resetOriginXByOffset:2];
        [containerView addSubview:button];
        
        self = [self initWithCustomView:containerView];
    }
    
    return self;
}




@end
