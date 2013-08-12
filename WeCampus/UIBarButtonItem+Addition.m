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
        
        UIImage *filterNormalIconImage = [UIImage imageNamed:normal];
        [button setImage:filterNormalIconImage forState:UIControlStateNormal];
        [button setImage:filterNormalIconImage forState:UIControlStateHighlighted];
        [button setImage:filterNormalIconImage forState:UIControlStateSelected];
        [button resetSize:filterNormalIconImage.size];
        
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 2, 0, 2)];
        
        self = [self initWithCustomView:button];
    }
    
    return self;
}

- (id)initWithImage:(NSString *)imageName selector:(SEL)selector target:(id)target
{
    self = [super init];
    if (self) {
        NSString *highlightedName = [imageName stringByAppendingString:@"_hl"];
        UIImage *image = [UIImage imageNamed:imageName];
        UIImage *high = [UIImage imageNamed:highlightedName];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        if (high) {
            [button setBounds:[[UIImageView alloc] initWithImage:high].bounds];
            [button setImage:high forState:UIControlStateHighlighted];
        } else {
            [button setBounds:[[UIImageView alloc] initWithImage:image].bounds];
        }
        button.frame = CGRectMake(0, 0, button.bounds.size.width + 6, button.bounds.size.height + 6);
        [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
        [button setImage:image forState:UIControlStateNormal];
        [button setImage:image forState:UIControlStateSelected];
        self = [self initWithCustomView:button];
    }
    return self;
}


@end
